# Version 2 On The Way

I am currently working on Version 2 of my dotfiles that will be much more flexible to either of my systems or a new build.  Also I'm re-aligning my system builds to help my project developement and studies for cloud native development and transformations.

Please look at [dotfilesv2.md](docs/dotfilesv2.md) for more information.

# .T460dotfiles
These dotfiles are not intended for use other than my personal Thinkpad.  Feel free to use them in anyway you wish, but be advised.  There are many irreversible changes that WILL ERASE YOUR HARD DRIVE.  I started recently with a clean nuke and pave and have been moving in an outline then script model.  Once I get through the base system installs I will start working on the unixporn stuff and get some screenshots posted.  As of now, this is my system:
### Arch Base System
* UEFI Install
* 500MB EFI Partition
* 8GB Swap Partition
* Remaining EXT4 Partition

### Base CLI Utilities
* Vim - text editor
* Zsh - shell (Oh-My-Zsh)
* Ranger - CLI File Manager
* Termite - Terminal
* Yaourt - AUR Installer

### Desktop Environment
note: I tried Wayland/Weston and Sway but had issues with lag and compositing.  This is probably due to my lack of experience with both and I do wish to try them again later when I have more time or maybe on my T430.
* Xorg - windows server
* i3 WM - window manager (i3-gaps in the works)
* i3 locks - lockscreen
* i3 statusbar - status bar (testing polybar, lemonbar, and powerline)
* Light DM - display manager (using gtk greeter, but webkit-greeter in the works)

### Basic Software
* QuteBrowser - web browser with Vim key bindings
* NeoMutt - CLI email client
* Calendar??? - CLI calendar
* CMusic??? - CLI calendar
* Dunst??? - Notifications
* Slack - Chat client
* Gitter - github repo based chat client
* Transmission - torrent client

### Development Software
* Postman - HTTP communication client
* Firefox Developer Edition - web browser
* Chromium - web browser
* VS Code - coding text editor
* Git Kraken - git GUI client

### Development Environment
* Node.JS - javascript environment
* NVM - node version manager
* NPM - node package manager
* Python - python 2 & 3 enviroments
* PyPy - lightweight python environment
* Pip - python package manager
* Ruby - ruby environment
* RVM/RBEnv??? - ruby version manager
* MongoDB - database
* Apache - web server
* PHP - php environment
* MariaDB - fully mysql compatible database

I'm sure I've forgotten things.  I'll add them as I work through the scripts.

## Clean install steps

If you clone the repo, remember to change the github user name to yours in the `install.sh`.  It should still work, but if you make any changes to the `vsdo.sh` or `chrt.sh` the `install.sh` will still point to my repo

On boot of the Arch Linux ISO image as of 06/2018 you will need to do the following commands to get going:

```
wifi-menu
```

I usually `ping -c 3 www.google.com` first to make sure I've connected properly.  Then download `install.sh` with the following command and run it.  Make sure your permissions are correct before running with `chmod 755 install.sh`

```
curl --remote-name https://raw.githubusercontent.com/adamayd/T460dotfiles/master/install.sh
```

## Adding support for Ubuntu 18.04 on Windows Subsystem for Linux

To help quickly get up to speed on C#, I've decided to dual boot Windows 10 Pro and Arch Linux.  With the Windows Subsystem for Linux getting better with every major update, I've also decided to run the Ubunut 18.04 WSL to ease my transition back into windows.  You may even start seeing some PowerShell scripts show up.  The majority of WSL goodies are in the `wsl` directory along with a `wslinstall.md` that will start as my notes and expand to scripts and instructions.
