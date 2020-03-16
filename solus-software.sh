#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

# Install Command Line Utilities
sudo eopkg install -y ranger lm_sensors htop unzip git neofetch cmatrix strace curl tmux xclip
if [[ $? -ne 0 ]]; then
  error_exit "Error installing command line utilities! Aborting."
fi

# Install Security Utilities
sudo eopkg install -y gnupg password-store
if [[ $? -ne 0 ]]; then
  error_exit "Error installing security utilities! Aborting."
fi

# Create SSH Key
if [ ! -d "$HOME/.ssh" ]; then
  ssh-keygen -t rsa -b 4096 -C adam.ayd@gmail.com
  eval "$(ssh-agent -s)"
  ssh-add $HOME/.ssh/id_rsa
  xclip -sel clip < $HOME/.ssh/id_rsa.pub
fi


# Install Base Development System
sudo eopkg install -y -c system.devel
if [[ $? -ne 0 ]]; then
  error_exit "Error installing the base development system! Aborting."
fi

# Install ACPI and TLP
#sudo eopkg install tlp libelf linux-current-headers
#git clone acpi_call package
#cd acpi_call && make
#sudo make install
#cd .. && rm -rf acpi_call
#sudo tlp start

# Install Node JS
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Node Version Manager! Aborting."
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

# Install Yarn for Node JS
sudo eopkg it -y yarn
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Yarn! Aborting."
fi

# Install Node Utilities
yarn global add create-react-app @vue/cli eslint gatsby-cli @gridsome/cli jest
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Node utilities using Yarn! Aborting."
fi

# Install Python
sudo eopkg install pip pipenv
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Python! Aborting."
fi

# Install Go
sudo eopkg install golang
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Go! Aborting."
fi

# Install Elixir
#sudo eopkg install elixir stuff (asdf)

# Install Java
sudo eopkg install -y mongodb openjdk-8
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Java! Aborting."
fi

# Install Gradle
#TODO: sudo eopkg install gradle

# Install Docker
sudo eopkg install -y docker
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Docker! Aborting."
fi

# Install Ansible
#TODO: sudo eopkg install ansible

# Install Digital Ocean Tools
# Install AWS and Boto3
#TODO: sudo eopkg install boto3
#TODO: pip3 install --user awscli
# Install Azure CLI
# Install GCP CLI

# Install Terraform
#TODO: sudo eopkg install terraform

# Install Serverless Framework
curl -o- -L https://slss.io/install | bash
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Serverless Framework! Aborting."
fi

# Install i3wm
sudo eopkg it -y i3 rofi xbacklight feh

# Install Browsers
#sudo eopkg install -y chromium
#printf "\s\n", "Press any key to open Chromium and set up syncing.  Close Chromium when finished"
#read -p "Enter s to skip: " SKIPPER
#if [[ $SKIPPER != 's' ]] || [[ $SKIPPER != 'S' ]]; then
  #firefox -new-tab "https://www.mozilla.org/en-US/firefox/developer/"
#fi
printf "%s\n" "Press any key to open Firefox and download Firefox Developer Edition. Close Firefox when finished"
read -p "Enter s to skip: " skipper
echo $skipper
if [[ $skipper != 's' ]] && [[ $skipper != 'S' ]]; then
  firefox -new-tab "https://www.mozilla.org/en-US/firefox/developer/"
fi
sudo tar -xvf $HOME/Downloads/firefox* -C /opt/
sudo mv /opt/firefox/ /opt/firefox-developer-edition/
sudo chown adam /opt/firefox-developer-edition/
printf "%s\n" "Press any key to open Firefox Developer Edition and set up syncing. Close Firefox when finished"
read -p "Enter s to skip: " skipper
echo $skipper
if [[ $skipper != 's' ]] && [[ $skipper != 'S' ]]; then
  /opt/firefox-developer-edition/firefox -new-tab "https://www.mozilla.org/en-US/firefox/developer/"
fi

# Add SSH to Github/GitLab
printf "%s\n" "Press any key to open Firefox and set up Github and GitLab.  Close Firefox when finished"
read -p "Enter s to skip: " skipper
echo $skipper
if [[ $skipper != 's' ]] && [[ $skipper != 'S' ]]; then
  /opt/firefox-developer-edition/firefox -new-tab "www.github.com"
  /opt/firefox-developer-edition/firefox -new-tab "www.gitlab.com"
fi

# Install QuteBrowser 
sudo eopkg install -y qutebrowser
if [[ $? -ne 0 ]]; then
  error_exit "Error installing browsers! Aborting."
fi
# Install mpv and youtube-dl as well and qutebrowser config
#TODO: 

# Install Code Editors and IDE's 
sudo eopkg install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
cd $HOME/.vim/bundle/YouCompleteMe
python3 install.py --all

sudo eopkg install -y vscode
if [[ $? -ne 0 ]]; then
  error_exit "Error installing code editors and IDEs! Aborting."
fi

# Install BitWarden
sudo snap install bitwarden
if [[ $? -ne 0 ]]; then
  error_exit "Error installing BitWarden! Aborting."
fi

# Install Chats
sudo snap install slack --classic
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Slack! Aborting."
fi
#TODO: figure out the issue with xdg-open that "eventually" self-heals
sudo snap install discord
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Discord! Aborting."
fi

# Install Fonts
sudo eopkg install -y font-awesome-ttf font-awesome-4 powerline-fonts font-firacode-ttf font-firacode-otf
if [[ $? -ne 0 ]]; then
  error_exit "Error installing fonts! Aborting."
fi

# Install API Tools
sudo snap install postman
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Postman snap! Aborting."
fi

# Install Rice
echo "Rice"
if [[ $? -ne 0 ]]; then
  error_exit "Error installing rice! Aborting."
fi

# Install Powerline
sudo pip3 install --user powerline-status
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Powerline! Aborting."
fi

# Clone dotfiles repo
git clone https://github.com/adamayd/dotfiles.git $HOME/dotfiles
if [[ $? -ne 0 ]]; then
  error_exit "Error cloning dotfiles! Aborting."
fi

# Link dotifles TODO: FINISH
ln -s $HOME/dotfiles/vimrc $HOME/.vimrc
if [[ $? -ne 0 ]]; then
  error_exit "Error linking .vimrc! Aborting."
fi
echo "source $HOME/dotfiles/shellsrc" >> $HOME/.bashrc
if [[ $? -ne 0 ]]; then
  error_exit "Error appending to .bashrc! Aborting."
fi
ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/gitconfig $HOME/.gitconfig
sudo ln -s $HOME/dotfiles/gnome/firefox-developer-edition.desktop /usr/share/applications/


# Install Oh-My-Bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

