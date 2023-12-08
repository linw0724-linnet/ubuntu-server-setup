# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

> [!NOTE]
> Skip any steps that have already been completed.

This instruction set will set up a BIND9 DNS server inside a Docker container that can be used on your local network.

This DNS server will first resolve DNS requests from its local cache and forward DNS request for unknown addresses to an authoritative DNS server.

After forwarding a DNS request to an authoritative DNS server, the server will cache the results locally to cut down on bandwidth usage and allow for faster DNS response times on the local network.

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/readme.md).
* [Enable Ubuntu firewall](/enable_firewall/readme.md).
* [Install SSH Server](/install_ssh-srvr/readme.md).
* Connect via PuTTY.
* Set up Ubuntu firewall for BIND9 DNS Server:
```
sudo ufw allow 53
sudo ufw allow 53/udp
```
* [Install Nano and update packages](/install_nano/readme.md).
* [Install Docker](/install_docker/readme.md).
* Create directory for BIND9 DNS Server:
```
sudo mkdir -p /opt/dnsserver/config
sudo mkdir -p /etc/bind
```
* Edit systemd-resolved configuration file to ensure BIND9 can properly listen:
```
sudo nano /etc/systemd/resolved.conf
```
* Uncomment the line `DNSStubListener=yes` and set it to `DNSStubListener=no`.
* Save file and exit text editor.
* Restart `systemd-resolved` service:
```
sudo systemctl restart systemd-resolved
```
* Enter BIND9 DNS Server directory:
```
cd /opt/dnsserver
```
* Download `docker-compose.yml` file from Github to set up the BIND9 Docker container:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_bind9/docker-compose.yml
```
* Edit `docker-compose.yml` file:
```
sudo nano /opt/dnsserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone name for your host machine.
* Save file and exit text editor.
* Test BIND9 Docker container:
```
sudo docker-compose -f /opt/dnsserver/docker-compose.yml config
```
* Return to root:
```
cd
```
* Enter BIND9 DNS Server `config` directory:
```
cd /opt/dnsserver/config
```
* Download `named.conf` file for BIND9 from Github:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_bind9/named.conf
```
* Edit `named.conf` file:
```
sudo nano /opt/dnsserver/config/named.conf
```
* Replace `<local-net/subnet>` with the IP range of your local area network and your subnet.
* Replace `<domain-name>` with the domain name of your zone.
* Save file and exit text editor.
* Return to root:
```
cd
```
* Enter BIND directory:
```
cd /etc/bind
```
* Download `domain-name.zone` file for BIND9 from Github:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_bind9/domain-name.zone
```
* Edit `domain-name.zone` file:
```
sudo nano /etc/bind/domain-name.zone
```
* Replace `<domain-name>` with the domain name of your zone.
* Replace `<host-machine-IP>` with the IPV4 address of your machine that is hosting the BIND9 DNS server.
* Save file and exit text editor.
* Rename zone file, replacing the `<domain-name>` with the domain name of your zone:
```
sudo mv /etc/bind/domain-name.zone /etc/bind/<domain-name>.zone
```
* Return to root:
```
cd
```
* Start BIND9 Docker container:
```
cd /opt/dnsserver
sudo docker-compose up -d
```
* Return to root:
```
cd
```
* Testing DNS server domain mapping function:
> [!IMPORTANT]
> Replace `<domain-name>` with the domain name of your zone and replace `<host-machine-IP>` with the IPV4 address of your machine that is hosting the BIND9 DNS server.
```
nslookup <domain-name> <host-machine-IP>
```
* Testing DNS server forwarding function:
```
nslookup google.com
```
-----
# Conclusion
BIND9 DNS Server is now set up in a Docker container on your host machine.

You can now configure your local network clients to point to the host machine IP address for their DNS Server entry.

You can also set the host machine IP address to be distributed as the DNS Server address via DHCP.
