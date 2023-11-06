# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server and installed the CIFS service on your host machine

This instruction set will create a CIFS credentials file to allow for host machine access to a CIFS share

-----
# Instructions
* While in root, create CIFS credentials file
```
sudo nano <directory>/.<credentialsfilename>
```
* Enter credentials into file
```
username=<username>
password=<password>
```
* Change permissions of credentials file
```
sudo chmod 600 <directory>/.<credentialsfilename>
```
-----
# Conclusion
Your CIFS credentials file is now created and given the proper permissions for usage on your host machine
