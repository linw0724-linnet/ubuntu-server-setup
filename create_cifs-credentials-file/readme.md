# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server and installed the CIFS service on your host machine.

This instruction set will create a CIFS credentials file to allow for host machine access to a CIFS share.

-----
# Create A CIFS Credentials File
* While in root, create CIFS credentials file, replacing `<directory>` with the directory where you want the credentials file to reside, and replacing `<credentialsfilename>` with the file name you desire for the credentials file:
```
sudo nano <directory>/.<credentialsfilename>
```
* Enter credentials into file, replacing `<username>` and `<password>` with the proper credentials for accessing the CIFS shares on the NAS:
```
username=<username>
password=<password>
```
* Save file and exit text editor.
* Change permissions of credentials file, replacing `<directory>` and `<credentialsfilename>` with the values you entered when creating the credentials file at the beginning of this procedure:
```
sudo chmod 600 <directory>/.<credentialsfilename>
```