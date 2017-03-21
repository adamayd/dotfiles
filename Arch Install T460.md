# Arch Linux UEFI Install on Thinkpad T460
This document provides instructions for installing Arch Linux on a Lenovo Thinkpad T460 in UEFI mode as a clean installation with no other operating system.
## Configure the Install Environment
### Enable Wireless Networking
Use Wifi-Menu to enable the wireless networking
```
# wifi-menu
```
### Set the Time
```
# timedatectl set-ntp true
```
## Creating the filesystem
### Partitioning the Hard Drive
In addition to our normal partitions we will be adding a EFI boot partition.  We will only be setting up three (boot, root, swap) partitions.  Regardless of your setup, you will need at least these three.

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
Take care to enter the correct hex codes and put the EFI partition first if you plan to use other non-linux operating systems.
* Select *New* for new partition
* At prompt for first sector enter size: `512Mib`
* EFI Hex Code: `EF00`
* Name: `boot`

Root partition.
* Select *New*
* First sector: `230.5Gib`
* Linux filesystem Hex Code: `8300`
* Name: `root`

Swap partition.
* Select *New*
* First sector: `8Gib`
* Linux swap Hex Code: `8200`
* Name: `swap`

Choose Write and enter `y` to confirm then choose Quit to exit.
### Formatting and Mounting partitions
Format the partitions and make sure to format the EFI partition as FAT32.
```
# mkfs.fat -F32 /dev/sda1
# mkfs.ext4 /dev/sda2
```
Make the swap partition and turn it on.
```
# mkswap /dev/sda3
# swapon /dev/sda3
```
***NOTE: Only use the `mkswap` and `swapon` commands once.  If you reboot you do not need to reuse the commands to enable your swap.  In fact if you do it after you have later generated your fstab, you will change the UUID of your swap and cause your installation to hang during boot as it is trying to mount the swap with a UUID that no longer exists.***

Mount the newly formatted partitions.
```
# mount /dev/sda2 /mnt
```
Make the boot directory and mount the EFI partition.
```
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
```
***NOTE: Make sure that you mount the root partition before making the directory and mounting the boot partition.  If you mount the boot partition first then the root, it will "overwrite" the mounting of the boot partition***
## Installing the Operating System
### Establishing the Mirror List
Keep only the US based mirrors.
```
# cp /etc/pacman.d/mirrorlist /etc/packman.d/mirrorlist.backup
# sed -n '/United\ States/{n;p;}' /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist.us
```
Rank the six fastest mirrors.
```
rankmirrors -n 6 /etc/pacman.d/mirrorlist.us > /etc/pacman.d/mirrorlist
```
### Creating Chroot Environment
To use the Arch User Repository (AUR) we will need to install the `base-devel` in addition to the `base` package.
```
# pacstrap -i /mnt base base-devel
```
Generate the file system table.
```
# genfstab -U -p /mnt >> /mnt/etc/fstab
# vi /mnt/etc/fstab
```
Adjust the options of the `/` line to equal `rw,relatime,discard,data=ordered` with no spaces between options.  Options of the `swap` line should equal `defaults` and `/boot` can stay as generated.

Enter the Chroot environment
```
# arch-chroot /mnt
```
## Configuring the System
### Locale and Time
```
# vi /etc/locale.gen
```
Remove the preceeding `#` comment tag in front of the line `en_US.UTF-8 UTF-8`. Use `/` in vi to search for the line faster.
```
# locale-gen
```
Set the language variable
```
# echo LANG=en_US.UTF-8 > /etc/locale.conf
```
Set the time zone and system clock
```
# ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
# hwclock --systohc --utc
```
### Hostname and Repositories
Create your hostname.
```
# echo YOURHOSTNAME > /etc/hostname
```
Add new hostname entry to hosts.
```
# vi /etc/hosts
127.0.0.1 YOURHOSTNAME.localdomain  YOURHOSTNAME
```
Edit the `pacman.conf` file to enable 32-bit support by uncommenting the lines for multilib.
```
# vi /etc/pacman.conf
[multilib]
Include = /etc/pacman.d/mirrorlist
```
Add Arch User Repository (AUR) to the end of the file.
```
# AUR Repository
[archlinux.fr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```
Run Pacman update to refresh the local databases.
```
# pacman -Syu
```
### Users
Create a root password.
```
passwd
```
Create a system user.
```
useradd -m -g users -G wheel,storage,power -s /bin/bash YOURUSERNAME
passwd YOURUSERNAME
```
Edit the sudoers file to allow the user root privileges.
```
# visudo
%wheel ALL=(ALL) ALL
```
## Final Touches
### EFI Installation
Mount and install the EFI boot system.
```
# mount -t efivarfs efivarfs /sys/firmware/efi/efivars
# bootctl install
```
Determine the PARTUUID of the root partition.
```
#blkid -s PARTUUID -o value /dev/sda2
```
Create the boot loader entry.
```
# vi /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=YOURPARTUUID rw
```
### Intel Microcode
Install Intel Microcode prior to reboot to support the `initrd /intel-ucode.img` line in the boot loader entry.
```
pacman -S intel-ucode
```
