#! /bin/bash

error_exit() {
  echo "$1" 1>&2
  exit 1
}

connect_wifi() {
  clear
  nmcli dev wifi 
  read -p 'Enter the SSID of the network: ' SSID
  read -p 'Enter the password: ' WPAPASS
  nmcli dev wifi connect $SSID password $WPAPASS || {
    echo >&2 "Failed to connect to WiFi"
    read -p 'Press Enter to try again'
    connect_wifi
  }
}

enable_arch_keys() {
  sudo pacman -S --noconfirm archlinux-keyring
}

install_cli_utils() {
	sudo pacman -S --noconfirm bash-completion lm_sensors git tlp htop archey3 unzip acpi
	yay -S --noconfirm auto-cpufreq-git
	# TODO: neofetch vs archey3, dmidecode, cmatrix, fzf, ripgrep, universal-ctags
}

enable_ssd_trimming() {
	sudo systemctl enable fstrim.timer
}

install_aur_helper() {
	git clone https://aur.archlinux.org/yay.git && cd yay
	makepkg -si
	cd && rm -rf yay
}

create_ssh_key() {
  sudo pacman -S --noconfirm openssh
  if [ ! -d "$HOME/.ssh" ]; then
    ssh-keygen -t rsa -b 4096 -C adam.ayd@gmail.com
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa
  fi
	#./sshsetup.sh
	#ln -s ~/dotfiles/sshrc ~/.sshrc
	# ****** May need to look into taking SSH keys over in another way *****
}

install_password_manager() {
	sudo pacman -S gnupg pass 
	gpg --full-gen-key
	read -p 'Enter email address associated with your PGP key' PGPEMAIL
	pass init $PGPEMAIL
	# TODO: copy password database over
	# ***** May need to look into taking PGP key with as well as SSH keys *****
}

clone_dotfiles() {
	cd && git clone https://github.com/adamayd/dotfiles.git
	printf "%s\n" "source $HOME/dotfiles/zshrc" > $HOME/.zshrc
	printf "%s\n" "source $HOME/dotfiles/bashrc" > $HOME/.bashrc
	printf "%s\n" "so $HOME/dotfiles/vimrc" > $HOME/.vimrc
	mkdir -p $HOME/.config/termite
	ln -s $HOME/dotfiles/config/termite/config $HOME/.config/termite/config
	printf "%s\n\t%s\n" "[include]" "path = $HOME/dotfiles/gitconfig" > $HOME/.gitconfig 
}

install_xorg() {
	sudo pacman -S --noconfirm xorg-server xorg-apps xclip xorg-xcalc 
}

install_i3() {
	sudo pacman -S --noconfirm i3 feh scrot rofi termite dmenu
	mkdir -p $HOME/.config/i3/
	ln -s $HOME/dotfiles/config/i3/config $HOME/.config/i3/config
	ln -s $HOME/dotfiles/i3status.conf $HOME/.i3status.conf
}

install_light_dm() {
	sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
	sudo systemctl enable lightdm.service
	# TODO: link /etc/lightdm/ligthdm-gtk-greeter.conf
	# TODO: finish avatar and background install
}

install_intel_video() {
	sudo pacman -S --noconfirm xf86-video-intel
	cp -f ~/dotfiles/remoteconf/20-intel.conf /etc/X11/xorg.conf.d
}


install_audio() {
	sudo pacman -S --noconfirm alsa-utils pulseaudio pulseaudio-alsa
	amixer sset Master unmute 50
	speaker-test -c 2 -l 2
}

install_bluetooth() {
	sudo pacman -S --noconfirm bluez bluez-utils pulseaudio-bluetooth
} 

install_synaptics() {
	sudo pacman -S --noconfirm synaptics
	# TODO: libinput for Clickpad
	cp -f ~/dotfiles/remoteconf/70-synaptics.conf /etc/X11/xorg.conf.d
}

install_fs_utils() {
	sudo pacman -S exfat-utils dosfstools udisks2 autofs
	# TODO: FAILED - yay -S hfsprogs
	# TODO: ntfs / samba
	# TODO: cd/dvd/bd support
}

install_system_fonts() {
	sudo pacman -S --noconfirm ttf-dejavu xorg-fonts-100dpi powerline powerline-fonts noto-fonts-emoji
	yay -S otf-san-francisco ttf-font-awesome ttf-ms-fonts ttf-mac-fonts ttf-font-icons ttf-vista-fonts
	# TODO: look for OTF replacements instead of ttf
}

install_notifications() {
	sudo pacman -S --noconfirm dunst
	# TODO: dunst configuration?? libnotifiy?? tie to pidgen/irc/slack and media apps
}

install_printing_services() {
	sudo pacman -S --noconfirm cups cups-pdf
	sudo systemctl enable org.cups.cupsd.service
	sudo cp -f $HOME/dotfiles/remoteconf/cups-pdf.conf /etc/cups/cups-pdf.conf
	# TODO: install Samsung drivers
	# TODO: network printing
}

