#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

create_install_temp_dir() {
  if [ -z $TEMP_DIR ]; then TEMP_DIR=$(mktemp -d); fi
  if [[ $? -ne 0 ]]; then
    error_exit "Error createing temporary install directory! Aborting."
  fi
}

install_base_utilities() {
  sudo eopkg install -y vim ranger exfat-utils fuse-exfat lm_sensors htop unzip git strace curl wget tmux xclip jq
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing command line utilities! Aborting."
  fi
}

install_command_line_fun() {
  sudo eopkg install -y cmatrix neofetch lolcat # cowsay fortune-mod
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing command line fun! Aborting."
  fi
}

install_security_utilities() {
  sudo eopkg install -y gnupg password-store 
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing security utilities! Aborting."
  fi
}

create_ssh_key() {
  printf "%s" "Enter your email address for the SSH key pair: "
  read EMAIL
  if [ ! -d "$HOME/.ssh" ]; then
    mkdir $HOME/.ssh
  fi
  ssh-keygen -t rsa -b 4096 -C $EMAIL
  eval "$(ssh-agent -s)"
  ssh-add $HOME/.ssh/id_rsa
}

install_power_management() {
  sudo eopkg install -y tlp libelf-devel linux-current-headers ethtool smartmontools
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing TLP! Aborting."
  fi
  #TODO: install_acpi_call <= Fix with kernal 5.6.4
  sudo tlp start
  if [[ $? -ne 0 ]]; then
    error_exit "Error starting TLP! Aborting."
  fi
}

install_acpi_call() {
  git clone https://github.com/mkottman/acpi_call.git $TEMP_DIR/acpi_call
  sed -i 's/#include <acpi\/acpi.h>/#include <linux\/acpi.h>/' $TEMP_DIR/acpi_call/acpi_call.c
  sed -i 's/#include <asm\/uaccess.h>/#include <linux\/uaccess.h>/' $TEMP_DIR/acpi_call/acpi_call.c
  make -C $TEMP_DIR/acpi_call/
  if [[ $? -ne 0 ]]; then
    error_exit "Error building ACPI_call module! Aborting."
  fi
  sudo make install -C $TEMP_DIR/acpi_call/
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing ACPI_call module! Aborting."
  fi
}

install_i3_window_manager() {
  sudo eopkg it -y i3 rofi xbacklight feh
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the i3 window manager! Aborting."
  fi
}

install_base_development_system() {
  sudo eopkg install -y -c system.devel
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the base development system! Aborting."
  fi
}

install_solus_packaging() {
  #TODO: install needs for the solus packaging
  echo "TODO to add solus_packaging needs"
}

install_node() {
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
}

install_python() {
  sudo eopkg install -y pip pipenv python3-devel
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Python! Aborting."
  fi
}

install_go() {
  sudo eopkg install -y golang
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Go! Aborting."
  fi
}
  
install_elixir() {
  #TODO: sudo eopkg install elixir stuff (asdf)
  echo "Elixir not yet set up to install in script"
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Elixir! Aborting."
  fi
}

install_java() {
  sudo eopkg install -y openjdk-8
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Java! Aborting."
  fi

  # Install Gradle Build Tool
  wget -O $HOME/Downloads/gradle-6.3-bin.zip https://services.gradle.org/distributions/gradle-6.3-bin.zip
  sudo unzip -d /opt/ $HOME/Downloads/gradle-6.3-bin.zip
  rm $HOME/Downloads/gradle-6.3-bin.zip
  export PATH=$PATH:/opt/gradle-6.3/bin
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Gradle Build Tool! Aborting."
  fi
}

install_databases() {
  sudo eopkg install -y mongodb
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Databases! Aborting."
  fi
}

install_docker() {
  sudo eopkg install -y docker docker-compose
  sudo usermod -aG docker $USER
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Docker! Aborting."
  fi
}

install_config_mgmt() {
  sudo eopkg install -y ansible
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Ansible! Aborting."
  fi
}

