# THM - ContainMe 

## Date Commenced 28MAR2022


---
## IP Address

### Attempt 1
export IP=10.10.63.147

### Attempt 2
export IP=10.10.146.175

### Attempt 3
export IP=10.10.97.253


---
## Initial Enumeration

### Open Ports
Perform Basic **rustscan** scan and then a **nmap** scan to get (edited to allow for **rustscan** lying to me again):

> 22/tcp   open   ssh           syn-ack      OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0) 
>
> 80/tcp   open   http          syn-ack      Apache httpd 2.4.29 ((Ubuntu))
>
> 2222/tcp open   EtherNetIP-1?
>
> 8022/tcp open   ssh           OpenSSH 7.7p1 Ubuntu 4ppa1+obfuscated (Ubuntu Linux; protocol 2.0)

> `rustscan -a $IP | tee ./Results/rustscan01.log`  

[RustscanResults](Results/01-rust-initial.log)

> `nmap -sC -sV -A -vvv $IP -p 22,80,8022,2222,6500,6501 -oN ./02-nmap-initial.log`  

[NMAPResults](Results/02-nmap-initial.log)


### Host OS
Most likely **Ubuntu**.
 

---
## Enumerate the Web Page

### Main Page
**Apache** defualt main page, and nothing in the source code.


### Robots.txt
Nothing there.


### Directories and Files
Run **feroxbuster** and see what is returned:

> `feroxbuster -u http://$IP/ -x php,pdf,txt,epub,html,cgi,css -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -e -o ./Results/feroxbuster01.log -t 200`  

[FeroxResults](Results/feroxbuster01.log)

Whilst it picked up a few files. I think it stopped working part wasy through. will come back to this.


### Nikto
Hmmmm...not really used this much.

> `nikto -h http://$IP`  

[Nikto](Results/06-nikto.txt)

Not much there but does list some files to look at. *index.php* and *info.php*.


### /index.php/
In the source code, it asks *where is the path ?*:

![indexphp](Images/01-indexphp.png)


### Directory Transversal
Using the info in *info.php* can guess at a directory transversal method:

> http://10.10.97.253/index.php?path=/home

![Mike](Images/04-mike.png)

![DirTrans](Images/03-directorytransversal.png)

Which gives the username *mike*.


---
## Metasploit
Oh, I am going to have fun explaining this one.


