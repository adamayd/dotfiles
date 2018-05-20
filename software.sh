#! /bin/bash

# Attach to Wifi
clear
nmcli dev wifi list
read -p 'Enter the SSID of the network: ' SSID
read -p 'Enter the password: ' WPAPASS
nmcli dev wifi connect $SSID password $WPAPASS

# Install base CLI software
sudo pacman -S --noconfirm git lm_sensors tlp htop archey3 openssh exfat-utils vim bash-completion ranger termite yaourt
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
source vimrc bashrc zshrc

# Clone repo and start installations by segment
cd  && git clone https://github.com/adamayd/T460dotfiles.git
printf "%s\n" "[include]" > $HOME/.gitconfig
printf "\t%s\n" "path = $HOME/T460dotfiles/gitconfig"1

# Install XOrg and i3wm
sudo pacman -S xorg-server xorg-apps i3 feh scrot xclip rofi
source config/i3/config

# Install Light DM
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service
link /etc/lightdm/ligthdm-gtk-greeter.conf
*finish avatar and background install*

# Install Audio
sudo pacman -S alsa-utils pulseaudio
amixer sset Master unmute 50
speaker-test -c 2 -l 2

# Install System Fonts
sudo pacman -S ttf-dejavu xorg-fonts-100dpi powerline powerline-fonts
yaourt -S system-san-francisco-font-git ttf-font-awesome ttf-ms-fonts ttf-mac-fonts

# Install Dev Environment
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install LAMP

# Configure SSH
#./configssh.sh
