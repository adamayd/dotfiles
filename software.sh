#! /bin/bash

# Attach to Wifi
clear
nmcli dev wifi list
read -p 'Enter the SSID of the network: ' SSID
read -p 'Enter the password: ' WPAPASS
nmcli dev wifi connect $SSID password $WPAPASS

# Install CLI Installation Utilities
sudo pacman -S --noconfirm vim bash-completion zsh ranger termite lm_sensors git tlp htop archey3 exfat-utils unzip autofs
sudo systemctl enable fstrim.timer
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si
cd && rm -rf yay

# Clone Dotfiles Repo and Source Files
sudo pacman -S --noconfirm git
cd && git clone https://github.com/adamayd/T460dotfiles.git
printf "%s\n" "source $HOME/T460dotfiles/zshrc" > $HOME/.zshrc
printf "%s\n" "source $HOME/T460dotfiles/bashrc" > $HOME/.bashrcz
printf "%s\n" "so $HOME/T460dotfiles/vimrc" > $HOME/.vimrc
mkdir -p $HOME/.config/termite
ln -s $HOME/T460dotfiles/config/termite/config $HOME/.config/termite/config
printf "%s\n\t%s\n" "[include]" "path = $HOME/T460dotfiles/gitconfig" > $HOME/.gitconfig 

# Install SSH
sudo pacman -S --noconfirm openssh
./sshsetup.sh
# TODO: Add SSH config file to ~/.ssh/config with AddKeysToAgent yes for persistence
chmod 755 $HOME/T460dotfiles/xprofile.sh
printf "%s\n" "$HOME/T460dotfiles/xprofile.sh" > $HOME/.xprofile
ln -s ~/T460dotfiles/sshrc ~/.sshrc

# Install XOrg and i3WM
sudo pacman -S xorg-server xorg-apps i3 feh scrot xclip rofi xorg-xcalc

# Install Light DM
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service
# TODO: link /etc/lightdm/ligthdm-gtk-greeter.conf
# TODO: finish avatar and background install

# Install Audio
sudo pacman -S --noconfirm alsa-utils pulseaudio
amixer sset Master unmute 50
speaker-test -c 2 -l 2

# Install Intel Video
sudo pacman -S --noconfirm xf86-video-intel
cp -f ~/T460dotfiles/remoteconf/20-intel.conf /etc/X11/xorg.conf.d

# Install Synaptics Touchpad
sudo pacman -S --noconfirm synaptics
cp -f ~/T460dotfiles/remoteconf/70-synaptics.conf /etc/X11/xorg.conf.d

# Install Filesystem Support
yay -s hfsprogs
# TODO: ntfs / samba
# TODO: cd/dvd/bd support

# Install System Fonts
sudo pacman -S --noconfirm ttf-dejavu xorg-fonts-100dpi powerline powerline-fonts
yay -S system-san-francisco-font-git ttf-font-awesome ttf-ms-fonts ttf-mac-fonts ttf-font-icons

# Install Printing Services
sudo pacman -S --noconfirm cups cups-pdf
sudo systemctl enable org.cups.cupsd.service
sudo cp -f $HOME/T460dotfiles/remoteconf/cups-pdf.conf /etc/cups/cups-pdf.conf
# TODO: install Samsung drivers
# TODO: network printing

# Install Scanning Services
# SANE services
# Brother drivers brscan4
# network scanning
# gscan2pdf 

# Install Notification System
sudo pacman -S --noconfirm dunst
# TODO: dunst configuration?? libnotifiy?? tie to pidgen/irc/slack and media apps

# Install Bluetooth
# TODO:  bluez

# Install GUI File Explorer and Preview Dependencies
# TODO: yeah that, pick a gui file manager first

# Install Ranger Preview Dependencies
# TODO: w3m? pdf2text?? exiftool??

# Install CLI Base Software
sudo pacman -S --noconfirm mpv neomutt calcurse cmus w3m transmission-cli perl-image-exiftool #TODO: slack-term wormhole irssi vitetris

# Install GUI Base Software
sudo pacman -S --noconfirm gimp libreoffice-fresh transmission-gtk pdfsam

# Install CLI Dev Environment
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/T460dotfiles/nvmrc && nvm install --lts
ln -s ~/T460dotfiles/nvmrc ~/.nvmrc
sudo pacman -S --noconfirm python-pip python2-pip ruby mongodb tmux
yay -S rbenv

# Install GUI Dev Software
sudo pacman -S --noconfirm chromium firefox-developer-edition pycharm-community-edition 
yay -S postman-bin visual-studio-code-bin slack-desktop gitter gitkraken robo3t-bin

# Install LAMP
#install apache
#copy apached config
#enable apache service
#install php
#install mariadb
#copy mariadb config
#link php to mariadb
#enable mysql service

# Container Services
# install docker heroku kubernetes lxd 

# Install Android Dev Software
#pacman -S --noconfirm android-studio android-tools android-udev mtpfs
sudo pacman -S --noconfirm bc bison base-devel ccache curl flex png++ gccbase-devel git gnupg gperf imagemagick lib32-ncurses lib32-readline lib32-zlib lz4 ncurses sdl openssl wxgtk3 libxml2 lzop pngcrush rsync schedtool squashfs-tools libxslt zip zlib maven
yay -S esound

# Rice to fix on i3
# Powerline everywhere
# Lemon Bar/Poly Bar/ Status Bar
# Lock Screen
# Light DM Avatar and Background
# libinput-gestures (3 finger swipes)

# Rice to fix on OpenBox
# TBD

# Add Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
