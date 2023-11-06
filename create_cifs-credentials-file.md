> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server and installed the CIFS service
-----
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
**Your CIFS credentials file is now created and given the proper permissions for usage**
