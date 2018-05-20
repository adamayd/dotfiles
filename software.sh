#! /bin/bash

# Attach to Wifi
clear
nmcli dev wifi list
read -p 'Enter the SSID of the network: ' SSID
read -p 'Enter the password: ' WPAPASS
nmcli dev wifi connect $SSID password $WPAPASS

# Install base CLI software
sudo pacman -S --noconfirm git lm_sensors tlp htop archey3 openssh exfat-utils vim bash-completion zsh ranger termite yaourt
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
printf "%s\n" "source $HOME/T460dotfiles/zshrc" > $HOME/.zshrc
printf "%s\n" "source $HOME/T460dotfiles/bashrc" > $HOME/.bashrcz
printf "%s\n" "so $HOME/T460dotfiles/vimrc" > $HOME/.vimrc

# Clone repo and start installations by segment
cd  && git clone https://github.com/adamayd/T460dotfiles.git
printf "%s\n" "[include]" > $HOME/.gitconfig
printf "\t%s\n" "path = $HOME/T460dotfiles/gitconfig"

# Install XOrg and i3wm
sudo pacman -S xorg-server xorg-apps i3 feh scrot xclip rofi
cp ~/T460dotfiles/xprofile ~/.xprofile

# Install Light DM
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service
link /etc/lightdm/ligthdm-gtk-greeter.conf
*finish avatar and background install*

# Install Audio
sudo pacman -S alsa-utils pulseaudio
amixer sset Master unmute 50
speaker-test -c 2 -l 2

# Install Intel Video
sudo pacman -S --noconfirm xf86-video-intel
sudo ln -s ~/T460dotfiles/remoteconf/20-intel.conf /etc/X11/xorg.conf.d

# Install Synaptics Touchpad
sudo pacman -S --noconfirm synaptics
sudo ln -s ~/T460dotfiles/remoteconf/70-synaptics.conf /etc/X11/xorg.conf.d

# Install System Fonts
sudo pacman -S ttf-dejavu xorg-fonts-100dpi powerline powerline-fonts
yaourt -S system-san-francisco-font-git ttf-font-awesome ttf-ms-fonts ttf-mac-fonts ttf-font-icons

# Install Dev Environment
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install LAMP

# Configure SSH
#./configssh.sh
