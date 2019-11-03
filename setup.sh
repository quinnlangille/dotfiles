# This is the base setup file for everyday tooling
# This needs to be run in order to use any of the dotfiles in this repo!

# Install Homebrew
if command -v brew &>/dev/null; then
    echo "Homebrew already installed at $(which brew)!";
else
    sh -c "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"";
fi

# Install Git
if command -v git &>/dev/null;then
    echo "Git already installed at $(which git)!"
else 
    brew install git
fi

# Setup git
echo "⌨️Type in your first and last name"
read full_name

echo "⌨️Type in your email address"
read email

git config --global user.email $email
git config --global user.name $full_name

# Install Tooling
brew install lsd; # replaces ls in .zshrc
brew install bat; # replaces cat in .zshrc
brew install the_silver_searcher; # grep upgrade, lives along side grep

# Install oh-my-zsh
if command -v brew &>/dev/null; then
    echo "ZSH already installed at $(which zsh)";
else 
    brew install zsh;
    chsh -s $(which zsh);
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install zsh plugins
 git clone "https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
 git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
 git clone "https://github.com/lukechilds/zsh-nvm.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zlugins/zsh-nvm"
 git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Install ZSH prompt and yarn
if command -v yarn &>/dev/null; then
    echo "Yarn already installed at $(which yarn)";
else
    npm install -g yarn
fi;
yarn add global pureprompt;

# Install vim
if command -v vim &>/dev/null; then
    echo "Vim already installed at $(which vim)!"
else 
    brew install macvim;
fi

# Install tmux
if command -v tmux &>/dev/null; then
    echo "Tmux already installed at $(which tmux)";
else 
    brew install tmux;
fi

# Set up YouCompleteMe
if command -v cmake &>/dev/null; then
    echo "Cmake already installed at $(which cmake)";
else 
    brew install cmake;
fi

# Compile YCM
. ~/.vim/bundle/YouCompleteMe/install.py --ts-completer ----rust-completer 

if ($1 === "--rust"); then
    sh -c "./rust-setup.sh";
fi

echo "👏 Setup all done!"
