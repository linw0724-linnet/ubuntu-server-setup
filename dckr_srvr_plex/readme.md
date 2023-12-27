# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

> [!NOTE]
> Skip any steps that have already been completed.

This instruction set will set up a Plex Server inside a Docker container that has its media stored on a NAS and shared via SMB on the same network on your host machine.

-----
# Prerequisite Setup
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/readme.md).
* [Enable Ubuntu firewall](/enable_firewall/readme.md).
* [Install SSH Server](/install_ssh-srvr/readme.md).
* Connect via PuTTY.
* Set up Ubuntu firewall for Plex Server:
```
sudo ufw allow 32400/tcp
```
* [Install Nano and update packages](/install_nano/readme.md).
* [Install Docker](/install_docker/readme.md).
* Create directories for Plex Server:
```
sudo mkdir -p /nas/{plexserverdatabase,plexserverdatabasebackup,plexserverphysicalmedia,plexservertempmedia,plexservertranscode,plexserveroptimizedmedia}
sudo mkdir -p /opt/plexserver/config
```
> [!NOTE]
> `plexserverdatabase` folder is for storage of Plex Server database files.
>
> `plexserverdatabasebackup` folder is for storage of Plex Server database backups.
>
> `plexserverphysicalmedia` folder is for storage of Plex Server library physical media.
>
> `plexservertempmedia` folder is for storage of Plex Server library physical temporary media.
>
> `plexservertranscode` folder is for storage of Plex Server transcoding data.
>
> `plexserveroptimizedmedia` folder is for storage of Plex Server optimized versions of media.

