old_cwd=$(pwd)
cd "${BASH_SOURCE%/*}/" || exit                            # cd into the bundle and use relative paths

echo "[+] Installing trizen aur package manager..."
git clone https://aur.archlinux.org/trizen-git.git && cd trizen-git && makepkg -si

echo "[+] Installing packages..."
packages=$(tr "\n" " " < pkglist)
sudo trizen -Syua "$packages"

echo "[+] Setting up zsh  as default terminal along with prezto..."
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

echo "[+] Installing dotfiles manager..."
pip install --user dotfiles

echo "[+] Applying dotfiles"
export PATH="$PATH:$HOME/.local/bin"
dotfiles sync --dry-run --repo="/home/$USER/src/dotfiles"
echo "  Do you want to apply the dotfiles? y/n"
read $apply_dotfiles
[ $apply_dotfiles = "y" ] && dotfiles sync --repo="/home/pkos98/src/dotfiles"

cd "$old_cwd"
