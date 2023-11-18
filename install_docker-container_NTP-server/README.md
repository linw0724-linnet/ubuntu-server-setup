# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a NTP server inside a Docker container that can be used on your local network for time synchronization

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for BIND9 DNS Server
```
sudo ufw allow 123
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directory for NTP Server
```
sudo mkdir -p /opt/ntpserver
```
* Return to root
```
cd
```
* Enter NTP Server directory
```
cd /opt/ntpserver
```
* Download `docker-compose.yml` file from Github to set up the NTP Server Docker container
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/install_NTP-server/install_docker-container_NTP-server/docker-compose.yml
```
* Edit `docker-compose.yml` file
```
sudo nano /opt/ntpserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone you want the NTP Server to run in

* Replace `<server-address>` with the address(s) of the time server(s) you want to use in a comma delimited list without spaces

* Replace `<true-false>` with `true` if all the servers you have entered under `NTP_SERVER` support NTS (Network Time Security). Replace `<true-false>` with `false` if a the server you have entered under `NTP_SERVER` does not support NTS

* Save file and exit text editor

* Test NTP Server Docker container
```
sudo docker-compose -f /opt/ntpserver/docker-compose.yml config
```
* Start BIND9 Docker container
```
cd /opt/ntpserver
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Testing NTP server
```
apt install sntp
docker exec ntpserver chronyc tracking
docker exec ntpserver chronyc sources
docker exec ntpserver chronyc sourcestats
```
-----
# Conclusion
NTP Server is now set up in a Docker container on your host machine

You can now configure your local network clients to point to the host machine IP address for their NTP Server entry

You can also set the host machine IP address to be distributed as the NTP Server address via DHCP
