# Installation script Alpine Linux on Raspberry

These scripts ease the installation of Alpine.
The result is a minimal Alpine Linux with Docker is installed.
The intention is to run additional applications in a containers.

In the final system it is not possible to login as root via ssh.
A second user is create, which can be used for login.
The default name of the user is "bernd".
For ssh only public key authentication is allowed.
The default username and the default public key can be adapted in [setup-alpine.awnsers](setup-alpine.awnsers).
To get root rights via ssh, you have to login with the additional user and then use "sudo" combined with the root password.

All this is tested with an Raspberry PI 1 B+.

## Step 1: Disk preparation

In step one, the SD-Card for the Raspberry PI will be prepared from another Linux system.
We assume, that the SD-Card is "/dev/sda".

The preparation is started with:
``` bash
prepare-sd.sh /dev/sda
```

The script downloads the newest version of Alpine Linux and copies it to the SD-Card.
**All data on the SD-Card will be deleted**
After the script is finished, the SD-Card ready for the first boot.

## Step 2: Basic System Setup

Put the SD-Card into the Raspberry PI.
Plug in an Ethernet cable and power it up.
You have to find out the IP the Raspberry PI.
We will assume that the IP is "192.168.0.2".
Copy the content of this folder to the Raspberry PI:

``` bash
scp * root@192.168.0.2:/tmp/
```

Login with:

``` bash
ssh root@192.168.0.2
```

You don't need any password for the first login.
After a successful login set up the basic system with:

``` bash
/tmp/system-setup.sh
```

You will be ask to provide a password for root and the additional user.
You also have to confirm to overwrite all data on the SD-Card for the installation.

If the script is finished, you can reboot the system with:
``` bash
reboot
```

## Step 3: Docker install and setup

On you host system (not the target system), you have to edit the known hosts for ssh.
ssh has stored a fingerprint of the public key from the Raspberry PI in the last step.
During the last step we also created a new public key for the Raspberry PI.
Therefor the fingerprint does not match the new system and ssh will refuse to login into the new system.
To change this behavior, you have to delete each line starting with "192.168.0.2" from the file "~/.ssh/known\_hosts".

Now you can copy the content of this folder to the new system with:

``` bash
scp * bernd@192.168.0.2:/tmp/
```

If you private key is encrypted, than you will be ask for the encryption key to decrypt the key.
Remember, you can not login as root to the new system by ssh.

Login to the system:
``` bash
ssh bernd@192.168.0.2
```

Install and configure docker with:
``` bash
sudo /tmp/system-setup2.sh
```

Afterwards reboot the system and than it can be used.
