#! /bin/bash

error_exit()
{
  echo "Error in $1 section. Exiting" 1>&2
  exit 1
}

update_repos() { 
  sudo dnf -y install dnf-plugins-core
  sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
  sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install -y http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm 
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo ln -s $HOME/dotfiles/fedora/repos/vscode.repo /etc/yum.repos.d/vscode.repo
  sudo dnf update -y && sudo dnf upgrade -y
}

install_base_utilities() {
  #TODO: Exfat in kernel fix
  sudo dnf install -y ranger vifm strace curl wget tmux xclip jq fzf bat fuse-exfat exfat-utils dnf-plugins-core
}

install_command_line_fun() {
  sudo dnf install -y cmatrix neofetch fortune-mod cowsay
}


install_security_utilities() {
  # TODO: Look at keybase for storing keys on nuke & pave
  sudo dnf install -y gnupg1 gnupg2 pass openssh
  # TODO: fix gpg key generation to work without prompts
  # cat /etc/passwd | grep $USER | cut -d: -f5 #user real name
  gpg --full-gen-key
  read -p 'Enter email address associated with your GPG key' GPGEMAIL
  pass init $GPGEMAIL
}

create_ssh_key() {
  # TODO: Look at keybase for storing keys on nuke & pave
  read -p "Enter the email address you want associated with your SSH key: " EMAILSSH 
  ln -s $HOME/dotfiles/ssh/config $HOME/.ssh/config
  if [ ! -d "$HOME/.ssh" ]; then
    ssh-keygen -t rsa -b 4096 -C $EMAILSSH
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa
  fi
}

install_acpi_tlp() {
  sudo dnf install -y tlp tlp-rdw smartmontools
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm
  sudo dnf install -y kernel-devel akmod-acpi_call
  sudo tlp start
}

install_base_development_system() {
  sudo dnf groupinstall -y "Development Tools"
  sudo dnf groupinstall -y "C Development Tools and Libraries"
  sudo dnf install -y cmake
}

install_fedora_packaging() {
  sudo dnf install -y fedora-packager @development-tools
  sudo usermod -aG mock $USER
  rpmdev-setuptree
  # TODO: Refactor to use a separate user for packaging
}

install_fedora_releng() {
  echo "TODO: Install RelEng tooling for F31"
  #TODO: Install tooling for Fedora Release Engineering
}

install_node() {
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
  nvm install --lts

  # Install Yarn for Node JS
  sudo dnf install -y yarnpkg
  sudo ln -s /usr/bin/yarnpkg /usr/bin/yarn

  # Install Node Utilities
  yarn global add create-react-app eslint gatsby-cli jest 
}

install_python() {
  sudo dnf install -y  python3-devel pipenv
}

install_go() {
  sudo dnf install -y golang
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.35.0
  go get github.com/go-delve/delve/cmd/dlv
}

install_java() {
  sudo dnf install -y java-11-openjdk-devel java-1.8.0-openjdk-devel
  wget -O $HOME/Downloads/gradle-6.3-bin.zip https://services.gradle.org/distributions/gradle-6.3-bin.zip
  sudo unzip -d /opt/ $HOME/Downloads/gradle-6.3-bin.zip
  rm $HOME/Downloads/gradle-6.3-bin.zip
  export PATH=$PATH:/opt/gradle-6.3/bin
}

install_virt() {
  cat /proc/cpuinfo | egrep "vmx|svm" #TODO: error break
  sudo dnf group install -y --with-optional virtualization
  sudo systemctl enable libvirtd
}

install_db_clients() {
  sudo dnf install -y community-mysql postgresql
}

install_docker() {
  #TODO: Install Podman in place of Docker and Docker Compose
  sudo dnf remove -y docker docker-client docker-client-latest docker-common \
                  docker-latest docker-latest-logrotate docker-logrotate \
                  docker-selinux docker-engine-selinux docker-engine
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io
  #sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
  sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
}

install_kubernetes_tools() {
  sudo dnf install -y kubernetes
  curl -Lo $HOME/Downloads/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
  chmod +x $HOME/Downloads/minikube
  sudo install $HOME/Downloads/minikube /usr/local/bin/
}

install_config_mgmt() {
  sudo dnf install -y ansible
  # TODO: add ansible user and ssh key for the user.
}