install_provisioning() {
  wget -O $HOME/Downloads/terraform_0.12.24_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
  sudo unzip -d /usr/bin/ $HOME/Downloads/terraform_0.12.24_linux_amd64.zip
  rm $HOME/Downloads/terraform_0.12.24_linux_amd64.zip
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Terraform! Aborting."
  fi
}

install_serverless_framework() {
  curl -o- -L https://slss.io/install | bash
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Serverless Framework! Aborting."
  fi
}

install_cloud_cli_tools() {
  #TODO: Install Digital Ocean Tools
  # Install AWS and Boto3
  #TODO: boto3 error on install asking for dependency botocore
  sudo eopkg install -y boto3
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Boto3! Aborting."
  fi
  pip3 install --user awscli
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing AWS CLI! Aborting."
  fi
  #TODO: Install AWS V2
  #TODO: Install Azure CLI
  #TODO: Install GCP CLI
}

install_firefox_dev() {
  firefox_dev_installed=false
  local skipper
  printf "%s\n" "Press any key to open Firefox and download Firefox Developer Edition. Close Firefox when finished"
  printf "%s\n" "This will close any open Firefox session, save work and continue or Ctrl-C now to exit"
  read -p "Enter s to skip: " skipper
  if [[ $skipper != 's' && $skipper != 'S' ]]; then
    killall firefox
    firefox "https://www.mozilla.org/en-US/firefox/developer/"
    if [[ -d "/opt/firefox" || -d "/opt/firefox-developer-edition" ]]; then
      sudo rm -rf /opt/firefox
      sudo rm -rf /opt/firefox-developer-edition
    fi
    sudo tar -xvf $HOME/Downloads/firefox* -C /opt/
    if [[ $? -ne 0 ]]; then
      error_exit "Error extracting Firefox Develop Edition archive! Aborting."
    fi
    rm $HOME/Downloads/firefox* 
    sudo mv /opt/firefox/ /opt/firefox-developer-edition/
    sudo chown adam /opt/firefox-developer-edition/
    if [ -L /usr/share/applications/firefox-developer-edition.desktop ]; then
      sudo rm /usr/share/applications/firefox-developer-edition.desktop
    elif [ -e /usr/share/applications/firefox-developer-edition.desktop ]; then
      sudo cp /usr/share/applications/firefox-developer-edition.desktop /usr/share/applications/firefox-developer-edition.desktop.old
    fi
    sudo ln -s $HOME/dotfiles/gnome/firefox-developer-edition.desktop /usr/share/applications/
    firefox_dev_installed=true
  fi
  if [ "$firefox_dev_installed" = true ]; then
    sync_firefox_dev
    add_ssh_to_gits
  fi 
}

# Turn On Sync for Firefox
sync_firefox_dev() {
  local skipper
  printf "%s\n" "Press any key to open Firefox Developer Edition and set up syncing. Close Firefox when finished"
  read -p "Enter s to skip: " skipper
  echo $skipper
  if [[ $skipper != 's' && $skipper != 'S' ]]; then
    killall firefox
    /opt/firefox-developer-edition/firefox 
  fi
}

# Add SSH to Github/GitLab using Firefox Developer Edition
add_ssh_to_gits() {
  local skipper
  printf "%s\n" "Press any key to open Firefox and set up Github and GitLab.  Close Firefox when finished"
  read -p "Enter s to skip: " skipper
  echo $skipper
  if [[ $skipper != 's' && $skipper != 'S' ]]; then
    killall firefox
    xclip -sel clip < $HOME/.ssh/id_rsa.pub
    /opt/firefox-developer-edition/firefox www.github.com www.gitlab.com
  fi
}

install_chromium() {
  sudo snap install chromium
  printf "%s\n" "Press any key to open Chromium and set up syncing.  Close Chromium when finished"
  read -p "Enter s to skip: " SKIPPER
  if [[ $SKIPPER != 's' && $SKIPPER != 'S' ]]; then
    chromium 
  fi
}

install_qutebrowser() {
  sudo eopkg install -y qutebrowser mpv youtube-dl
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Qutebrowser! Aborting."
  fi
  #TODO: Install mpv and youtube-dl as well and qutebrowser config
}

