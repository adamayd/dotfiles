read -p "Enter your host name: " hostname
echo "You entered: $hostname"
printf "$hostname\n" > test.txt
printf "127.0.0.1 \t $hostname.localdomain \t $hostname\n" >> test.txt
