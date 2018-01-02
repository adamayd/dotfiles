#! /bin/bash

# Attach to Wifi
clear
nmcli dev wifi list
read -p 'Enter the SSID of the network: ' SSID
read -p 'Enter the password: ' WPAPASS
nmcli dev wifi connect $SSID password $WPAPASS

# Install base CLI software
sudo pacman -S --noconfirm git lm_sensors tlp htop archey3 openssh exfat-utils vim bash-completion ranger termite yaourt

# Clone repo and start installations by segment

# Install XOrg and i3wm

# Install Light DM

# Install Audio

# Install System Fonts

# Install LAMP

