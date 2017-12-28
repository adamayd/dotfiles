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
read -p "Enter the installation target disk: " INSTDISK
INSTDISK="/dev/$INSTDISK"
echo "Install to $INSTDISK"

# Partition Hard Drive
clear
echo "The following will erase your HDD/SSD and create: \n500Mb EFI Boot Partition\n8Gb Linux Swap Partition\nRemaining drive size Linux Root Partition"
echo "THIS WILL ERASE EVERYTHING ON YOUR HDD/SDD"
read -p "Are you sure you want to continue [y/N]" HDWIPE
if [[ $HDWIPE =~ ^[yY]$ ]]; then
    sgdisk --zap-all
    sgdisk --clear --mbrtogpt
    sgdisk --new 1:2048:413695 --change-name 1:"EFI Boot Partition" --typecode 1:EF00 $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create EFI Boot Partition' >&2
        exit 1
    }
    EFIPART="${INSTDISK}1"
    sgdisk --new 2:413695:2000000 --change-name 2:"Linux Swap" --typecode 2:8200 $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create Linux Swap' >&2
        exit 1
    }
    SWAPPART="${INSTDISK}2"
    sgdisk --new 3:2000000:0 --change-name 3:"Linux Root" --typecode 3:8300 $INSTDISK || {
        printf '%s\n' 'install.sh: Could not create Linux Root' >&2
        exit 1
    }
    ROOTPART="${INSTDISK}3"
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



# Hostname & Repositories
read -p "Enter your host name: " HOSTNAME
printf "$HOSTNAME\n" > /etc/hostname
printf "127.0.0.1 \t $HOSTNAME.localdomain \t $HOSTNAME\n" >> /etc/hosts
#####TODO: sed mirrorlist to remove comment before US mirrors 
printf "# AUR Repository\n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch\n" >> /etc/pacman.conf

# Users Section
passwd
read -p "Enter your administrator username: " USERNAME
useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
passwd $USERNAME
#####TODO visudo

# Boot Loader Section 
mount -t efivarfs efivarfs /sys/firmware/efi/efivarfs
bootctl install
pacman -S intel-ucode
PUUID="$(blkid -s PARTUUID -o value $ROOTPART)"
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PUUID rw\n" > /boot/loader/entries/arch.conf

exit 0
