# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

> [!NOTE]
> Skip any steps that have already been completed.

This instruction set will set up a NTP server inside a Docker container that can be used on your local network for time synchronization.

-----
# Instructions
## Prerequisite Setup
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/readme.md).
* [Enable Ubuntu firewall](/enable_firewall/readme.md).
* [Install SSH Server](/install_ssh-srvr/readme.md).
* Connect via PuTTY.
* Set up Ubuntu firewall for BIND9 DNS Server:
```
sudo ufw allow 123
```
* [Install Nano and update packages](/install_nano/readme.md).
* [Install Docker](/install_docker/readme.md).
* Create directory for NTP Server:
```
sudo mkdir -p /opt/ntpserver
```
* Return to root:
```
cd
```
## Install NTP Server
* Enter NTP Server directory:
```
cd /opt/ntpserver
```
* Download `docker-compose.yml` file from Github to set up the NTP Server Docker container:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_ntp/docker-compose.yml
```
* Edit `docker-compose.yml` file:
```
sudo nano /opt/ntpserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone you want the NTP Server to run in.
* Replace `<server-address>` with the address(s) of the time server(s) you want to use in a comma delimited list without spaces.
* Replace `<true-false>` with `true` if all the servers you have entered under `NTP_SERVER` support NTS (Network Time Security). Replace `<true-false>` with `false` if a the server you have entered under `NTP_SERVER` does not support NTS.
* Save file and exit text editor.
* Test NTP Server Docker container:
```
sudo docker-compose -f /opt/ntpserver/docker-compose.yml config
```
* Start NTP Server Docker container:
```
cd /opt/ntpserver
sudo docker-compose up -d ntp
```
* Return to root:
```
cd
```
## Installation Status Check
* Check that TrueCommand Docker container is running:
```
sudo docker ps -a
```
* Install `ntpdate`:
```
sudo apt install ntpdate
```
* Use the following command to test the NTP server, replacing `<NTP-server-IP>` with the host machine:
```
ntpdate -q <NTP-server-IP>
```
If the NTP server is running correctly and the clock is synchronized, you should receive an output similar to the following:
```
server 12.34.56.78, stratum 4, offset 0.000642, delay 0.02805
14 Mar 19:21:29 ntpdate[26834]: adjust time server 12.34.56.78 offset 0.000642 sec
```
If the NTP server is running correctly and the clock is not yet synchronized, you should receive an output similar to the following and you should wait a bit longer for the clock to synchronize before testing again:
```
server 12.34.56.78, stratum 16, offset 0.005689, delay 0.02837
11 Dec 09:47:53 ntpdate[26030]: no server suitable for synchronization found
```
* To view details on the NTP status of the container, use the following command:
```
sudo docker exec ntpserver chronyc tracking
```
You should receive an output similar to the following:
```
Reference ID    : D8EF2300 (time1.google.com)
Stratum         : 2
Ref time (UTC)  : Sun Mar 15 04:33:30 2020
System time     : 0.000054161 seconds slow of NTP time
Last offset     : -0.000015060 seconds
RMS offset      : 0.000206534 seconds
Frequency       : 5.626 ppm fast
Residual freq   : -0.001 ppm
Skew            : 0.118 ppm
Root delay      : 0.022015510 seconds
Root dispersion : 0.001476757 seconds
Update interval : 1025.2 seconds
Leap status     : Normal
```
* To view a peer list to verify the state of each NTP source configured on your server, use the following command:
```
sudo docker exec ntpserver chronyc sources
```
You should receive an output similar to the following:
```
210 Number of sources = 2
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ time.cloudflare.com           3  10   377   404   -623us[ -623us] +/-   24ms
^* time1.google.com              1  10   377  1023   +259us[ +244us] +/-   11ms
```
* To view statistics about the collected measurements of each NTP source configured on your server, use the following command:
```
sudo docker exec ntpserver chronyc sourcestats
```
You should receive an output similar to the following:
```
210 Number of sources = 2
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
time.cloudflare.com        35  18  139m     +0.014      0.141   -662us   530us
time1.google.com           33  13  128m     -0.007      0.138   +318us   460us
```
-----
# Conclusion
NTP Server is now set up in a Docker container on your host machine.

You can now configure your local network clients to point to the host machine IP address for their NTP Server entry.

You can also set the host machine IP address to be distributed as the NTP Server address via DHCP.
