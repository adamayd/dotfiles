#! /bin/bash

for d in $(ls -d */); do 
  echo ${d%%/};
  cd ${d}
  git status -s
  cd ..
done;

