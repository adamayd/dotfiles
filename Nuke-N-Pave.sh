#! /bin/bash

# Ask for Destination for file copies
read -p 'Enter the backup destination: ' DEST
echo $DEST
exit 0

# Qutebrowser Settings
mkdir -p $HOME/T460dotfiles/config/qutebrowser
cp $HOME/.config/qutebrowser/autoconfig.yml $HOME/T460dotfiles/config/qutebrowser
cp -r $HOME/.config/qutebrowser/bookmarks $HOME/T460dotfiles/config/qutebrowser

# Visual Studio Code Settings
mkdir -p $HOME/T460dotfiles/config/Code\ -\ OSS/User
cp $HOME/.config/Code\ -\ OSS/User/keybindings.json $HOME/T460dotfiles/config/Code\ -\ OSS/User
cp $HOME/.config/Code\ -\ OSS/User/settings.json $HOME/T460dotfiles/config/Code\ -\ OSS/User

# Mutt Passwords
gpg -dq $HOME/.mutt/mutt-pwds.gpg > mutt-pwds.UNENCRYPTED
mv $HOME/.mutt/mutt-pwds.UNENCRYPTED $DEST

