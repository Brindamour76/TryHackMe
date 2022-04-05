# THM - RazorBlack

## Date Commenced 04APR2022


---
## IP Address
### Attempt 1
export IP=10.10.126.218


---
## Open Ports

> 88/tcp    open  kerberos-sec   syn-ack
> 135/tcp   open  msrpc          syn-ack
> 389/tcp   open  ldap           syn-ack
> 593/tcp   open  http-rpc-epmap syn-ack
> 636/tcp   open  ldapssl        syn-ack
> 3389/tcp  open  ms-wbt-server  syn-ack
> 5985/tcp  open  wsman          syn-ack
> 47001/tcp open  winrm          syn-ack
> 49664/tcp open  unknown        syn-ack
> 49665/tcp open  unknown        syn-ack
> 49666/tcp open  unknown        syn-ack
> 49669/tcp open  unknown        syn-ack
> 49672/tcp open  unknown        syn-ack
> 49673/tcp open  unknown        syn-ack
> 49674/tcp open  unknown        syn-ack
> 49678/tcp open  unknown        syn-ack
> 49693/tcp open  unknown        syn-ack
> 49705/tcp open  unknown        syn-ack

> `rustscan -a  $IP | tee ./Results/01-rust-initial.log`

[RustScan Results File](Results/01-rust-initial.log)

> `nmap -sV -sC -Pn -A -p $IP  -oN ./Results/02-nmap-initial.log`

[Nmap Results File](Results/02-nmap-initial.log)


---
## Web Page

### Main Page


### Directories
**Feroxbuster**:

> feroxbuster -u http:/// -x php,pdf,txt,epub,html,cgi,css -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -e -o ./Results/03-ferox-initial.log

[Feroxbuster Results File](Results/03-ferox-initial.log)

### Vhosts
**Gobuster**:

> sudo gobuster vhost -u http://  --wordlist=/usr/share/wordlists/SecLists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 250 2> /dev/null -o ./Results/04-gobuster-vhosts.log

[GoBuster Results File](Results/04-gobuster-vhosts.log)



