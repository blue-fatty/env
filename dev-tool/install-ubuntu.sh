# Run script with sudo
# sudo bash install-ubuntu.sh

# Install tmux, zsh
apt-get update && apt-get install -y \
    tmux \
    zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Change default shell to zsh
#chsh -s $(which zsh) $USER

# tmux config
git clone --recursive https://github.com/tony/tmux-config.git ~/.tmux \
    && ln -s ~/.tmux/.tmux.conf ~/.tmux.conf \
    && cd ~/.tmux \
    && git submodule init \
    && cd ~/.tmux/vendor/tmux-mem-cpu-load \
    && cmake . \
    && make \
    && make install

# Install powerline fonts
git clone https://github.com/blue-fatty/fonts.git --depth=1 \
    && cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts

# Install spf13-vim
curl https://j.mp/spf13-vim3 -L -o - | zsh