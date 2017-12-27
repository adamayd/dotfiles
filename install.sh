# Determine Installation Target
clear
lsblk
read -p "Enter the installation target disk: " instdisk
instdisk="/dev/$instdisk"
echo "Install to $instdisk"

# Hostname & Repositories
echo "Enter your host name"
read hostname
echo "You entered: $hostname"
echo $hostname > /etc/hostname
echo -e "127.0.0.1 \t $hostname.localdomain \t $hostname" >> /etc/hosts
# sed mirrorlist to remove 
echo '# AUR Repository' >> /etc/pacman.conf
echo '[archlinuxfr]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf

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
