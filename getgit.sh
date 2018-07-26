#!/bin/bash

# Create repo directory
mkdir -p ~/source/projects
cd ~/source/projects

# Get repo names from Github
curl -k --request GET https://api.github.com/users/adamayd/repos\?per_page\=100 > curlrepos.txt

# Clean repo names
sed -n '/ssh_url/{p;}' curlrepos.txt > curlrepos2.txt
sed 's/^\ \ \ \ "ssh_url":\ "//' curlrepos2.txt > curlrepos.txt
sed 's/",//' curlrepos.txt > curlrepos2.txt

read -p "Waiting"

# Git clone each repo
while IFS='' read -r REPO || [[ -n "$line" ]]; do
  echo "CLONING $REPO"
  git clone $REPO
done < curlrepos2.txt

# Clean up files
rm curlrepos*.txt

