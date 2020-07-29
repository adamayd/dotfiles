#! /bin/bash

error_exit()
{
  echo "$1" 1>&2
  exit 1
}

update_repos() { 
  sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  #sudo dnf install -y http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm 
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo ln -s $HOME/dotfiles/fedora/repos/vscode.repo /etc/yum.repos.d/vscode.repo
  sudo dnf update -y && sudo dnf upgrade -y
}

install_base_utilities() {
  #TODO: Exfat in kernel fix
  sudo dnf install -y ranger vifm strace curl wget tmux xclip jq fzf bat
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing base utilities! Aborting."
  fi
}

install_command_line_fun() {
  sudo dnf install -y cmatrix neofetch fortune-mod cowsay
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing command line fun! Aborting."
  fi
}


install_security_utilities() {
  sudo dnf install -y gnupg1 gnupg2 pass
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing security utilities! Aborting."
  fi
}

create_ssh_key() {
  if [ ! -d "$HOME/.ssh" ]; then
    ssh-keygen -t rsa -b 4096 -C adam.ayd@gmail.com
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa
  fi
}

install_acpi_tlp() {
  #TODO: F32 TLP for Thinkpads
  sudo dnf install -y tlp tlp-rdw smartmontools
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing TLP! Aborting."
  fi
  sudo dnf install -y kernel-devel akmod-acpi_call akmod-tp_smapi
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing ACPI Kernal Module! Aborting."
  fi
  sudo tlp start
  if [[ $? -ne 0 ]]; then
    error_exit "Error starting TLP! Aborting."
  fi
}

install_base_development_system() {
  sudo dnf groupinstall -y "Development Tools"
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the development tools! Aborting."
  fi
  sudo dnf groupinstall -y "C Development Tools and Libraries"
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the c development tools and libraries! Aborting."
  fi
  sudo dnf install -y python3-devel cmake
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing additional development tools and libraries! Aborting."
  fi
}

install_fedora_packaging() {
  sudo dnf install -y fedora-packager @development-tools
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing the Fedora packaging tools! Aborting."
  fi
  sudo usermod -aG mock $USER
  if [[ $? -ne 0 ]]; then
    error_exit "Error adding $USER to mock group! Aborting."
  fi
  rpmdev-setuptree
  if [[ $? -ne 0 ]]; then
    error_exit "Error setting up rpm dev tree! Aborting."
  fi
  # TODO: Refactor to use a separate user for packaging
}

install_fedora_releng() {
  echo "TODO: Install RelEng tooling for F31"
  #TODO: Install tooling for Fedora Release Engineering
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
  sudo dnf install -y yarnpkg
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Yarn! Aborting."
  fi

  # Install Node Utilities
  sudo yarn global add create-react-app @vue/cli eslint gatsby-cli @gridsome/cli jest
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Node utilities using Yarn! Aborting."
  fi
}

install_python() {
  sudo dnf install -y  python3-devel pipenv
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Python! Aborting."
  fi
}

install_go() {
  sudo dnf install -y golang
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Go! Aborting."
  fi
}

install_elixir() {
  echo "TODO: Determine how and if to install Elixir on F31"
  #TODO: Install Elixir
  #sudo dnf install elixir stuff (asdf)
}

install_java() {
  sudo dnf install -y java-11-openjdk-devel java-1.8.0-openjdk-devel
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Java! Aborting."
  fi
}

install_build_tools() {
  wget -O $HOME/Downloads/gradle-6.3-bin.zip https://services.gradle.org/distributions/gradle-6.3-bin.zip
  sudo unzip -d /opt/ $HOME/Downloads/gradle-6.3-bin.zip
  export PATH=$PATH:/opt/gradle-6.3/bin
}

install_docker() {
  #TODO: Install Podman in place of Docker and Docker Compose
  #sudo dnf remove -y docker docker-client docker-client-latest docker-common \
                  #docker-latest docker-latest-logrotate docker-logrotate \
                  #docker-selinux docker-engine-selinux docker-engine
  #sudo dnf install -y dnf-plugins-core
  #sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  #if [[ $? -ne 0 ]]; then
    #error_exit "Error adding Docker-CE repo! Aborting."
  #fi
  #sudo dnf install -y docker-ce docker-ce-cli containerd.io
  #if [[ $? -ne 0 ]]; then
    #error_exit "Error installing Docker-CE! Aborting."
  #fi
  sudo dnf install -y moby-engine moby-engine-vim
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Moby-Engine! Aborting."
  fi
  sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Docker-Compose! Aborting."
  fi
}

