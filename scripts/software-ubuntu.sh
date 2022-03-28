#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

update_repos() { 
  sudo apt update -y
}

install_base_utilities() {
  sudo apt install -y ranger exfat-utils exfat-fuse strace curl wget tmux xclip jq
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing base utilities! Aborting."
  fi
}

install_command_line_fun() {
  sudo apt install -y cmatrix neofetch fortune-mod cowsay
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing command line fun! Aborting."
  fi
}

install_security_utilities() {
  sudo apt install -y gnupg1 gnupg2 pass gnupg-agent
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

install_acpi_tlp() {
  sudo apt install -y tlp tlp-rdw smartmontools
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing TLP! Aborting."
  fi
  sudo apt install -y kernel-devel akmod-acpi_call akmod-tp_smapi
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing ACPI Kernal Module! Aborting."
  fi
  sudo tlp start
  if [[ $? -ne 0 ]]; then
    error_exit "Error starting TLP! Aborting."
  fi
}

install_base_development_system() {
  sudo apt install -y build-essential
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the development tools! Aborting."
  fi
  sudo apt install -y python3-dev cmake
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing additional development tools and libraries! Aborting."
  fi
}

install_node() {
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Node Version Manager! Aborting."
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
  nvm install --lts

  # Install Yarn for Node JS
  sudo apt install -y yarnpkg
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Yarn! Aborting."
  fi

  # Install Node Utilities
  sudo yarnpkg global add create-react-app @vue/cli eslint gatsby-cli @gridsome/cli jest
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Node utilities using Yarn! Aborting."
  fi
}

install_python() {
  sudo apt install -y  python3-dev pipenv
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Python! Aborting."
  fi
}

install_go() {
  sudo apt install -y golang
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Go! Aborting."
  fi
}

install_elixir() {
  echo "TODO: Determine how and if to install Elixir on F31"
  #TODO: Install Elixir
  #sudo apt install elixir stuff (asdf)
}

install_java() {
  sudo apt install -y openjdk-11-jdk
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Java! Aborting."
  fi
}

install_build_tools() {
  sudo apt install -y gradle
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Gradle! Aborting."
  fi
}

install_docker() {
  #TODO: Install Docker and Docker Compose
  sudo apt install -y docker.io docker-compose
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Docker! Aborting."
  fi
  sudo usermod -aG docker $USER
}

install_kubernetes_tools() {
  sudo apt install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update && sudo apt-get install -y kubectl
  curl -o $HOME/Downloads/minikube_1.9.20-0_amd64.deb -LO https://storage.googleapis.com/minikube/releases/latest/minikube_1.9.2-0_amd64.deb
  sudo dpkg -i $HOME/Downloads/minikube_1.9.2-0_amd64.deb
  #TODO: OKD
}

install_config_mgmt() {
  # Install Ansible
  sudo apt install -y ansible
}

install_provisioning() {
  echo "TODO: Determine how to install terraform on F31"
  # Install Terraform
  wget -O $HOME/Downloads/terraform_0.12.24_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
  sudo unzip -d /usr/local/bin/ $HOME/Downloads/terraform_0.12.24_linux_amd64.zip
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
  sudo apt install -y python3-boto3
  pip3 install --user awscli
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

install_brave() {
  echo "TODO: Determine how to install brave"
  #TODO: Install Brave
}

install_chromium() {
  sudo apt install -y chromium-browser
  printf "%s\n" "Press any key to open Chromium and set up syncing.  Close Chromium when finished"
  read -p "Enter s to skip: " SKIPPER
  if [[ $SKIPPER != 's' && $SKIPPER != 'S' ]]; then
    chromium 
  fi
}

install_qutebrowser() {
  sudo apt install -y qutebrowser mpv youtube-dl
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Qutebrowser! Aborting."
  fi
  #TODO: Install qutebrowser config
}

install_vscode() {
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $HOME/Downloads/packages.microsoft.gpg
  sudo install -o root -g root -m 644 $HOME/Downloads/packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update -y && sudo apt install -y code
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Visual Studio Code! Aborting."
  fi
}

install_snapd() {
  sudo apt install -y snapd
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Snap Daemon! Aborting."
  fi
  sudo systemctl start snapd
  if [[ $? -ne 0 ]]; then
    error_exit "Error starting Snap Daemon! Aborting."
  fi
  sudo systemctl enable snapd
  if [[ $? -ne 0 ]]; then
    error_exit "Error enabling Snap Daemon! Aborting."
  fi
  sudo ln -s /var/lib/snapd/snap /snap
  if [[ $? -ne 0 ]]; then
    error_exit "Error linking to /snap for classic confinement! Aborting."
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
}

install_fonts() {
  sudo apt install -y fonts-font-awesome fonts-powerline fonts-firacode
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing fonts! Aborting."
  fi
  # TODO: web-fonts, ms and mac standard fonts
}

install_i3wm() {
  echo "TODO: Install i3wm or sway"
  #TODO: Install i3wm
  #sudo apt it -y i3 rofi xbacklight feh
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
}

install_vim() {
  sudo apt install -y vim 
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  #TODO: Install only the languages needed instead of all (ie don't need C#, Rust, etc...)
  python3 install.py --all
}

install_oh_my_bash() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

#update_repos
#install_base_utilities
#install_command_line_fun
#install_security_utilities
#create_ssh_key
#install_acpi_tlp
#install_base_development_system
#install_node
#install_python
#install_go
#install_elixir
#install_java
#install_build_tools
#install_docker
#install_kubernetes_tools
#install_config_mgmt
#install_provisioning
#TODO: install_cloud_cli_tools
#install_serverless_framework
#install_firefox_dev
#TODO: install_brave
#install_chromium
#TODO: install_qutebrowser
#install_vscode
#install_snapd
#install_postman
#install_bitwarden
#install_chats
install_fonts
#TODO: install_i3wm
#TODO: install_rice
#install_powerline
#clone_dotfiles
#link_dotfiles
#install_vim
#install_oh_my_bash

