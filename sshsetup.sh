#! /bin/bash 

# Grab email address for keygen
read -p "Enter the email address you want associated with your SSH key: " EMAILSSH 

# Generate Key 
ssh-keygen -t rsa -b 4096 -C "$EMAILSSH"

# Start Agent
printf '%s\t%s\n' "AddKeysToAgent" "yes" >> $HOME/.ssh/config
eval "$(ssh-agent -s)"

# Add Key to Agent
read -p "Enter the filename of the SSH key: " SSHKEYNAME
ssh-add ~/.ssh/$SSHKEYNAME

# Move User Agent Service and Enable
mkdir -p $HOME/.config/systemd/user/
cp $HOME/T460dotfiles/config/systemd/user/ssh-agent.service $HOME/.config/systemd/user/
ln -s $HOME/T460dotfiles/pam_environment $HOME/.pam_environment
systemctl --user enable ssh-agent

# Helpful info that is also easy to find notes later
printf "%s\n" "To add the key to website use xclip: "
printf "%s\n" "xclip -sel clip < ~/.ssh/$SSHKEYNAME.pub"
read -p "Press any key to continue"

exit 0