install_kubernetes_tools() {
  echo "TODO: Install kubernetes tools (MiniKube, OKD, etc...)"
  #TODO: Install MiniKube, OKD
}

install_config_mgmt() {
  # Install Ansible
  sudo dnf install -y ansible
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Ansible! Aborting."
  fi
}

install_provisioning() {
  wget -O $HOME/Downloads/terraform_0.12.24_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
  if [[ $? -ne 0 ]]; then
    error_exit "Error downloading Terraform! Aborting."
  fi
  sudo unzip -d /usr/local/bin/ $HOME/Downloads/terraform_0.12.24_linux_amd64.zip
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
  sudo dnf install -y python3-boto3
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

install_chromium() {
  sudo dnf install -y chromium
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Chromium! Aborting."
  fi
  printf "%s\n" "Press any key to open Chromium and set up syncing.  Close Chromium when finished"
  read -p "Enter s to skip: " SKIPPER
  if [[ $SKIPPER != 's' && $SKIPPER != 'S' ]]; then
    chromium-browser
    if [[ $? -ne 0 ]]; then
      error_exit "Error running Chromium! Aborting."
    fi
  fi
}

install_qutebrowser() {
  sudo dnf install -y qutebrowser mpv youtube-dl
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Qutebrowser! Aborting."
  fi
  #TODO: Install qutebrowser config
}

install_vscode() {
  sudo dnf install -y code
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Visual Studio Code! Aborting."
  fi
}

add_flatpak_repos() {
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  if [[ $? -ne 0 ]]; then
    error_exit "Error adding Flatpak repo for Flathub! Aborting."
  fi
}

install_postman() {
  sudo flatpak install -y postman
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Postman snap! Aborting."
  fi
}

install_bitwarden() {
  sudo flatpak install -y bitwarden
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing BitWarden! Aborting."
  fi
}

install_chats() {
  sudo flatpak install -y slack
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Slack! Aborting."
  fi
  sudo flatpak install -y discord
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Discord! Aborting."
  fi
}

install_fonts() {
  sudo dnf install -y fontawesome-fonts fontawesome-fonts-web powerline-fonts fira-code-fonts
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing fonts! Aborting."
  fi
  # TODO: web-fonts, ms and mac standard fonts, hack font, anonymous pro
}

install_graphics_apps() {
  sudo dnf install -y inkscape gimp
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing fonts! Aborting."
  fi
  # TODO: darktable, shotwell??
}

install_i3wm() {
  echo "TODO: Install i3wm or sway"
  #TODO: Install i3wm
  #sudo dnf it -y i3 rofi xbacklight feh
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
  sudo dnf install -y vim 
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
  python3 $HOME/.vim/plugged/YouCompleteMe/install.py --clangd-completer --go-completer --ts-completer --java-complete
  cd $HOME
  mkdir -p $HOME/.vim/spell $HOME/.vim/undodir
  ln -s $HOME/dotfiles/vim/spell/en.utf-8.add $HOME/.vim/spell/en.utf-8.add
}

install_oh_my_bash() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  if [[ $? -ne 0 ]]; then
    error_exit "Error installing Oh-My-Bash! Aborting."
  fi
}

#update_repos
#install_base_utilities #TODO: - Exfat in kernel
#install_command_line_fun
#install_security_utilities
#create_ssh_key #TODO: - refactor for email input
#install_acpi_tlp #TODO: - F32 TLP manual install for thinkpads
#install_base_development_system
install_fedora_packaging
#TODO: install_fedora_releng
#install_node
#install_python
#install_go
#install_elixir
#install_java #TODO: - combine with gradle/build tools below
#TODO: install_build_tools
#install_docker # docker-ce and cgroups v1
#install_kubernetes_tools #TODO: - finish install
#install_config_mgmt
#install_provisioning
#install_cloud_cli_tools #TODO: - finish all of them
#install_serverless_framework
#install_firefox_dev #TODO: - update to latest logic
#install_chromium #TODO: 
#install_qutebrowser #TODO: - config and extras setup
#install_vscode #TODO: - create and copy over config files
#add_flatpak_repos
#install_postman
#install_bitwarden
#install_chats
#install_fonts #TODO: - hack font for fedora
#TODO: install_i3wm
#TODO: install_graphics_apps # darktable, shotwell??
#TODO: install_rice - no rice set
#install_powerline
#TODO: clone_dotfiles - proper location for script running from web
#link_dotfiles
#install_vim #TODO: - gruvbox error on initial load for plugin install
#install_oh_my_bash #TODO: #- link .bashrc correctly and choose powerline-multiline
#TODO: find place for vifm

