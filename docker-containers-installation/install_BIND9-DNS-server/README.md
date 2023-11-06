> [!WARNING]
> This instruction set is still under development and untested, please make any contributions and edits to help finalize this instruction set
# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a BIND9 DNS server inside a Docker container that can be used on your local network

This DNS server will first resolve DNS requests from its local cache and forward DNS request for unknown addresses to an authoritative DNS server

After forwarding a DNS request to an authoritative DNS server, the server will cache the results locally to cut down on bandwidth usage and allow for faster DNS response times on the local network

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](../../fix_network-bootup.md)

* [Enable Ubuntu firewall](../../enable_firewall/README.md)

* [Install SSH Server](../../install_ssh-server.md)

* Connect via PuTTY

* Set up Ubuntu firewall for BIND9 DNS Server
```
sudo ufw allow 53
```
* [Install Nano and update packages](../../install_nano.md)

* [Install Docker](../../install_docker.md)

* Create directory for BIND9 DNS Server
```
sudo mkdir -p /opt/dnsserver/config
sudo mkdir -p /etc/bind
```
* Edit systemd-resolved configuration file to ensure BIND9 can properly listen
```
sudo nano /etc/systemd/resolved.conf
```
* Uncomment the line `DNSStubListener=yes` and set it to `DNSStubListener=no`

* Save file and exit text editor

* Configure BIND9 Docker container
```
sudo nano /opt/dnsserver/docker-compose.yml
```
* Enter configuration for BIND9 Docker container into compose file
```
version: '3'
services:
  bind9:
    container_name: dnsserver
    image: ubuntu/bind9
    restart: unless-stopped
    environment:
      - BIND9_USER=root
      - TZ=America/Los_Angeles
    volumes:
      - ./config:/etc/bind
      - ./cache:/var/cache/bind
      - ./records:/var/lib/bind
    ports:
      - '53:53'
      - '53:53/udp'
```
* Save file and exit text editor

* Test BIND9 Docker container
```
sudo docker-compose -f /opt/dnsserver/docker-compose.yml config
```
* Create main configuration file for BIND9
```
sudo nano /opt/dnsserver/named.conf
```
* Enter configuration for BIND9 DNS Server into configuration file
> [!NOTE]
> Replace `<domain-name>` with the domain name of your zone
```
// ACL for DNS server
acl internal {
  localhost;
  localnets;
  10.0.0.0/16;
};
options {
  // Location of DNS cache that DNS server will use to resolve queries
  directory "/var/cache/bind";
  // Allow recursive queries
  recursion yes;
  // Allow DNS server to listen for queries on any interface
  listen-on { any; };
  // List of nameservers where requests will be forwarded for resolution
  forwarders {
    // Google
    8.8.8.8;
    8.8.4.4;
    // Cloudflare
    1.1.1.1;
    1.0.0.1;
    // OpenDNS
    208.67.222.222;
    208.67.220.220;
  };
  // Specifies ACL of hosts that are allowed to query DNS server
  allow-query { internal; };
};
// Specifies zone for which this DNS server is authoritative
zone "lin-net.net" IN {
  // Designates this server as authoritative for this zone
  type master;
  // Location of zone configuration data
  file "/etc/bind/<domain-name>.zone";
};
```
* Save file and exit text editor

* Create zone file for BIND9

> [!NOTE]
> Replace `<domain-name>` with the domain name of your zone
```
sudo nano /etc/bind/<domain-name>.zone
```
* Enter configuration for zone into zone file
> [!NOTE]
> Replace `<domain-name>` with the domain name of your zone

> [!NOTE]
> Replace `<host-machine-IP>` with the IPV4 address of your machine that is hosting the BIND9 DNS server
```
// DNS resolver cache record time
$TTL 15m
// Specifies end of unterminated hostname references
$ORIGIN <domain-name>.
@      IN  SOA <domain-name>. ns.<domain-name>. (
             // Serial number for zone file
             1  ; serial
             // Time for secondary nameservers to query primary nameserver
             1h     ; refresh
             // Time before secondary nameservers attempt to query primary nameserver
             1m     ; retry
             // Time before secondary nameservers stops offering DNS resolution
             5m      ; expire
             // Time for negative response to be cached
             1m )     ; minimum TTL
;
// NS records
@ IN NS dns.<domain-name>.
dns IN A <host-machine-IP>
lin-net.net. IN A <host-machine-IP>
```
* Save file and exit text editor

* Start BIND9 Docker container
```
cd /opt/dnsserver
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Testing DNS server domain mapping function

> [!NOTE]
> Replace `<domain-name>` with the domain name of your zone and replace `<host-machine-IP>` with the IPV4 address of your machine that is hosting the BIND9 DNS server
```
nslookup <domain-name> <host-machine-IP>
```
* Testing DNS server forwarding function
```
nslookup google.com
```
-----
# Conclusion
BIND9 DNS Server is now set up in a Docker container on your host machine

You can now configure your local network clients to point to the host machine IP address for their DNS Server entry

You can also set the host machine IP address to be distributed as the DNS Server address via DHCP
