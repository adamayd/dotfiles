#
#
# Script to update with pacman
#
clear
echo "Hello $USER"
echo -e "Today is \c ";date
echo -e "Number of user login : \c" ; who | wc -l
echo "Calendar"
cal
output=$(blkid -s PARTUUID -o value /dev/sda5)
echo "title Arch Linux" > arch.conf
echo "linux /vmlinuz-linux" >> arch.conf
echo "initrd /intel-ucode.img" >>arch.conf
echo "initrd /initramfs-linux.img" >> arch.conf
echo "options root=PARTUUID=$output rw" >> arch.conf
exit 0
