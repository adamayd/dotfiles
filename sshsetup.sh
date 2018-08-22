#! /bin/bash 

# Grab email address for keygen
read -p "Enter the email address you want associated with your SSH key: " $EMAILSSH 

ssh-keygen -t rsa -b 4096 -C "$EMAILSSH"
echo "AddKeysToAgent yes" >> $HOME/.ssh/config
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

mkdir -p $HOME/.config/systemd/user/
cp $HOME/T460dotfiles/config/systemd/user/ssh-agent.service $HOME/.config/systemd/user/
systemctl --user enable ssh-agent

exit 0
