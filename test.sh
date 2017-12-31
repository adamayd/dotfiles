clear
echo "THIS WILL WIPE YOUR HDD"
read -p "Are you sure you want to continue [y/N]" hdwipe
if [[ $hdwipe =~ ^[yY]$ ]]; then
    echo "Do Bad Things to Your Hard Drive"
else
    echo "No changes were made" 
fi