> [!NOTE]
> You can organize your storage directories to whatever topology you want as long as you enter the correct settings to match the topology through the Plex Server UI.
-----
# Optional NAS Connection
* [Install Avahi](/install_avahi/readme.md).
* [Install CIFS](/install_cifs/readme.md).
* Enter Deluge Server directory:
```
cd /opt/plexserver
```
* Download `.plexservercredentials` file from Github in preparation for mounting CIFS shares to the host machine:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_plex/.plexservercredentials
```
* Edit `.plexservercredentials` file:
```
sudo nano /opt/plexserver/.plexservercredentials
```
* Replace `<username>` and `<password>` with the proper credentials for accessing the CIFS shares on the NAS.
* Save file and exit text editor.
* Set up CIFS shares to mount at boot up:
```
sudo nano /etc/fstab
```
* Add the following CIFS entries to the `fstab` file:
> [!IMPORTANT]
> Replace `<NAS-share-path>` with the appropriate path of the SMB share on your NAS.

> [!IMPORTANT]
> For the `<NAS-share-path>` path to work correctly, your root directory should be suffixed with `.local`. For example, your NAS share path will look like `<NAS-name>.local/<directory>`.

> [!IMPORTANT]
> For the Plex Server host machine to properly access the NAS directory, ensure that directory permissions on the NAS are set correctly in accordance with the credentials that you specified in your `.plexservercredentials` file that you created earlier.
```
# Connect Plex database CIFS share to local Plex Server database directory
//<NAS-share-path> /nas/plexserverdatabase cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex database backup CIFS share to local Plex Server database backup directory
//<NAS-share-path> /nas/plexserverdatabasebackup cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex physical media CIFS share to local Plex Server physical media directory
//<NAS-share-path> /nas/plexserverphysicalmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex temp media CIFS share to local Plex Server temp media directory
//<NAS-share-path> /nas/plexservertempmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex transcode CIFS share to local Plex Server transcode directory
//<NAS-share-path> /nas/plexservertranscode cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex optimized media CIFS share to local Plex Server optimized media directory
//<NAS-share-path> /nas/plexserveroptimizedmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
```
* Save file and exit text editor.
* Mount CIFS shares:
```
sudo mount -a
```
* Check if Plex Server database backup CIFS shares are visible:
```
cd /nas/plexserverdatabasebackup
ls -a
```
* Return to root:
```
cd
```
* Check if Plex Server physical media CIFS shares are visible:
```
cd /nas/plexserverphysicalmedia
ls -a
```
* Return to root:
```
cd
```
* Check if Plex Server temp media CIFS shares are visible:
```
cd /nas/plexservertempmedia
ls -a
```
* Return to root:
```
cd
```
* Check if Plex Server transcode CIFS shares are visible:
```
cd /nas/plexservertranscode
ls -a
```
* Return to root:
```
cd
```
* Check if Plex Server optimized media CIFS shares are visible:
```
cd /nas/plexserveroptimizedmedia
ls -a
```
* Return to root:
```
cd
```
-----
# Optional NAS Connection Scripting
* Enter Plex Server directory:
```
cd /opt/plexserver
```
* Download `plexserver_cifs_check.sh` file from Github:
> [!NOTE]
> This script will automatically check the status of your CIFS shares and auto remount if necessary.
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_plex/plexserver_cifs_check.sh
```
* Give `plexserver_cifs_check.sh` execute permissions:
```
sudo chmod 555 /opt/plexserver/plexserver_cifs_check.sh
```
* Return to root:
```
cd
```
-----
# Optional Nvidia GPU Installation
* Check which driver is being used for the Nvidia GPU:
> [!NOTE]
> Under `configuration`, it should say `driver=` followed by what brand of driver is being used. If it says `nvidia`, you can skip this section of instructions.
```
sudo lshw -c display
```
* List available drivers for your Nvidia GPU from the default Ubuntu repository:
```
sudo ubuntu-drivers devices
```
* To install the recommended driver, run the following command:
```
sudo ubuntu-drivers autoinstall
```
* To install a specific driver, run the following command, replacing `<version-number>` with the number associated with your desired driver:
```
sudo apt install nvidia-driver-<version-number>
```
* After the driver is installed, run the following command to reboot the computer:
```
sudo shutdown -r now
```
* After reboot, check which driver is being used for the Nvidia GPU:
> [!NOTE]
> Under `configuration`, it should say `driver=nvidia` if the Nvidia GPU driver installation was successful.
```
sudo lshw -c display
```
* After reboot, you can also use the following command to check if everything works correctly:
```
nvidia-smi
```
* After installing the Nvidia GPU drivers successfully, set up the repository for the Nvidia container toolkit to give the GPU the ability to transcode:
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```
* Install Nvidia container toolkit:
```
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```
-----
# Install Plex Server
* Enter Plex Server directory:
```
cd /opt/plexserver
```
* Download `docker-compose.yml` file from Github to set up the Plex Server Docker container:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_srvr_plex/docker-compose.yml
```
* Edit `docker-compose.yml` file:
```
sudo nano /opt/plexserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone name for your host machine.
* Replace `<claim-token>` with the claim token given to you from `https://www.plex.tv/claim`.
* Replace `<local-net/subnet>` with all your local networks separated by commas, it should look something like `10.0.0.1/24,10.0.0.2/24,10.0.0.3/24`.
* Save file and exit text editor.
* Test Plex Docker container:
```
sudo docker-compose -f /opt/plexserver/docker-compose.yml config
```
* Start Plex Docker container:
```
cd /opt/plexserver
sudo docker-compose up -d
```
-----
# Installation Status Check
* Check that TrueCommand Docker container is running:
```
sudo docker ps -a
```
-----
# Optional Scripting
* Set startup scripts:
```
crontab -e
```
* Add the following entries to the `crontab -e` file:
```
# Set Plex Server CIFS Check Script to run at reboot
@reboot /opt/plexserver/plexserver_cifs_check.sh
# Set Plex Server CIFS Check Script to run on the first day of every month at 0500
0 5 1 * * /opt/plexserver/plexserver_cifs_check.sh
# Set Plex Docker container to auto update and restart on the first day of every month at 0500
0 5 1 * * docker restart plexserver
```
* Save file and exit text editor.
-----
# Using Plex Server
Plex Server is now set up in a Docker container on your host machine.

Go to the web UI for plex via a web browser under `https://app.plex.tv/desktop/` to finish setting up your Plex Server.

-----
# Enabling GPU Transcoding
* After successful installation of your Plex Server, access it via the web UI.
* Go to the `Transcoder` page under `Settings` and check the boxes next to `Use hardware acceleration when available` and `Use hardware-accelerated video encoding`.
* For the `Hardware transcoding device` under the `Transcoder` settings page, you can select the correct GPU from the drop down menu or leave it on `Auto` if no GPUs are visible in the drop down menu.
* To see if the Plex Server is using hardware transcode, start a video with a client device and under `Playback Settings`, select `Convert Automatically` or convert to whatever lower resolution than the original video quality, then go to the `Dashboard` page under `Settings`, and under `Now Playing`, you should see `(hw)` next to the word `Transcode` under the `Video` information for the stream.