install_scanning_services() {
	echo "TODO: Scanning"
	# TODO: Install Scanning Services
	# SANE services
	# Brother drivers brscan4
	# network scanning
	# gscan2pdf 
}

install_vim() {
	sudo pacman -S --noconfirm vim
	# TODO: vim plugins and config
}

install_neovim() {
	sudo pacman -S --noconfirm neovim
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
	pip install --user pynvim ueberzug
	#TODO: nvim plugins and config
}

install_ranger() {
	sudo pacman -S --noconfirm ranger
	# Install Ranger Preview Dependencies
	# TODO: w3m? pdf2text?? exiftool??
}

install_neomutt() {
	sudo pacman -S --noconfirm neomutt dialog offlineimap msmtp
	mkdir $HOME/.mutt
	ln -s $HOME/dotfiles/muttrc $HOME/.mutt/muttrc
	#git clone https://github.com/LukeSmithxyz/mutt-wizard.git ~/.config/mutt
	#cd ~/.config/mutt && ./mutt-wizard.sh
}

install_cli_base() {
	sudo pacman -S --noconfirm mpv calcurse cmus w3m transmission-cli perl-image-exiftool rsync 
	#TODO: slack-term wormhole irssi vitetris
}

	# Install GUI Base Software
	# Install GUI File Explorer and Preview Dependencies
	# TODO: yeah that, pick a gui file manager first
	# TODO: sudo pacman -S --noconfirm gimp darktable obs libreoffice-fresh transmission-gtk pdfsam
	# TODO: bitwarden 

install_javascript(){
	echo "This is javascript"
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
	source ~/dotfiles/nvmrc && nvm install --lts
	ln -s ~/dotfiles/nvmrc ~/.nvmrc
	# TODO: Get nvm check out of shellsrc, maybe xinit.rc??
	# TODO: create NVM install script that installs global packages in each verison of Node
	npm i -g yarn create-react-app @vue/cli eslint gatsby-cli eslint @gridsome/cli jest
}

install_python() {
	sudo pacman -S --noconfirm python-pip python2-pip 
}

install_golang() {
	echo "Installing GoLang"
}

install_chromium() {
	echo "Installing Chromium"
	sudo pacman -S --noconfirm chromium 
}

install_firefox_developer_edition() {
	echo "Installing Firefox Developer Edition"
	sudo pacman -S --noconfirm firefox-developer-edition 
}

install_vscode() {
	echo "Installing VS Code"
	sudo pacman -S --noconfirm vscode
}

install_postman() {
	echo "Installing Postman"
	yay -S postman-bin
}

install_chats() {
	echo "Installing Chat clients"
	# discord, slack, zoom, gitter, matrix, hexchat, irssi
}

install_remote_desktop() {
sudo pacman -S --noconfirm rdesktop ppp
}


install_embedded_software() {
	yay -S cutecom beye
}

install_android_sdk() {
	#pacman -S --noconfirm android-studio android-tools android-udev mtpfs
	# adb and fastboot
	sudo pacman -S --noconfirm bc bison base-devel ccache curl flex png++ gccbase-devel git gnupg gperf imagemagick lib32-ncurses lib32-readline lib32-zlib lz4 ncurses sdl openssl wxgtk3 libxml2 lzop pngcrush rsync schedtool squashfs-tools libxslt zip zlib maven
	yay -S esound
}

# TODO: Containerize Servers
# Container Services
# install docker heroku kubernetes lxd 
# Install LAMP
#install apache
#copy apached config
#enable apache service
#install php
#install mariadb
#copy mariadb config
#link php to mariadb
#enable mysql service

# TODO: VM Other Distros
# Solus + packaging
# Fedora + packaging
# Pop_OS! + packaging

# Rice to fix on i3
# Powerline everywhere
# Lemon Bar/Poly Bar/ Status Bar
# Lock Screen
# Light DM Avatar and Background
# libinput-gestures (3 finger swipes)
# Rice to fix on OpenBox/Budgie
# Add Oh My Bash


#connect_wifi
enable_arch_keys
install_cli
enable_ssd_trimming
install_aur_helper
create_ssh_key
install_password_manager
#install_xorg
#install_i3
#install_light_dm
install_fs_utils
install_intel_video
install_audio
install_bluetooth
install_synaptics
install_system_fonts
install_notifications
#install_printing_services
#install_scanning_services
install_vim
install_neovim
install_ranger
install_neomutt
install_cli_base
#install_javascript
#install_python
#install_golang
#install_chromium
#install_firefox_developer_edition
#install_vscode
#install_postman
#install_chats
#install_remote_desktop
#install_embedded_software
#install_android_sdk

exit 0
