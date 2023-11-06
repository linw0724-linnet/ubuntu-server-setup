# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

This instruction set will install Docker on your host machine to allow for installation of Docker containers

Benefits of running programs in Docker containers include the ability to easily backup/update/restore running programs quickly without affecting the rest of the host machine

-----
# Instructions
* Remove any old versions of Docker
```
sudo apt-get remove docker docker.io containerd runc
```
* Clean up any unused packages
```
sudo apt autoremove
```
* Install components for Docker repository
```
sudo apt install ca-certificates curl gnupg lsb-release
```
* Add Docker official GPG key
```
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
* Update Apt repository to include Docker repository when using apt commands
```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
* Install Docker
```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
* Install docker compose
```
sudo apt install docker-compose
```
-----
# Conclusion
Docker is now installed on your host machine and is ready to accept installations of containers
