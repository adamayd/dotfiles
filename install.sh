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

# Hostname & Repositories
read -p "Enter your host name: " hostname
printf "$hostname\n" > test.txt
printf "127.0.0.1 \t $hostname.localdomain \t $hostname\n" >> test.txt
# sed mirrorlist to remove comment before US mirrors 
printf "# AUR Repository\n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch\n" >> /etc/pacman.conf

# Users Section
passwd
echo "Enter a username:"
read username
useradd -m -g users -G wheel,storage,power -s /bin/bash $username
passwd $username
visudo

# EFI & Micro Code Section 
mount -t efivarfs efivarfs /sys/firmware/efi/efivarfs
bootctl install
pacman -S intel-ucode
output=$(blkid -s PARTUUID -o value /dev/sda5)
echo 'title Arch Linux' > arch.conf
echo 'linux /vmlinuz-linux' >> arch.conf
echo 'initrd /intel-ucode.img' >>arch.conf
echo 'initrd /initramfs-linux.img' >> arch.conf
echo "options root=PARTUUID=$output rw" >> arch.conf

exit 0
