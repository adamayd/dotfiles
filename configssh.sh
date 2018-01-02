#! /bin/bash

ssh-keygen -t rsa -b 4096 -C "adamayd@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

