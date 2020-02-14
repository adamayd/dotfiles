# Dotfiles Version 2

This document is a roadmap for installation of OS and software for a few distros as well as VMs both server and workstation.  The document will help keep software organized by distros and purpose.  

## OS Installation

The thought is to dual boot Arch (in Xorg) and Fedora Workstation (in Wayland) with possibly using Solus in a VM for contributing purposes.  

### Arch Linux

Bash will continue to be used for installation from the ISO.  The scripts will be updated to provide more flexibility for the target machine (currently T430 or T490).  Currently experiencing issue with bootloader on T490 after install.  Need to check BIOS settings for correct UEFI setup.

### Fedora Workstation and Solus 

Using built in installers for each OS. Currently running Fedora Workstation on bare metal but occasionally hop to Solus.

### Server Virtural Machines

Plan to keep at least the following server VMs for development and testing for now possibly until the a better understanding of container based development environments

* CentOS 7
* CentOS 8
* Ubuntu Current LTS
* Ubuntu Current Release

## Software Installation

All software installation will be moved to ansible playbooks.  

### Base Software

* i3wm / sway - look at justmeandopensource for i3 dotfiles
* rofi
* urxvt / termite / TBD...
* ranger
* feh and utils ...
* neomutt - look at luke smith
* hexchat, slack, discord, irssi, gitter

### Development Software

There may be different paths and this will most definitely change with knowledge increase of containerized development envs.  All development is going to push to VIM instead of VS Code.  Look at the following:

* tpope 
* thePrimeagen

Should always support at least the following:

* Base Devel Libs C/C++ etc...
* Javascript
  * Node - NVM
  * React - CRA, Gatsby
  * Vue - Vue CLI, Gridsome
  * ESLint
  * Testing - Mocha, Jest, Cypress
* Python
  * pipenv
  * Django
  * Flask
  * Testing

## Containerization

Lets containerize all the things.  Learning more about containers, I want to move to all container based development.  Look for examples of volumes mounted in the container with nodemon running.

Install the following:

* Docker CE client / service
* MiniKube for kubernetes local testing

## Cloud

For interaction with cloud providers.  Currently using AWS and DO but hope to expand knowledge

* AWS CLI - pip install
* Digital Ocean Cloud Controller Manager (CCM) - git clone

## CI/CD

All projects should be utilizing CI/CD/CD in some shape or form.  I want to use a mix of Jenkins and CirclCI.  Testing needs to be integrated as well.  I am pushing for TDD on all projects going forward and retroactively for continuing projects.


