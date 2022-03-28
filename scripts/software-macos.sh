#!/bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

update_macos() {
  echo 'Updating MacOS'
}

install_xcode_clt() {
  echo 'Installing XCode Command Line Tools'
}

install_brew() {
  echo "Installing Brew"
}

install_bash() {
  echo "Installing Bash"
  #TODO: brew install bash - need to update the shells list
}

install_core_utilities() {
  echo "Installing GNU Core Utilities"
  #TODO: brew install coreutils
  #export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
}

install_command_line_utilities() {
  echo "Installing Command Line Utilities"
  #TODO: brew install tmux vifm nvim
}

install_alacritty() {
  echo "Installing Alacritty"
  #TODO: brew install alacritty
}

clone_dotfiles() {
  echo "Cloning dotfiles"
  #TODO: git clone dotfiles"
}

link_dotfiles() {
  echo"Linking dotfiles"
  #TODO: ln -s dotfiles
}

install_vim() {
  sudo dnf install -y vim 
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
  python3 $HOME/.vim/plugged/YouCompleteMe/install.py --clangd-completer --go-completer --ts-completer --java-complete
  cd $HOME
  mkdir -p $HOME/.vim/spell $HOME/.vim/undodir
  ln -s $HOME/dotfiles/vim/spell/en.utf-8.add $HOME/.vim/spell/en.utf-8.add
}

#update_macos
#install_xcode_clt
#install_brew
#install_bash
#install_core_utilities
#install_command_line_utilities
#install_alacritty
#clone_dotfiles
#link_dotfiles
#install_vim
