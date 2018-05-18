#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lhA --group-directories-first'
alias vi='vim'
PS1='[\u@\h \W]\$ '

PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export GEM_HOME=$(ruby -e 'print Gem.user_dir')

source ~/.sshrc
source ~/.nvmrc
