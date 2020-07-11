# Dotfiles Version 2

This document is a roadmap for installation of OS and software for a few distros as well as VMs both server and workstation.  The document will help keep software organized by distros and purpose.  

## OS Installation

The thought is to dual boot Arch (install in Xorg) and Fedora Workstation (in Wayland) with Solus in a VM for contributing purposes.  

### Arch Linux

Bash will continue to be used for installation from the ISO.  The scripts will be updated to provide more flexibility for the target machine (currently T430 or T490).  Currently experiencing issue with bootloader on T490 after install.  Need to check BIOS settings for correct UEFI setup.

### Workstation Virtual Machines 

Using built-in installers for each OS. Currently running Fedora Workstation on bare metal but could switch to VM. Using Solus and Pop_OS for the purpose of contributing back to these distros in addition to Arch and Fedora.

* Fedora Workstation 32
* Solus Linux 4.1
* Pop_OS 20.04

### Server Virtural Machines

Plan to keep at least the following server VMs for development and testing for now possibly until the a better understanding of container based development environments

* CentOS 8
* Ubuntu Current LTS

## Software Installation

All software installation will be moved to ansible playbooks.  

### Base Software

* i3wm / sway - look at justmeandopensource for i3 dotfiles
* rofi
* urxvt / termite / alacritty /TBD...
* ranger / vifm
* feh and utils ...
* neomutt - look at luke smith
* hexchat, slack, discord, irssi, gitter

### Development Software

There may be different paths and this will most definitely change with knowledge increase of containerized development envs.  All development is going to push to VIM instead of VS Code.  Look at the following:

* thePrimeagen vimrc

Notable Vim Plugins
* Vundle
* fugitive
* YouCompleteMe
* gruvbox

Should always support at least the following:

* Base Devel Libs C/C++ etc...
* Javascript
  * Node - NVM
  * React - CRA, Gatsby
  * Vue - Vue CLI, Gridsome
  * ESLint
  * Testing - Mocha, Jest, Cypress
* Python (3)
  * pipenv / virtualenv
  * Django
  * Flask
  * Testing
* Go
* Java

### Databases

* MariaDB 
* PostgreSQL
* Mongo

### Containerization

Lets containerize all the things.  Learning more about containers, I want to move to all container based development.  Look for examples of volumes mounted in the container with nodemon running.

Install the following:

* Docker Community Edition / Moby Engine / Podman (Fedora)
* Docker Compose
* MiniKube for kubernetes local testing
* ctop

### Microservices Architecture

Build apps based on event driven Microservices Architecture.  This is going to be overkill for most apps but good practice for larger scale apps.

* MQTT
* RabbitMQ 

### Cloud

For interaction with cloud providers.  Currently using AWS and DO but hope to expand knowledge

* AWS CLI - pip install
* Digital Ocean Cloud Controller Manager (CCM) - git clone
* Azure
* Google Cloud Platform

### CI/CD

All projects should be utilizing CI/CD/CD in some shape or form.  I want to use a mix of Jenkins and CirclCI.  Testing needs to be integrated as well.  I am pushing for TDD on all projects going forward and retroactively for continuing projects.

## Progressive Builds

The initial builds will be done and tested on bare metal and VMs to work through the installation and configuration processes.  Then go through the process of converting to containers for the practice.
