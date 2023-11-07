# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

This instruction set will install Git on your host machine and allow for pulling files from Github repositories

-----
# Instructions
## Check Git version
* Check the version of Git installed on your host machine
```
git --version
```
If you receive an output similar to the following, then Git is already installed
```
git version 2.25.1
```
## Install Git if not installed
* Update local package index
```
sudo apt update
```
* Install Git
```
sudo apt install git
```
* Check the version of Git installed on your host machine
```
git --version
```
If you receive an output similar to the following, then Git has been successfully installed
```
git version 2.25.1
```
-----
# Conclusion
Git is now set up on your host machine and you are ready to pull files from Github
