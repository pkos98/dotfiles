sudo pacman -S base-devel

echo "[+] Installing trizen aur package manager..."
git clone https://aur.archlinux.org/trizen-git.git && cd trizen-git && makepkg -si

echo "[+] Installing packages..."
trizen -S --needed --noconfirm - < pkglist

echo "[+] Installing some language servers..."
sudp npm i -g bash-language-server vscode-json-languageserver
raco pkg install --auto racket-langserver

echo "[+] Installing paq package manager for neovim..."
git clone https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim

echo "[+] Installing python package needed for i3bar..."
pip install --user i3pystatus basiciw

echo "[+] Expanding dotfile symlinks..."
elixir dotman.exs --dotfiles-dir "$USER/src/dotfiles" --home-dir "$HOME"

echo "[+] Setting up zsh as default terminal along with prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
chsh -s /bin/zsh