install_provisioning() {
  sudo dnf install -y terraform-0.14.2-1
}

install_serverless_framework() {
  curl -o- -L https://slss.io/install | bash
}

install_aws_cli_tools() {
  # Install AWS and Boto3
  #TODO: boto3 error on install asking for dependency botocore
  sudo dnf install -y python3-boto3
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o $HOME/Downloads/awscliv2.zip
  unzip -d $HOME/Downloads/ $HOME/Downloads/awscliv2.zip
  sudo $HOME/Downloads/aws/install
  pip3 install --user aws-mfa
  #TODO: Install Digital Ocean Tools
  #TODO: Install Azure CLI
  #TODO: Install GCP CLI
}

install_gcp_cli_tools() {
  curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-323.0.0-linux-x86_64.tar.gz -o $HOME/Downloads/gcpcli.tar.gz
  tar -xvf $HOME/Downloads/gcpcli.tar.gz -C $HOME/Downloads/
  $HOME/Downloads/google-cloud-sdk/install.sh
  $HOME/Downloads/google-cloud-sdk/bin/gcloud init
}

# TODO: Use cypress.io to automate the firefox and chromium installations

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
  printf "%s\n" "Press any key to open Chromium and set up syncing.  Close Chromium when finished"
  read -p "Enter s to skip: " SKIPPER
  if [[ $SKIPPER != 's' && $SKIPPER != 'S' ]]; then
    chromium-browser
  fi
  #FIXME: chrome://flags/#enable-webrtc-pipewire-capturer for screen capturing to work in all chromium based applications
}

install_qutebrowser() {
  sudo dnf install -y qutebrowser mpv youtube-dl
  #TODO: Install qutebrowser config
}

install_vscode() {
  sudo dnf install -y code
}

install_gui_tools() {
  sudo dnf install -y hexchat gnome-tweaks mousetweaks
  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" # HiDPI Fractional Scaling
}

install_zoom() {
  wget https://zoom.us/client/latest/zoom_x86_64.rpm -O $HOME/Downloads/zoom_x86_64.rpm
  sudo dnf install -y $HOME/Downloads/zoom_x86_64.rpm
  ln -s $HOME/dotfiles/config/zoomus.conf $HOME/.config/zoomus.conf
  sudo dnf install -y hexchat gnome-tweaks
}

install_video_playback() {
  sudo dnf install -y mpv
}

