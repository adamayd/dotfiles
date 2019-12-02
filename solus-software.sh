#! /bin/bash
sudo eopkg install zsh ranger lm_sensors tlp htop unzip git neofetch cmatrix
sudo eopkg install gnupg password-store
sudo eopkg install qutebrowser
sudo eopkg install font-awesome-ttf font-awesome-4 powerline-font
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
sudo eopkg install mongodb tmux openjdk-8
npm i -g yarn create-react-app vue-cli eslint gatsby gridsome
sudo eopkg install -c system.devel
snap install chromium postman #dotnet-runtime-22
sudo snap install slack --classic
#sudo snap install dotnet-sdk --classic
sudo snap install pycharm-community --classic
sudo snap install vscode --classic

# TODO: Confirm Commands
#
#sudo eopkg install terraform
#sudo eopkg install ansible
#sudo eopkg install gradle
#sudo eopkg install pip pipenv
#sudo eopkg install boto3
#pip install --user awscli
#sudo eopkg install tlp libelf linux-headers-current
#git clone acpi_call package
#cd acpi_call && make
#sudo make install
#cd .. && rm -rf acpi_call
#sudo eopkg install elixir stuff (asdf)
#sudo eopkg install rust stuff

# TODO: Move dotfiles into place
