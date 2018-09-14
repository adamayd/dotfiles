#! /bin/bash

# Qutebrowser Settings
mkdir -p $HOME/T460dotfiles/config/qutebrowser
cp $HOME/.config/qutebrowser/autoconfig.yml $HOME/T460dotfiles/config/qutebrowser
cp -r $HOME/.config/qutebrowser/bookmarks $HOME/T460dotfiles/config/qutebrowser

# Visual Studio Code Settings
mkdir -p $HOME/T460dotfiles/config/Code\ -\ OSS/User
cp $HOME/.config/Code\ -\ OSS/User/keybindings.json $HOME/T460dotfiles/config/Code\ -\ OSS/User
cp $HOME/.config/Code\ -\ OSS/User/settings.json $HOME/T460dotfiles/config/Code\ -\ OSS/User

