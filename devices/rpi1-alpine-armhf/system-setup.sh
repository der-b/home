#!/bin/sh

set -e

SRC_DIR=`dirname $0`

setup-alpine -e -f $SRC_DIR/setup-alpine.awnsers

# only allow ssh login with public key
# therefore we do not need to set passwords
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config

echo "Set root password"
passwd root

echo "Set password for bernd"
passwd bernd

apk add --no-cache sudo
echo "Defaults targetpw" >> /etc/sudoers
echo "ALL ALL=(ALL:ALL) ALL" >> /etc/sudoers 

copy-modloop
umount /dev/mmcblk0p1

setup-disk -m sys /dev/mmcblk0
