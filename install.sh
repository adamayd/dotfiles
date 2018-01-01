#! /bin/bash

# Set System Time & Date
timedatectl set-ntp true

# Determine EFI status
if ! efivar -l; then
    printf '%s\n' 'install.sh: UEFI Not Enabled. Please enable and restart!' >&2
    exit 1
fi

# Determine Installation Target
clear
lsblk
read -p 'Enter the installation target disk (eg. sda): ' INSTDISK
INSTDISK="/dev/${INSTDISK}"

# Partition Hard Drive
clear
printf '%s\n' "Install to $INSTDISK"
printf '%s\n%s\n%s\n%s\n' 'The following will erase your HDD/SSD and create:' '500Mb EFI Boot Partition' '8Gb Linux Swap Partition' 'Remaining drive size Linux Root Partition'
printf '%s\n' 'THIS WILL ERASE EVERYTHING ON YOUR HDD/SDD'
read -p 'Are you sure you want to continue [y/N] ' HDWIPE
if [[ $HDWIPE =~ ^[yY]$ ]]; then
    dd bs=446 count=1 if=/dev/zero of=$INSTDISK
    sgdisk -Z -o $INSTDISK
    sgdisk -n 1:0:+500M -t 1:ef00 -c 1:"EFI Boot Partition" $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create EFI Boot Partition' >&2
        exit 1
    }
    EFIPART="${INSTDISK}1"
    sgdisk -n 3:-8G:0 -t 3:8300 -c 3:"Linux Swap" $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create Linux Swap Partition' >&2
        exit 1
    }
    SWAPPART="${INSTDISK}3"
    sgdisk -n 2:0:0 -t 2:8300 -c 2:"Arch Linux Partition" $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create Arch Linux Partition' >&2
        exit 1
    }
    ROOTPART="${INSTDISK}2"
else
    printf '%s\n' 'install.sh: User Cancelled! No changes to drive were made.' && exit 0
fi

# Format the new partitions and turn on the swap
mkfs.fat -F32 $EFIPART
mkfs.ext4 $ROOTPART
mkswap $SWAPPART
swapon $SWAPPART

# Mount the partitions 
mount $ROOTPART /mnt
mkdir /mnt/boot
mount $EFIPART /mnt/boot

# Establish the Mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -n '/United\ States/{n;p;}' /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist.us
rankmirrors -n 6 /etc/pacman.d/mirrorlist.us > /etc/pacman.d/mirrorlist

# Create & Enter Chroot Environment
pacstrap -i /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i 's/relatime,data/relatime,discard,data/g' /mnt/etc/fstab
curl --remote-name https://raw.githubusercontent.com/adamayd/T460dotfiles/master/vsdo.sh
chmod 755 vsdo.sh
cp vsdo.sh /mnt
curl --remote-name https://raw.githubusercontent.com/adamayd/T460dotfiles/master/chrt.sh
chmod 755 chrt.sh
cp chrt.sh /mnt

read -p 'Press Enter to continue to chroot environment'
arch-chroot /mnt ./chrt.sh

printf '%s\n' 'You have exited the chroot environment'

exit 0