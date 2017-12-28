# Enable WiFi
wifi-menu

# Set Time and Date
timedatectl set-ntp true

# Determine EFI status
if efivar -l; then
     echo "You have UEFI enabled"
     :
else
    printf '%s\n' 'install.sh: UEFI Not Enabled. Please enable and restart!' >&2
    exit 1
fi

# Determine Installation Target
clear
lsblk
read -p "Enter the installation target disk: " instdisk
instdisk="/dev/$instdisk"
echo "Install to $instdisk"

# Partition Hard Drive
clear
echo "THIS WILL WIPE YOUR HDD"
read -p "Are you sure you want to continue [y/N]" hdwipe
if [[ $hdwipe =~ ^[yY]$ ]]; then
    sgdisk --zap-all
    sgdisk --clear --mbrtogpt
    sgdisk --new 1:2048:413695 --change-name 1:"EFI Boot Partition" --typecode 1:EF00 $instdisk
    sgdisk --new 2:413695:2000000 --change-name 2:"Linux Swap" --typecode 2:8200 $instdisk
    sgdisk --new 3:2000000:0 --change-name 3:"Linux Root" --typecode 3:8300 $instdisk
else
    echo "No changes were made" && exit 1
fi

# Hostname & Repositories
read -p "Enter your host name: " hostname
printf "$hostname\n" > test.txt
printf "127.0.0.1 \t $hostname.localdomain \t $hostname\n" >> test.txt
#####TODO: sed mirrorlist to remove comment before US mirrors 
printf "# AUR Repository\n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch\n" >> /etc/pacman.conf

# Users Section
passwd
read "Enter your administrator username: " username
useradd -m -g users -G wheel,storage,power -s /bin/bash $username
passwd $username
#####TODO visudo

# Boot Loader Section 
mount -t efivarfs efivarfs /sys/firmware/efi/efivarfs
bootctl install
pacman -S intel-ucode
clear
lsblk
read -p "Enter the root partition (eg. sda1): " rootpart 
rootpart="/dev/$rootpart"
PUUID="$(blkid -s PARTUUID -o value $rootpart)"
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PUUID rw\n" > test.txt 

exit 0
