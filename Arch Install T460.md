# Arch Linux UEFI Install on Thinkpad T460
This document provides instructions for installing Arch Linux on a Lenovo Thinkpad T460 in UEFI mode as a clean installation with no other operating system.  I chose UEFI as I may dual boot Windows 10 later, but those procedures are not described here.
## Enable Wireless Networking
During the installation use Wifi-Menu to enable the wireless networking so the latest packages will be installed.
```
# wifi-menu
```
## Creating the filesystem
### Partitioning the Hard Drive
In addition to our normal partitions we will be adding a EFI boot partition.  I choose to keep everything on one partition so I will only be setting up three (boot, root, swap) partitions.  Regardless of your setup, you will need at least these three.

First verify your system is running in EFI mode.
```
# efivar -l
```
You should see variables on screen.  If not check your BIOS settings are not set to legacy.  Next check the device you will use for installation.  My T460 only has a single SSD drive so I will be using *sda* for my installation.
```
# lsblk
```
Use *gdisk* to "zap" the hard drive clean.  **THIS WILL ERASE YOUR HARD DRIVE**
```
# gdisk /dev/sda
```
Once in *gdisk* hit `x` to enter expert mode, then `z` to zap GPT table then `y` to confirm and `y` to confirm again and exit. Now use *cgdisk* to set up the new partitions.
```
# cgdisk /dev/sda
```
Your partitions will vary with by your disks and size.  Current theory provides 512Mb to 1Gb for the EFI partition.  Also although swap space is much more debated these days, I use the same amount as RAM.  Make sure to enter the correct hex code when making the partitions.  I put the EFI boot partition first as to conform with the needs of other operating systems.
* Select *New* for new partition
* At prompt for first sector enter size: `512Mib`
* EFI Hex Code: `EF00`
* Name: `boot`

Now for the root partition.
* Select *New*
* First sector: `230.5Gib`
* Linux filesystem Hex Code: `8300`
* Name: `root`

And finally the swap partition.
* Select *New*
* First sector: `8Gib`
* Linux swap Hex Code: `8200`
* Name: `swap`

Finally choose Write and enter `y` to confirm then choose Quit to exit.
### Formatting and Mounting partitions
First we will format the partitions then mount them.  If you set up your partitions differently please assure to change the commands below to fit your scheme. Lets starts with formatting the EFI partition ensuring to use FAT32.
```
# mkfs.fat -F32 /dev/sda1
```
Now for the root partition
```
# mkfs.ext4 /dev/sda2
```
And finally make the swap partition and turn it on.
```
# mkswap /dev/sda3
# swapon /dev/sda3
```
***NOTE: Only use the `mkswap` and `swapon` commands once.  If you reboot you do not need to reuse the commands to enable your swap.  In fact if you do it after you have later generated your fstab, you will change the UUID of your swap and cause your installation to hang during boot as it is trying to mount the swap with a UUID that no longer exists.***

Now mount the newly formatted partitions.
```
# mount /dev/sda2 /mnt
```
For the EFI partition we need to make the boot directory now that the root partition has been mounted.
```
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
```
***NOTE: Make sure that you mount the root partition before making the directory and mounting the boot partition.  If you mount the boot partition first then the root, it will "overwrite" the mounting of the boot partition***
## Installing the Operating System
### Establishing the Mirror List
Let's start by keeping only the US based mirrors from the mirror list.
```
# cp /etc/pacman.d/mirrorlist /etc/packman.d/mirrorlist.backup
# sed -n '/United\ States/{n;p;}' /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist.us
```
Now using the `rankmirrors` command we can find out the fastest mirrors.  Usually six will suffice but you can do all of them if you chose and if you have the time.
```
rankmirrors -n 6 /etc/pacman.d/mirrorlist.us > /etc/pacman.d/mirrorlist
```
### Creating Chroot Environment
To use the Arch User Repository (AUR) we will need to install the `base-devel` in addition to the `base` package.
```
# pacstrap -i /mnt base base-devel
```
Next we will create the file system table (fstab) file with the currently mounted partitions and edit the settings in the file.
```
# genfstab -U -p /mnt >> /mnt/etc/fstab
# vi /mnt/etc/fstab
```
Inside the file navigate to the options column of the swap line and enter `defaults,discard`.  Save and exit.  The time has come to enter the Chroot environment.
```
# arch-chroot /mnt
```
## Configuring the System
### Locale and Time
```
# vi /etc/locale.gen
```
```
# locale-gen
```
```
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# export LANG=en_US.UTF-8
```
```
# ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
# hwclock --systohc --utc
```
### Hostname and Repositories
```
# echo YOURHOSTNAME > /etc/hostname
```
```
# vi /etc/pacman.conf
```
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```
```
# AUR Repository
[archlinux.fr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```
```
# pacman -Syu
```
### Users
```
passwd
```
```
useradd -m -g users -G wheel,storage,power -s /bin/bash adam
passwd adam
```
```
# visudo
%wheel ALL=(ALL) ALL
```
## Final Touches
### EFI Installation
```
# mount -t efivarfs efivarfs /sys/firmware/efi/efivars
# bootctl install
```
```
# vi /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=YOURPARTUUID rw
```
### Intel Microcode
```
pacman -S intel-ucode
```
