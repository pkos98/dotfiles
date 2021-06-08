defmodule Dotman do

  def main() do
    args = System.argv()
    {parsed, argv, invalid} = OptionParser.parse(System.argv(), strict: [dotfiles_dir: :string, home_dir: :string, verbose: :boolean, dry_run: :boolean, overwrite: :boolean])
    cond do
      not Enum.empty?(invalid) -> IO.puts(:stderr, "Invalid arguments: #{inspect(invalid)}"); exit(1)
      true -> 
        dry_run = Keyword.get(parsed, :dry_run, false)
        dotfiles_dir = Keyword.get(parsed, :dotfiles_dir, "")
        home_dir = Keyword.get(parsed, :home_dir, "")
        overwrite = Keyword.get(parsed, :overwrite, false)
        IO.puts(
        """
        Syncing with:
        dotfiles_dir: #{dotfiles_dir}
        home_dir: #{home_dir}
        dry_run: #{dry_run}
        overwrite: #{overwrite}
        """)
        if File.exists?(dotfiles_dir) do
          _sync(dotfiles_dir, home_dir, dry_run, overwrite)
        else
          IO.puts(:stderr, "Invalid dotfile directory")
          exit(-1)
        end
    end
  end

  defp _sync(from, to, dry_run, overwrite) do
    Path.wildcard(Path.join(from, "**"))
    |> Enum.filter(&(!File.dir?(&1))) # filter OUT directories
    |> Enum.map(&(Path.relative_to(&1, from))) # get paths relative to dotfiles_dir
    |> Enum.each(fn rel_dotfile -> _link_file(from, to, rel_dotfile, dry_run, overwrite) end)
  end

  defp _link_file(dotfiles_dir, home_dir, rel_dotfile, dry_run, overwrite) do
    existing_dotfile = Path.join(dotfiles_dir, rel_dotfile)
    [head | tail] = Path.split(rel_dotfile)
    new_symlink = (Path.split(home_dir) ++ ["." <> head | tail]) |> Path.join()
    case (not dry_run) && File.mkdir_p(Path.dirname(new_symlink)) do
      :ok ->
        case File.exists?(new_symlink) do
          true -> 
            if overwrite, do: IO.puts("Overwriting existing file #{new_symlink} with symlink to #{existing_dotfile}"); File.rm!(new_symlink); File.ln_s!(existing_dotfile, new_symlink)
          false ->
          IO.puts("Creating new symlink from #{new_symlink} -> #{existing_dotfile}")
          File.ln_s!(existing_dotfile, new_symlink)
        end
      false ->
        if dry_run do
          cond do
            File.exists?(new_symlink) && overwrite -> IO.puts("Overwrite existing #{new_symlink} with symlink to #{existing_dotfile}")
            File.exists?(new_symlink) && not overwrite -> IO.puts("NOT creating symlink from #{new_symlink} -> #{existing_dotfile} because file exists and overwrite flag is not set")
          end
        else
          IO.puts(:stderr, "Error creating directory")
        end
    end
  end

end

Dotman.main()
