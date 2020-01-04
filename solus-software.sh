#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

# Install Command Line Utilities
sudo eopkg install -y zsh ranger lm_sensors htop unzip git neofetch cmatrix strace 
if [[ $? -ne 0 ]]; then
  error_exit "Error installing command line utilities! Aborting."
fi

# Install Security Utilities
sudo eopkg install -y gnupg password-store
if [[ $? -ne 0 ]]; then
  error_exit "Error installing security utilities! Aborting."
fi

# Create SSH Key

# Install Base Development System
sudo eopkg install -y -c system.devel
if [[ $? -ne 0 ]]; then
  error_exit "Error installing the base development system! Aborting."
fi

# Install Code Editors and IDE's 
sudo eopkg install -y vscode
if [[ $? -ne 0 ]]; then
  error_exit "Error installing code editors and IDEs! Aborting."
fi

# Install Yarn for Node JS
sudo eopkg it -y yarn
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Yarn! Aborting."
fi

# Install Node JS
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Node Version Manager! Aborting."
fi

# Install Node Utilities
yarn global add create-react-app @vue/cli eslint gatsby-cli @gridsome/cli jest
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Node utilities using Yarn! Aborting."
fi
#sudo yarn global add @gridsome/cli 
#if [[ $? -ne 0 ]]; then
  #error_exit "Error installing Node utilities in NPM! Aborting."
#fi

# Install Java
sudo eopkg install -y mongodb tmux openjdk-8
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Java! Aborting."
fi

# Install .NET Core
sudo snap install dotnet-sdk --classic
if [[ $? -ne 0 ]]; then
  error_exit "Error installing .NET SDK! Aborting."
fi
sudo snap install dotnet-runtime-22 dotnet-runtime-30 dotnet-runtime-31
if [[ $? -ne 0 ]]; then
  error_exit "Error installing .NET Runtime! Aborting."
fi

# Install i3wm
sudo eopkg it -y i3 rofi xbacklight feh

# Install QuteBrowser 
# Install mpv and youtube-dl as well and qutebrowser config
sudo eopkg install -y qutebrowser
if [[ $? -ne 0 ]]; then
  error_exit "Error installing browsers! Aborting."
fi

# Install Chats
sudo snap install slack discord
if [[ $? -ne 0 ]]; then
  error_exit "Error installing chat client snaps! Aborting."
fi
sudo eopkg it -y hexchat
if [[ $? -ne 0 ]]; then
  error_exit "Error installing hexchat! Aborting."
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

# Install Microsoft Tools
# Download and install Teams
# Download and install Azure Data Studio
sudo snap install vscode --classic

# Install Cloud Provider CLIs
# Install AWS and Boto3
# Install Azure CLI
# Install GCP CLI

# Install Powerline
pip3 install --user powerline-status powerline-gitstatus
if [[ $? -ne 0 ]]; then
  error_exit "Error installing Powerline! Aborting."
fi

# Install Rice
echo "Rice"
if [[ $? -ne 0 ]]; then
  error_exit "Error installing rice! Aborting."
fi

# Clone dotfiles repo
git clone https://github.com/adamayd/dotfiles.git $HOME/dotfiles
if [[ $? -ne 0 ]]; then
  error_exit "Error cloning dotfiles! Aborting."
fi

# Link dotifles
ln -s $HOME/dotfiles/vimrc $HOME/.vimrc
if [[ $? -ne 0 ]]; then
  error_exit "Error linking .vimrc! Aborting."
fi
echo "source $HOME/dotfiles/shellsrc" >> $HOME/.bashrc
if [[ $? -ne 0 ]]; then
  error_exit "Error appending to .bashrc! Aborting."
fi
ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf


#sudo snap install pycharm-community --classic

# TODO: Confirm Commands
#
#sudo eopkg install terraform
#sudo eopkg install ansible
#sudo eopkg install gradle
#sudo eopkg install pip pipenv
#sudo eopkg install libffi-devel zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite3-devel readline-devel tk-devel gdbm-devel db4.8-devel libpcap-devel xz-devel expat-devel postgresql-devel
#sudo eopkg install boto3
#pip install --user awscli
#sudo eopkg install tlp libelf linux-current-headers
#git clone acpi_call package
#cd acpi_call && make
#sudo make install
#cd .. && rm -rf acpi_call
#sudo tlp start
#sudo eopkg install elixir stuff (asdf)
#sudo eopkg install rust stuff

# TODO: Move dotfiles into place
