# HOW TO USE:
# After clean install of Ubuntu 20.04 Server on VMWare Fusion running on MacOSX,
# cd && mkdir Git && cd Git
# git clone https://github.com/hyeonbeenlee/MyDockerfile.git 
# cd MyDockerfile && bash setup_osx_vm_noetic.sh
# sudo reboot
# Then, connect to Remote Desktop to {VM's internal IP}:3389

# Authorize
# Modify "hyeonbeen" to your username if needed.
# Modify "hyeonbeen" to your username if needed.
sudo usermod -aG sudo hyeonbeen
sudo -- sh -c "echo "hyeonbeen" | sudo -S chmod 777 /home"
sudo -- sh -c "echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
# Modify "hyeonbeen" to your username if needed.
# Modify "hyeonbeen" to your username if needed.

# Install apps
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/ports.ubuntu.com/ftp.lanet.kr/g' /etc/apt/sources.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install vim git wget curl tmux net-tools openssh-server x11-apps open-vm-tools open-vm-tools-desktop -y

# Setup SSH
sudo ssh-keygen -A
mkdir /var/run/sshd
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd restart

# Install XRDP
sudo DEBIAN_FRONTEND=noninteractive apt-get install xrdp xfce4 xfce4-session terminator -y
sudo sed -i 's/#AllowRootLogin=false/AllowRootLogin=true/' /etc/xrdp/sesman.ini
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
sudo sed -i 's/exec \/bin\/sh \/etc\/X11\/Xsession//g' /etc/xrdp/startwm.sh
sudo -- sh -c "echo unset DBUS_SESSION_BUS_ADDRESS >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo unset XDG_RUNTIME_DIR >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo . $HOME/.profile >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo exec /bin/sh /etc/X11/Xsession >>/etc/xrdp/startwm.sh"
sudo systemctl restart xrdp
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

# ROS-Noetic installation
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install ros-noetic-desktop-full -y
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
sudo apt install python3-rosdep -y
sudo rosdep init
rosdep update
echo "alias cm="catkin_make"" >> ~/.bashrc
# ROS Turtlebot3
sudo apt-get install ros-noetic-joy ros-noetic-teleop-twist-joy -y
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src/
git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
git clone -b noetic-devel https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
cd ~/catkin_ws && catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
echo "export TURTLEBOT3_MODEL=waffle_pi" >> ~/.bashrc

# Install miniconda
# mkdir -p ~/miniconda3
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
# bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
# rm -rf ~/miniconda3/miniconda.sh
# ~/miniconda3/bin/conda init bash

# Clean
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*