# Authorize
sudo usermod -aG sudo hyeonbeen
sudo -- sh -c "echo "hyeonbeen" | sudo -S chmod 777 /home"
sudo -- sh -c "echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

# Install apps
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install vim git wget curl tmux net-tools openssh-server x11-apps -y

# Setup SSH
sudo ssh-keygen -A
mkdir /var/run/sshd
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd restart

# Install XRDP
sudo DEBIAN_FRONTEND=noninteractive apt-get install xrdp xfce4 xfce4-session xfce4-terminal -y
sudo sed -i 's/#AllowRootLogin=false/AllowRootLogin=true/' /etc/xrdp/sesman.ini
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
sudo -- sh -c "echo xfce4-session >~/.xsession"
sudo -- sh -c "echo unset DBUS_SESSION_BUS_ADDRESS >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo unset XDG_RUNTIME_DIR >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo . $HOME/.profile >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo exec /bin/sh /etc/X11/Xsession >>/etc/xrdp/startwm.sh"
sudo service xrdp restart

# Install firefox
sudo DEBIAN_FRONTEND=noninteractive apt-get install firefox -y

# Install VSCode
sudo DEBIAN_FRONTEND=noninteractive apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo rm -f packages.microsoft.gpg
sudo DEBIAN_FRONTEND=noninteractive apt install apt-transport-https -y
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install code -y

# Install miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash

# Clean
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*