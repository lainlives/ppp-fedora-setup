These scripts generate a 10gb fedora rawhide image with far too many plasma-desktop and plasma-mobile packages.

## Dependencies

- wget
- xz
- btrfs-progs (for mkfs.btrfs)
- dosfstools (for mkfs.vfat)
- rsync
- uboot-tools (for mkimage)
- qemu-user-static (for qemu-aarch64-static)

## Usage

1. Edit `.env` with your own variables.
2. Run `bash download-files.sh` then `sudo bash all.sh`. Verify the information presented whenever it asks you to confirm.

## Tips

- Run all scripts other than download-files.sh as root, and from this (README.md) directory! Do not directly run anything in the phone-scripts folder! Those scripts are, as the name suggests, executed on the phone.
- If a script fails midway through, some things may still be mounted. `sudo ./cleanup.sh` will attempt to unmount everything.
