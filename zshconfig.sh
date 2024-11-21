install_packages() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y $1
  elif command -v yum > /dev/null 2>&1; then
    sudo yum install -y $1
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S $1 --noconfirm
  elif command -v dnf > /dev/null 2>&1; then
    sudo dnf install -y $1
  else
    echo "Could not find a package manager to install packages with."
    exit 1
  fi

  if [ $? -ne 0 ]; then
    echo "Failed to install $1"
    exit 1
  fi
}

# Check and install required packages
for pkg in zsh git curl; do
  if ! command -v $pkg > /dev/null 2>&1; then
    echo "$pkg is not installed. Installing $pkg..."
    install_packages $pkg
  fi
done

# Backup existing .zshrc if it exists
if [ -f ~/.zshrc ]; then
  echo "Backing up existing .zshrc..."
  mv ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# Copy new zshrc
cp ./zshrc ~/.zshrc

# Install Oh-My-Zsh if not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh is already installed"
fi

# Install plugins if they don't exist
declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["fast-syntax-highlighting"]="https://github.com/zdharma/fast-syntax-highlighting"
  ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d ~/.oh-my-zsh/custom/plugins/$plugin ]; then
    echo "Installing $plugin..."
    git clone ${plugins[$plugin]} ~/.oh-my-zsh/custom/plugins/$plugin
  else
    echo "$plugin is already installed"
  fi
done

echo "Setup completed successfully!"

