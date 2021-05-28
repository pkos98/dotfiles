old_cwd=$(pwd)
cd "${BASH_SOURCE%/*}/" || exit                            # cd into the bundle and use relative paths

echo "[+] Installing trizen aur package manager..."
git clone https://aur.archlinux.org/trizen-git.git && cd trizen-git && makepkg -si

echo "[+] Installing packages..."
packages=$(tr "\n" " " < pkglist)
sudo trizen -Syua "$packages"

echo "[+] Setting up zsh as default terminal along with prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
chsh -s /bin/zsh

echo "[+] Installing dotfiles manager..."
pip install --user dotfiles

echo "[+] Applying dotfiles"
dotfiles --repo="/home/$USER/src/dotfiles"
echo -n "  -> Do you want to apply the dotfiles? y/n"; read apply_dotfiles
[ $apply_dotfiles = "y" ] && dotfiles sync --repo="/home/$USER/src/dotfiles"

echo "[+] Installing paq package manager for neovim..."
git clone https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
nvim -c ":PaqInstall"

echo "[+] Installing some language servers..."
source /usr/share/nvm/init-nvm.sh
nvm use node
npm i -g bash-language-server vscode-json-languageserver
raco pkg install --auto racket-langserver

echo "[+] Installing pacman hook"
[ -d /etc/pacman.d/hooks ] || sudo mkdir /etc/pacman.d/hooks
sudo cp ../install/50-nvim-clean.hook /etc/pacman.d/hooks/

cd "$old_cwd"
