#!/bin/bash
set -e

bash /root/01-create-sudo-user.sh
bash /root/02-install-packages.sh

echo "Setting user Pine's XDG user directories..."
sudo -u pine xdg-user-dirs-update

echo "Disable automatic brightness..."
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

echo "Set Phoc's scale-to-fit active globally..."
gsettings set sm.puri.phoc scale-to-fit true

echo "Remove temp-resolv.conf"
rm /etc/tmp-resolv.conf
rm /etc/resolv.conf
