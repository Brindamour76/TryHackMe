#! /bin/bash

# What is the IP Address to attack:

echo "What IP? "

read IP


#Run Rustscan to scan for open ports

rustscan -a $IP | tee ./Results/01-rust-initial.log


# What ports do you want to run nmap on

echo "What ports (e.g. 21,22,80,3389)? "

read ports


#Run nmap on open ports

nmap -sV -sC -Pn -A -p $ports $IP -oN ./Results/02-nmap-initial.log


# Run feroxbuster to enum the web server

feroxbuster -u http://$IP/ -x php,pdf,txt,epub,html,cgi,css -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -e -o ./Results/03-ferox-initial.log -t 200


# 


