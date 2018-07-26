#! /bin/bash 

# Grab email address for keygen
read -p "Enter the email address you want associated with your SSH key: " $EMAILSSH 

ssh-keygen -t rsa -b 4096 -C "$EMAILSSH"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

exit 0
