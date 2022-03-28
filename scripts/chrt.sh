#! /bin/bash

# Locale & Time
sed -i '/en_US\.UTF/s/^#//g' /etc/locale.gen
locale-gen
printf '%s\n' 'LANG=en_US.UTF-8' > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
# if dual booting with Windows add a DWORD with a value of 1 to the registry at
# HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\RealTimeIsUniversal
hwclock --systohc --utc

# Hostname & Repositories
read -p 'Enter your host name: ' HOSTNAME
printf '%s\n' "$HOSTNAME" > /etc/hostname
printf '%s\t%s\t%s\n' '127.0.0.1' "$HOSTNAME.localdomain" "$HOSTNAME" >> /etc/hosts
sed -i '/\[community-testing\]/s/^#//g' /etc/pacman.conf
sed -i '/\[community-testing\]/!b;n;cInclude\ =\ \/etc\/pacman\.d\/mirrorlist' /etc/pacman.conf
sed -i '/\[multilib\]/s/^#//g' /etc/pacman.conf
sed -i '/\[multilib\]/!b;n;cInclude\ =\ \/etc\/pacman\.d\/mirrorlist' /etc/pacman.conf
printf '\n%s\n%s\n%s\n%s\n' '# AUR Repository' '[archlinuxfr]' 'SigLevel = Never' 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
pacman -Syu

# Users Section
passwd
read -p 'Enter your username: ' USERNAME
useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
passwd $USERNAME
#####TODO: further testing needed for visudo script
# ./vsdo.sh
export EDITOR=vi
clear
read -p 'Press Enter to edit the sudoers file with vi'
visudo

# Boot Loader Section 
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
bootctl install
pacman -S intel-ucode
PUUID="$(blkid -s PARTUUID -o value /dev/sda2)"
printf '%s\n%s\n%s\n%s\n%s\n' 'title Arch Linux' 'linux /vmlinuz-linux' 'initrd /intel-ucode.img' 'initrd /initramfs-linux.img' "options root=PARTUUID=$PUUID rw" > /boot/loader/entries/arch.conf

# Prepare for reboot
pacman -S --noconfirm networkmanager cronie intel-firmware
curl --remote-name https://raw.githubusercontent.com/adamayd/dotfiles/master/software.sh
chown adam:users software.sh
read -p 'Press Enter to continue' 
chmod 755 software.sh
cp software.sh /home/adam/
printf '%s\n' '@reboot ~/software.sh' >> tempfile
crontab -u adam tempfile
rm tempfile
# systemctl disable dhcpcd@wlp4s0.service
# systemctl disable netctl-auto@wlp4s0.service
systemctl enable NetworkManager.service

exit 0
