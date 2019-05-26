This readme will guide you trough the steps of running metasploit on windows without admin privileges. (i.e. portable application style)
It also provides an example of running X(GUI) applications from within a docker container.
As a precaution if you worry about triggering AV such as windows defender in the host, run this from a portable drive, and not directly from your C-drive.

INSTALLATION

run alpine.bat
--login to boot-image--
log in with user:root
--install alpine to disk--
alpine:~# setup-alpine
[]=leave default
keyboard	us
variant		us-euro
hostname	alpine
eth		[eth0]
ip		[dhcp]
manual		[no]
root password	****
timezone	[UTC]
proxy		[none]
mirror		[f] (or 30 for NL;neostrada)
SSH		[openssh]
disk		sda
how?		sys
erase		y
--installation done--
alpine:~# reboot

--login to disk image--
 log in with user:root
password:	****

--add user--
alpine:~# adduser user
password:	****
alpine:~# exit

From now on, you can start alpine_headless.bat, or modify alpine.bat to have it start in headless mode;
 set "GRAPHIC="			-> REM set "GRAPHIC="
 REM set "GRAPHIC=-nographic"	-> set "GRAPHIC=-nographic"

--login with ssh--
 log in with ssh over port 10022
 log in with user:root
password:	****

--install packages to alpine--
you need to do this from home, or set up a proxy with authentication when at a corporate network (cntlm can be used for this)

--installing sudo--
alpine:~$ su root
password:	****
alpine:~# apk add sudo
alpine:~# visudo 
 add the following line
    user ALL=(ALL) ALL
alpine:~# exit

--installing docker--
alpine:~$ sudo vi /etc/apk.repositories
 uncomment 2nd line, e.g. 
    http://mirror.neostrada.nl/alpine/v3.9/community
alpine:~$ sudo apk add docker

--install metasploit--
alpine:~$ sudo docker run --rm -it -p 443:443 -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data remnux/metasploit
 it will take a looooong time, and additional ports need to be added to the qemu config (see batch file) to allow reverse connections, e.g. for reverse shell etc.
 useful link: https://zeltser.com/metasploit-framework-docker-container/

--install firefox (using x-window on windows host)--
windows:
start xming in windows host(subfolder: Xming\XLaunch.exe): multiple windows(default),  start no client(default), next, Finish 
ipconfig -> note down HOST_IP of windows

alpine:
alpine:~$ mkdir ff
alpine:~$ cd ff
alpine:~$ vi Dockerfile
FROM ubuntu:14.04
RUN apt-get update && apt-get install -y firefox
CMD /usr/bin/firefox
:wq
alpine:~$ sudo docker build -t firefox .
alpine:~$ docker run -ti --rm -e DISPLAY=HOST_IP:0.0 firefox

 useful link: https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde
(you can also run a mitm proxy like burp-suite by deploying it in the same container. However, its quite slow)

