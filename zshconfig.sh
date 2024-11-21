install_packages() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y $1
    return
  elif command -v yum > /dev/null 2>&1; then
    sudo yum install -y $1
    return
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S $1 --noconfirm
    return
  elif command -v dnf > /dev/null 2>&1; then
    sudo dnf install -y $1
    return
  fi

  echo "Could not find a package manager to install packages with."
  exit 1
}

if ! command -v zsh > /dev/null 2>&1; then
  echo "zsh is not installed. Installing zsh..."
  install_packages zsh
fi

if ! command -v git > /dev/null 2>&1; then
  echo "git is not installed. Installing git..."
  install_packages git
fi

if ! command -v curl > /dev/null 2>&1; then
  echo "curl is not installed. Installing curl..."
  install_packages curl
fi

mv ~/.zshrc ~/.zshrc.bak
mv ./zshrc ~/.zshrc

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "Installing fast-syntax-highlighting..."
git clone https://github.com/zdharma/fast-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting

echo "installing zsh-autocomplete..."
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

