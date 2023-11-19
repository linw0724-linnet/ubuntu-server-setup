# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

This instruction set will enable SSH access on your host machine and allow for remote access via a SSH client like PuTTY.

-----
# Instructions
* Install SSH Server:
```
sudo apt update
sudo apt upgrade
sudo apt install openssh-server
```
* Set up Ubuntu firewall for SSH server:
```
sudo ufw allow ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```
* Enter SSH server configuration:
```
sudo nano /etc/ssh/sshd_config
```
* Uncomment line that starts with `#Port 22` and change it to `Port 33556`.
* Save file and exit text editor.
* Reconfigure Ubuntu firewall with new SSH port:
```
sudo ufw delete allow ssh
sudo ufw allow 33556/tcp
```
* Restart SSH server:
```
sudo systemctl restart ssh
```
* To check SSH service status:
```
sudo systemctl status ssh
```
-----
# Conclusion
SSH server is now installed and running on your host machine, you can now use PuTTY to remotely access your host machine.
