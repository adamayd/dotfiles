#! /bin/bash

# Attach to Wifi
clear
nmcli dev wifi list
read -p 'Enter the SSID of the network: ' SSID
read -p 'Enter the password: ' WPAPASS
nmcli dev wifi connect $SSID password $WPAPASS

# Install CLI Installation Utilities
pacman -S --noconfirm vim bash-completion zsh ranger termite yaourt lm_sensors tlp htop archey3 exfat-utils 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Clone Dotfiles Repo and Source Files
pacman -S --noconfirm git
cd && git clone https://github.com/adamayd/T460dotfiles.git
printf "%s\n" "source $HOME/T460dotfiles/zshrc" > $HOME/.zshrc
printf "%s\n" "source $HOME/T460dotfiles/bashrc" > $HOME/.bashrcz
printf "%s\n" "so $HOME/T460dotfiles/vimrc" > $HOME/.vimrc
mkdir $HOME/.config/termite
ln -s $HOME/T460dotfiles/config/termite/config $HOME/.config/termite/config
printf "%s\n\t%s\n" "[include]" "path = $HOME/T460dotfiles/gitconfig" > $HOME/.gitconfig 

# Install SSH
pacman -S --noconfirm openssh
read -p 'Enter your email address for your SSH Key: ' EMAIL
ssh-keygen -t rsa -b 4096 -C $EMAIL
chmod 755 $HOME/T460dotfiles/xprofile.sh
printf "%s\n" "$HOME/T460dotfiles/xprofile.sh" > $HOME/.xprofile

# Install XOrg and i3WM
pacman -S xorg-server xorg-apps i3 feh scrot xclip rofi

# Install Light DM
pacman -S --noconfirm lightdm lightdm-gtk-greeter
systemctl enable lightdm.service
link /etc/lightdm/ligthdm-gtk-greeter.conf
*finish avatar and background install*

# Install Audio
pacman -S --noconfirm alsa-utils pulseaudio
amixer sset Master unmute 50
speaker-test -c 2 -l 2

# Install Intel Video
pacman -S --noconfirm xf86-video-intel
ln -s ~/T460dotfiles/remoteconf/20-intel.conf /etc/X11/xorg.conf.d

# Install Synaptics Touchpad
pacman -S --noconfirm synaptics
ln -s ~/T460dotfiles/remoteconf/70-synaptics.conf /etc/X11/xorg.conf.d

# Install System Fonts
pacman -S --noconfirm ttf-dejavu xorg-fonts-100dpi powerline powerline-fonts
yaourt -S system-san-francisco-font-git ttf-font-awesome ttf-ms-fonts ttf-mac-fonts ttf-font-icons

# Install Printing Services
pacman -S --noconfirm cups cups-pdf
systemctl enable org.cups.cupsd.service
cp -f $HOME/T460dotfiles/remoteconf/cups-pdf.conf /etc/cups/cups-pdf.conf

# Install CLI Base Software
pacman -S --noconfirm mpv calendar mutt cmusic

# Install GUI Base Software
pacman -S --noconfirm pdfviewer printtool scantool tools-needed-for-ranger-above bluez dunst/notifications?? slack gitter transmission calendar mutt

# Install CLI Dev Environment
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install GUI Dev Software
pacamn -S --noconfirm chromium postman vscode slack qutebrowser firefox-developer-edition

# Install LAMP
install apache
copy apached config
enable apache service
install php
install mariadb
copy mariadb config
link php to mariadb
enable mysql service

