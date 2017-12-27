clear
lsblk
read -p "Enter the installation target disk: " instdisk
instdisk="/dev/$instdisk"
echo "Install to $instdisk"
