#! /bin/bash

# Locale & Time
sed -i '/en_US\.UTF/s/^#//g' /etc/locale.gen
locale-gen
printf '%s\n' 'LANG=en_US.UTF-8' > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

# Hostname & Repositories
read -p 'Enter your host name: ' HOSTNAME
printf '%s\n' "$HOSTNAME" > /etc/hostname
printf '%s\t%s\t%s\n' '127.0.0.1' "$HOSTNAME.localdomain" "$HOSTNAME" >> /etc/hosts
sed -i '/\[multilib\]/s/^#//g' /etc/pacman.conf
sed -i '/\[multilib\]/!b;n;cInclude\ =\ \/etc\/pacman\.d\/mirrorlist' /etc/pacman.conf
printf '\n%s\n%s\n%s\n%s\n' '# AUR Repository' '[archlinuxfr]' 'SigLevel = Never' 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
pacman -Syu

# Users Section
passwd
read -p 'Enter your username: ' USERNAME
useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
passwd $USERNAME
./vsdo.sh
export EDITOR=vi

# Boot Loader Section 
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
bootctl install
pacman -S intel-ucode
PUUID="$(blkid -s PARTUUID -o value $ROOTPART)"
printf '%s\n%s\n%s\n%s\n%s\n' 'title Arch Linux' 'linux /vmlinuz-linux' 'initrd /intel-ucode.img' 'initrd /initramfs-linux.img' "options root=PARTUUID=$PUUID rw" > /boot/loader/entries/arch.conf

exit 0