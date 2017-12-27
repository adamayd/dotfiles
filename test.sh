clear
lsblk
read -p "Enter the root partition (eg. sda1): " rootpart 
rootpart="/dev/$rootpart"
PUUID="$(blkid -s PARTUUID -o value $rootpart)"
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PUUID rw\n" > test.txt 
