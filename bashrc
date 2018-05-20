#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lhA --group-directories-first'
alias vi='vim'
PS1='[\u@\h \W]\$ '

source $HOME/T460dotfiles/addonrc

