#!/bin/bash

# Grab github username
read -p "Enter your github user name: " $GHUSER

# Create repo directory
mkdir -p ~/source/projects
cd ~/source/projects

# Get repo names from Github
curl -k --request GET https://api.github.com/users/$GHUSER/repos\?per_page\=100 > curlrepos.txt

# Clean repo names
sed -n '/ssh_url/{p;}' curlrepos.txt > curlrepos2.txt
sed 's/^\ \ \ \ "ssh_url":\ "//' curlrepos2.txt > curlrepos.txt
sed 's/",//' curlrepos.txt > curlrepos2.txt

# Git clone each repo
while IFS='' read -r REPO || [[ -n "$line" ]]; do
  echo "CLONING $REPO"
  git clone $REPO
done < curlrepos2.txt

# Clean up files
rm curlrepos*.txt

