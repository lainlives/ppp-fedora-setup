#!/bin/bash
set -e

source .env

echo "====================="
echo "01-partition-drive.sh"
echo "====================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo $1 1>&2
}

# Automatic Preflight Checks
if [[ $EUID -ne 0 ]]; then
    errecho "This script must be run as root!" 
    exit 1
fi

# Warning
echo "=== WARNING WARNING WARNING ==="
infecho "This script will mount to ${PP_IMAGE}."
infecho "Make sure nothing else is mounted there: lsblk"
echo "=== WARNING WARNING WARNING ==="
echo
if [ ! -z "$PS1" ]; then
    read -p "Continue? [y/N] " -n 1 -r
else
    REPLY=y
fi
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    infecho "Begining image partition..."
    sfdisk $OUT_NAME <<EOF
label: dos
unit: sectors

4MiB,252MiB,
256MiB,,
EOF
    infecho "Image partitioned!"

    infecho "Mounting the image to ${PP_IMAGE}..."
    losetup "${PP_IMAGE}" fedora.img
    partprobe -s "${PP_IMAGE}"

    infecho "Beginning filesystem creation..."
    infecho "If this fails, you might need to install mkfs.btrfs."
    mkfs.vfat -n BOOT $PP_PARTA
    mkfs.btrfs -f -L ROOT $PP_PARTB
    infecho "Filesystems created!"
fi

infecho "If there are no errors above, the script was probably successful!"
