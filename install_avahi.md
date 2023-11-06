# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

This instruction set will enable Avahi on your host machine to allow for hostname resolution from DNS

-----
# Instructions
* Install Avahi for hostname resolution
```
sudo apt-get install avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan
```
-----
# Conclusion
Avahi is now enabled on your host machine and hostnames on the network will now be resolved from DNS
