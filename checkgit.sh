#! /bin/bash

homedir=$(pwd)

for dir in $(find . -mindepth 1 -maxdepth 1 -type d)
do
  cd $dir
  if ! $(git status | grep 'nothing to commit, working tree clean' > /dev/null); then
    echo $dir 
  fi
  cd $homedir
done