install_vscode() {
  sudo eopkg install -y vscode
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing code editors and IDEs! Aborting."
  fi
}

install_postman() {
  sudo snap install postman
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Postman snap! Aborting."
  fi
}

install_bitwarden() {
  sudo snap install bitwarden
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing BitWarden! Aborting."
  fi
}

install_chats() {
  sudo snap install slack --classic
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Slack! Aborting."
  fi
  sudo snap install discord
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Discord! Aborting."
  fi
  #TODO: figure out the issue with xdg-open that "eventually" self-heals - URL Schemes maybe?
}

install_fonts() {
  sudo eopkg install -y font-awesome-ttf font-awesome-4 powerline-fonts font-firacode-ttf font-firacode-otf font-manager
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing font packages! Aborting."
  fi
  curl -o $TEMP_DIR/AnonymousPro-1.002.zip https://www.marksimonson.com/assets/content/fonts/AnonymousPro-1.002.zip
  unzip -d $TEMP_DIR/ $TEMP_DIR/AnonymousPro-1.002.zip
  sudo cp $TEMP_DIR/AnonymousPro-1.002*/*.ttf /usr/share/fonts/truetype/
  if [[ $? -ne 0 ]]; then
    error_exit "Error copying downloaed fonts! Aborting."
  fi
  fc-cache
  if [[ $? -ne 0 ]]; then
    error_exit "Error updating font cache! Aborting."
  fi
}

install_rice() {
  echo "TODO: Rice"
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing rice! Aborting."
  fi
}

install_powerline() {
  pip3 install --user powerline-status
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Powerline! Aborting."
  fi
  #TODO: Vim powerline not working
}

clone_dotfiles() {
  echo "TODO: Determine the best place for cloning dotfile"
  #TODO: Clone dotfiles repo - this is only neccessary if I'm going to curl the script down
  #git clone https://github.com/adamayd/dotfiles.git $HOME/dotfiles
  #if [[ $? -ne 0 ]]; then
    #error_exit "Error cloning dotfiles! Aborting."
  #fi
}

link_dotfiles() {
  echo "source $HOME/dotfiles/shellsrc" >> $HOME/.bashrc
  if [[ $? -ne 0 ]]; then
    error_exit "Error appending to .bashrc! Aborting."
  fi
  if [ -L $HOME/.vimrc ]; then
    rm $HOME/.vimrc
  elif [ -e $HOME/.vimrc ]; then
    cp $HOME/.vimrc $HOME/.vimrc_old
  fi
  ln -s $HOME/dotfiles/vimrc $HOME/.vimrc
  if [[ $? -ne 0 ]]; then
    error_exit "Error linking .vimrc! Aborting."
  fi
  ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
  ln -s $HOME/dotfiles/gitconfig $HOME/.gitconfig
  sudo ln -s $HOME/dotfiles/gnome/firefox-developer-edition.desktop /usr/share/applications/
}

install_vim() {
  sudo eopkg install -y vim 
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  #TODO: Install only the languages needed instead of all (ie don't need C#, Rust, etc...)
  python3 install.py --all
}

install_oh_my_bash() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

cleanup_installation() {
  sudo eopkg rmo
  #remove temp dirs??
}

#create_install_temp_dir
#install_base_utilities
#install_command_line_fun
#install_security_utilities
#create_ssh_key
#install_power_management
#TODO: install_i3_window_manager
#install_base_development_system
#TODO: install_solus_packaging
#install_node
#install_python
#install_go
#install_elixir
#install_java
#TODO: install_databases
#install_docker
#install_config_mgmt
#install_provisioning
#install_serverless_framework
#TODO: install_cloud_cli_tools
#install_firefox_dev
#sync_firefox_dev
#add_ssh_to_gits
#install_chromium
#install_qutebrowser
#install_vscode
#install_postman
#install_bitwarden
#install_chats
#install_rice
#install_fonts
#install_powerline
#clone_dotfiles
#link_dotfiles
#install_vim
#TODO: install_oh_my_bash
#cleanup_installation
