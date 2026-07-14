-- #=========================================
-- #            Auto-Commands               #
-- #=========================================

-- Enable treesitter highlight for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})

-- Set conceallevel for helm files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm",
  callback = function() vim.opt_local.conceallevel = 2 end,
})

-- Filetype associations
vim.filetype.add({
  extension = {
    json = "jsonc",
  },
  pattern = {
    [".*/%.github/workflows/.*%.yml"] = "yaml.ghaction",
    [".*/%.github/workflows/.*%.yaml"] = "yaml.ghaction",
  },
})

-- Auto-format Elixir files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ex", "*.exs", "*.heex", "*.eex" },
  callback = function(args) require("conform").format({ bufnr = args.buf }) end,
})

-- Auto-create missing directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_mkdir", { clear = true }),
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      if vim.v.cmdbang == 1 then
        vim.fn.mkdir(dir, "p")
      else
        local answer = vim.fn.input("'" .. dir .. "' does not exist. Create? [y/N] ")
        if answer:match("^[yY]") then vim.fn.mkdir(dir, "p") end
      end
    end
  end,
})

-- Statusline indicator when recording a macro
local lualine = require("lualine")
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    lualine.refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    ---@diagnostic disable-next-line: undefined-field
    local timer = vim.uv.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        lualine.refresh({
          place = { "statusline" },
        })
      end)
    )
  end,
})

-- #=========================================
-- #      Interactive Kubernetes Explain    #
-- #=========================================

local function find_k8s_kind_in_node(node, bufnr)
  if not node then return nil end
  if node:type() == "block_mapping_pair" then
    local key_node = node:named_child(0)
    if key_node and vim.treesitter.get_node_text(key_node, bufnr) == "kind" then
      local val_node = node:named_child(1)
      if val_node then
        local val = vim.treesitter.get_node_text(val_node, bufnr)
        return val:gsub("^%s*(.-)%s*$", "%1")
      end
    end
  end
  for child in node:iter_children() do
    local res = find_k8s_kind_in_node(child, bufnr)
    if res then return res end
  end
  return nil
end

local function explain_k8s_field(recursive)
  local ft = vim.bo.filetype
  if ft ~= "yaml" and ft ~= "helm" then
    vim.notify("Not a YAML or Helm file", vim.log.levels.WARN)
    return
  end

  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    vim.notify("No Treesitter node under cursor", vim.log.levels.WARN)
    return
  end

  -- Construct YAML path
  local path_parts = {}
  local current = node
  while current do
    if current:type() == "block_mapping_pair" then
      local key_node = current:named_child(0)
      if key_node then
        local key = vim.treesitter.get_node_text(key_node, 0)
        table.insert(path_parts, 1, key)
      end
    end
    current = current:parent()
  end
  local yaml_path = table.concat(path_parts, ".")

  -- Search for kind
  local kind = nil
  local bufnr = vim.api.nvim_get_current_buf()
  current = node
  while current do
    if current:type() == "document" then
      kind = find_k8s_kind_in_node(current, bufnr)
      if kind then break end
    end
    local parent = current:parent()
    if not parent then
      kind = find_k8s_kind_in_node(current, bufnr)
      break
    end
    current = parent
  end

  -- Fallback kind search
  if not kind or not kind:match("^[%w%-]+$") then
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

    for i = cursor_line, 1, -1 do
      local line = lines[i]
      local k = line and line:match("^kind:%s*([%w%-]+)")
      if k then
        kind = k
        break
      end
    end

    if not kind then
      for i = cursor_line + 1, #lines do
        local line = lines[i]
        local k = line and line:match("^kind:%s*([%w%-]+)")
        if k then
          kind = k
          break
        end
      end
    end
  end

  if kind then
    kind = kind:gsub("^['\"]", ""):gsub("['\"]$", "")
    kind = kind:lower()
  end

  if not kind then
    vim.notify("Could not detect Kubernetes resource kind (e.g. Pod, Deployment)", vim.log.levels.WARN)
    return
  end

  local query = kind
  if yaml_path ~= "" then
    if not yaml_path:match("^" .. kind .. "%.") and not yaml_path:match("^" .. kind .. "$") then
      query = kind .. "." .. yaml_path
    else
      query = yaml_path
    end
  end

  vim.notify("Explaining: " .. query, vim.log.levels.INFO)
  local call_tbl = { "kubectl", "explain" }
  if recursive then table.insert(call_tbl, "--recursive") end
  table.insert(call_tbl, query)
  vim.system(call_tbl, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        local err = obj.stderr or "Unknown error"
        vim.notify("kubectl explain failed: " .. err, vim.log.levels.ERROR)
        return
      end

      local lines_out = {}
      for line in obj.stdout:gmatch("[^\r\n]+") do
        table.insert(lines_out, line)
      end

      if #lines_out == 0 then
        vim.notify("No documentation found for " .. query, vim.log.levels.WARN)
        return
      end

      local opts = {
        border = "rounded",
        focusable = true,
        focus = true,
      }

      local fbuf, fwin = vim.lsp.util.open_floating_preview(lines_out, "markdown", opts)
      if fwin then
        vim.wo[fwin].wrap = true
        vim.api.nvim_set_current_win(fwin)
      end
      if fbuf and fwin then
        vim.keymap.set(
          "n",
          "q",
          function() pcall(vim.api.nvim_win_close, fwin, true) end,
          { buffer = fbuf, silent = true }
        )
        vim.keymap.set(
          "n",
          "<Esc>",
          function() pcall(vim.api.nvim_win_close, fwin, true) end,
          { buffer = fbuf, silent = true }
        )
      end
    end)
  end)
end

vim.keymap.set("n", "<leader>ke", explain_k8s_field, { desc = "Kubernetes Explain under cursor" })
vim.keymap.set(
  "n",
  "<leader>kr",
  function() explain_k8s_field(true) end,
  { desc = "Kubernetes Explain --recursive under cursor" }
)