add_flatpak_repos() {
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_postman() {
  sudo flatpak install -y postman
}

install_bitwarden() {
  sudo flatpak install -y bitwarden
}

install_keybase() {
  sudo dnf install -y https://prerelease.keybase.io/keybase_amd64.rpm
}

install_zoom() {
  sudo flatpak install -y zoom
}

install_chats() {
  sudo flatpak install -y slack
  sudo flatpak install -y discord
  # TODO: matrix
}

install_fonts() {
  sudo dnf install -y fontawesome-fonts fontawesome-fonts-web powerline-fonts fira-code-fonts
  # TODO: web-fonts, ms and mac standard fonts, hack font, anonymous pro
}

install_graphics_apps() {
  sudo dnf install -y inkscape gimp
  # TODO: darktable, shotwell, pdfsam, libre-office
}

install_i3wm() {
  echo "TODO: Install i3wm or sway"
  #TODO: Install i3wm
  #sudo dnf it -y i3 rofi xbacklight feh
}

install_rice() {
  echo "TODO: Rice"
}

install_powerline() {
  pip3 install --user powerline-status
  #TODO: Vim powerline not working
}

update_dotfiles() {
  git remote remove origin
  git remote add origin git@github.com:adamayd/dotfiles.git
  git push -u origin master
}

link_dotfiles() {
  echo "source $HOME/dotfiles/shellsrc" >> $HOME/.bashrc
  ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
  ln -s $HOME/dotfiles/gitconfig $HOME/.gitconfig
}

update_grub() {
  sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/g' /etc/default/grub
  sudo echo "GRUB_TIMEOUT_STYLE=\"hidden\"" >> /etc/default/grub
  sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
}

install_vim() {
  if [ -L $HOME/.vimrc ]; then
    rm $HOME/.vimrc
  elif [ -e $HOME/.vimrc ]; then
    mv $HOME/.vimrc $HOME/.vimrc_old
  fi
  ln -s $HOME/dotfiles/vimrc $HOME/.vimrc
  sudo dnf install -y vim 
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
  python3 $HOME/.vim/plugged/YouCompleteMe/install.py --clangd-completer --go-completer --ts-completer --java-complete
  cd $HOME
  mkdir -p $HOME/.vim/spell $HOME/.vim/undodir
  ln -s $HOME/dotfiles/vim/spell/en.utf-8.add $HOME/.vim/spell/en.utf-8.add
  sudo dnf remove -y nano
}

install_neovim() {
  if [ -L $HOME/.config/nvim/init.vim ]; then
    rm -rf $HOME/.config/nvim
  elif [ -e $HOME/.config/nvim/init.vim ]; then
    mv $HOME/.config/nvim $HOME/.config/nvim_old
    mkdir -p $HOME/.config/nvim
  fi
  ln -s $HOME/dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim
  ln -s $HOME/dotfiles/config/nvim/config-plug/ $HOME/.config/nvim/
  sudo dnf install -y neovim
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim --headless +PlugInstall +qall
}
   
install_oh_my_bash() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

#update_repos || error_exit "Update Repos"
#install_base_utilities || error_exit "Base Utilites" #TODO: Exfat in kernel
#install_base_development_system || error_exit "Base Development"
#install_command_line_fun || error_exit "Command Line Fun"
#install_security_utilities || error_exit "Security Utilites" #TODO: GPG command arguments build out
#create_ssh_key || error_exit "Creating SSH Key" #TODO: - refactor for email input
#install_acpi_tlp || error_exit "ACPI/TLP" #TODO: - F32 TLP manual install for thinkpads
#install_base_development_system || error_exit "Base Development"
#install_fedora_packaging || error_exit "Fedora Packaging"
#TODO: install_fedora_releng || error_exit "Fedora Release Engineering"
#install_node || error_exit "Node JS"
#install_python || error_exit "Python"
#install_go || error_exit "Go Lang"
#install_java || error_exit "Java" #TODO: - combine with gradle/build tools below
#install_virt || error_exit "Virtual Machine" #TODO: error break for virt bios detection
#install_docker || error_exit "Docker" # docker-ce and cgroups v1
#install_db_clients || error_exit "Database Clients"
#install_kubernetes_tools || error_exit "Kubernetes" #TODO: - finish install
#install_config_mgmt || error_exit "Configuration Management"
#install_provisioning || error_exit "Provisioning"
#install_aws_cli_tools || error_exit "AWS CLI Tools" #TODO: - finish all of them
#install_gcp_cli_tools || error_exit "Google Cloud SDK"
#install_serverless_framework || error_exit "Serverless Framework"
#install_firefox_dev || error_exit "Firefox Developer Edition" #TODO: - update to latest logic and create failsafe for browser opening
#install_chromium || error_exit "Chromium" #TODO: 
#install_qutebrowser || error_exit "QuteBrowser" #TODO: - config and extras setup
#install_vscode || error_exit "VS Code" #TODO: - create and copy over config files
#install_gui_tools || error_exit "GUI Tools" #TODO: - get all GUI tools
#install_video_playback || error_exit "Video Playback"
#add_flatpak_repos || error_exit "Flatpak Repos"
#install_postman || error_exit "Postman"
#install_bitwarden || error_exit "Bitwarden"
#install_keybase || error_exit "Keybase"
#install_zoom || error_exit "Zoom"
#install_chats || error_exit "Chats" #TODO: matrix
#install_fonts || error_exit "Fonts" #TODO: - hack font for fedora
#TODO: install_i3wm || error_exit "I3 Window Manager"
#TODO: install_graphics_apps || error_exit "Graphics Apps" # darktable, shotwell??
#TODO: install_rice || error_exit "Rice" - no rice set
#install_powerline || error_exit "Powerline"
#update_dotfiles || error_exit "Dotfiles"
#link_dotfiles || error_exit "Linking Dotfiles" - #TODO: Link dotfiles with appropriate installs instead of at once
#update_grub || error_exit "Grub"
#install_vim || error_exit "Vim"
install_neovim || error_exit "Neovim"
#install_oh_my_bash || error_exit "Oh My Bash" #TODO: Link bashrc correctly and choose powerline-multiline
#TODO: vifm to look and operate more like ranger with previews.

