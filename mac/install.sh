#!/bin/bash

open /System/Applications/App\ Store.app

xcode-select --install

ln -s $HOME/dotfiles/zshrc $HOME/.zshrc
source $HOME/.zshrc

pip3 install ansible
ansible-galaxy collection install elliotweiser.osx-command-line-tools
ansible-galaxy collection install geerlingguy.dotfiles
ansible-galaxy collection install geerlingguy.mac

echo "Copy the config.yml to the mac/ directory in dotfiles then run:"
echo "ansible-playbook -K ~/dotfiles/mac/main.yml"

