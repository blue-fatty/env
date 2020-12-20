# For user: root
# Do not execute this file directly. Pick commands you need to execute.


# YUM (mirror is `yum.ksyun.cn`: very fast)
yum install -y epel-release
yum install -y htop tmux


# Configurate DNS
vim /etc/resolve.conf
## faster for TUNA, but `yum.ksyun.cn` will be failed to resolve
## content of `/etc/resolve.conf`
; generated by /usr/sbin/dhclient-script
search bm_dhcp_domain
#nameserver 8.8.8.8
nameserver 114.114.114.114
nameserver 198.18.254.30
nameserver 198.18.254.3


# Install latest Miniconda
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/install-conda.sh \
    && chmod +x /tmp/install-conda.sh \
    && /tmp/install-conda.sh -b -p $HOME/.miniconda \
    && rm -f /tmp/install-conda.sh \
    && export PATH="$HOME/.miniconda/bin:$PATH" \
    && conda init \
    && cat <<EOT >> ~/.condarc
channels:
  - defaults
show_channel_urls: true
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOT


# Pypi (pip) mirror
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple


# Install gcc>=4.9
##  -v:version -p:prefix -j:jobs
curl https://raw.githubusercontent.com/hughplay/env/master/scripts/centos/install-gcc.sh | bash -s -- -v 6.5.0


# Environment variables (in `~/.bashrc` or `~/.zshrc` if you use zsh)
export PATH=~/.local/bin:$PATH
export PATH=/usr/local/cuda-10.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH


# Install opencv
conda install -c conda-forge opencv


# Monitor
## CPU monitor
htop
## GPU monitor
pip install gpustat
gpustat -p -i 0.3

# Docker Hub Mirror
# https://gist.github.com/y0ngb1n/7e8f16af3242c7815e7ca2f0833d3ea6
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://1nj0zren.mirror.aliyuncs.com",
        "https://docker.mirrors.ustc.edu.cn",
        "http://f1361db2.m.daocloud.io",
        "https://dockerhub.azk8s.cn"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

# Other development tools (optional)

## Install tmux>2.4
bash <(curl -s https://raw.githubusercontent.com/hughplay/env/master/scripts/centos/install-tmux.sh)
cp ~/.local/bin/tmux /usr/local/bin
## Install tmux-config (better key bindings), see: https://github.com/hughplay/tmux-config
git clone https://github.com/hughplay/tmux-config.git /tmp/tmux-config \
    && bash /tmp/tmux-config/install.sh \
    && rm -rf /tmp/tmux-config
## Use powerline fonts to make symbols work (!!!Install in your personal computer, not server!!!)
git clone https://github.com/hughplay/fonts.git /tmp/fonts --depth=1 \
    && sh /tmp/fonts/install.sh \
    && cd - \
    && rm -rf /tmp/fonts
## Recommonded terminal for Mac: iTerm2 - https://iterm2.com/downloads.html

## Install zsh
yum install -y zsh
## Install oh-my-zsh
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /tmp/install-oh-my-zsh.sh --no-check-certificate \
    && sh /tmp/install-oh-my-zsh.sh --unattended \
    && rm -f /tmp/install-oh-my-zsh.sh \
    && wget https://raw.githubusercontent.com/oskarkrawczyk/honukai-iterm/master/honukai.zsh-theme -O ~/.oh-my-zsh/themes/honukai.zsh-theme --no-check-certificate \
    && sed -i.bak '/ZSH_THEME/s/\".*\"/\"honukai\"/' ~/.zshrc
## Change default shell to zsh
command -v zsh | sudo tee -a /etc/shells \
    && sudo chsh -s "$(command -v zsh)" "${USER}"
## or change the default shell of tmux (without sudo permission)
echo "set -g default-shell `which zsh`" >> ~/.tmux.conf
## write conda initilization script into `~/.zsh`
conda init

## Install node, yarn
conda install -y nodejs
npm install -g yarn yrm
## Change npm mirror (`yrm test`)
yrm use taobao


# SSH Tips

## SSH without inputing password
ssh-copy-id root@<target_ip>

## SSH through hosts
## PC --> server A (with public IP) --> server B (internal access only)
## !!!In your PC!!
vim ~/.ssh/config
## Add the following content into your `~/.ssh/config`
Host server_a
    HostName xxx.xxx.100.232
    User root
    Port 22
Host server_b
    HostName 172.31.xxx.xxx
    Port 22
    ProxyCommand ssh server_a nc %h %p
## Now you can directly ssh to server_b from your PC
ssh root@server_b
## or copy file from your PC to server_b
rsync -avP <file/directory> root@server_b:/<somewhere>
## If you encounter problems in Windows, the link below may be useful:
## https://serverfault.com/questions/956613/windows-10-ssh-proxycommand-posix-spawn-no-such-file-or-directory
