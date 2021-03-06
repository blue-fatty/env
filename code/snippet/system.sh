# read -> https://bash-prompt.net/guides/server-hacked/
# Who are currently logged in and do what?
w
# who are currently logged in
who
# Who has logged in?
last
last | less
# Who was refused to log in? (useful for checking attacks)
lastb
lastb | less
# check ssh log (detail ssh log)
journalctl -u sshd

# useful monitor tools
htop # (or top) monitor CPU, memory usage... `yum install htop`
iftop # monitor network usage `yum install iftop` (alternative: nethogs)
gpustat # monitor gpu status, colorful version of nvidia-smi, `pip install gpustat`
glances # pip install glances; pip install glances[all]

# =======

# create user & change password
sudo useradd <username>
sudo passwd <username>

# lock user & unlock user
sudo usermod -L <username>
sudo usermod -U <username>

# add user to sudoers (CentOS)
sudo usermod -aG wheel <username>

# list users of a group: check /etc/group , e.g.:
cat /etc/group | grep wheel

# disable login with password: /etc/ssh/sshd_config
Match User user1,user2,user3,user4
    PasswordAuthentication no
Match all
# Other settings
ChallengeResponseAuthentication no
PasswordAuthentication no
PermitRootLogin no
# restart sshd
systemctl restart sshd
# !important: make sure sshd has been launched by checking the status
systemctl status sshd

# edit crontab
crontab -e -u <username>

# =======

# system information

# Linux kernel version
uname -r
# or
cat /proc/sys/kernel/{ostype,osrelease,version}

# Linux distribution version
lsb_relase -a
cat /etc/*release*

# A very colorful system summary
neofetch
# cpu and processing units
lscpu
# list block devices 
lsblk
# disk space of file systems
df -h
# file storage of current directory
du ./* -h -d 0
# memory
free -h
# usb
lsusb
