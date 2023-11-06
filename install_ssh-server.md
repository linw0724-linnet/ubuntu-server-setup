* Install SSH Server
```
sudo apt update
sudo apt upgrade
sudo apt install openssh-server
```
* Set up Ubuntu firewall for SSH server
```
sudo ufw allow ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```
* Enter SSH server configuration
```
sudo nano /etc/ssh/sshd_config
```
* Uncomment line that starts with '#Port 22' and change it to port 33556a<br>
* Save file and exit text editor<br>
* Reconfigure Ubuntu firewall with new SSH port
```
sudo ufw delete allow ssh
sudo ufw allow 33556/tcp
```
* Restart SSH server
```
sudo systemctl restart ssh
```
* To check SSH service status
```
sudo systemctl status ssh
```
