#!/bin/sh

set -e

DEVICE=$1
ALPINE_SOURCE=https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf
HEADLESS_SOURCE=https://github.com/macmpi/alpine-linux-headless-bootstrap/raw/main
HEADLESS_FILE=headless.apkovl.tar.gz

if [ -z "$DEVICE" ]; then
    echo "ERROR: You have to specify a device to which the image shall be written!"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
CURR_DIR=$(pwd)

cd $TEMP_DIR

#mkdir /tmp/test
#cd /tmp/test

echo "Retreive latest release info"
wget --quiet $ALPINE_SOURCE/latest-releases.yaml

LATEST_VERSION=$(grep "file:.*rpi" latest-releases.yaml | sed 's/^[[:space:]]*file: \(alpine-rpi-.*-armhf.tar.gz\).*$/\1/g')
echo "Download latest image $LATEST_VERSION"
wget https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/$LATEST_VERSION

echo -n "Check against $LATEST_VERSION.sha512 ... "
wget --quiet https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/$LATEST_VERSION.sha512
if [ "$(cat $LATEST_VERSION.sha512)" == "$(sha512sum $LATEST_VERSION)" ]; then 
    echo "sha256sum OK"
else
    echo "FAILED"
    exit 1
fi

echo "Download headless config"
wget --quiet $HEADLESS_SOURCE/$HEADLESS_FILE

echo "Creating partition"
echo 'size=512M, type="W95 FAT32 (LBA)", bootable' | sfdisk $DEVICE
# wait for remounting device
sleep 1
mkfs.vfat ${DEVICE}1

mkdir -p mnt


echo "Extracting tarball"
mount ${DEVICE}1 ./mnt
tar -xf $LATEST_VERSION -C ./mnt
cp $HEADLESS_FILE ./mnt/
echo "gpu_mem=16" >> ./mnt/usercfg.txt

umount ./mnt

cd $CURR_DIR
rm -r $TEMP_DIR
