#! /bin/bash

# eval "$(ssh-agent)"
if [ -e $HOME/.config/i3 ]; then
    cp -f ~/T460dotfiles/config/i3/config ~/.config/i3/config
fi

