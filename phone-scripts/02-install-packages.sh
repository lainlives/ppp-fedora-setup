#!/bin/bash

echo "==================="
echo "02-install-packages.sh"
echo "==================="

source /root/.user

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "This adds the copr repository (alho/Pine ) and installs packages."
infecho "Only functional on Fedora Rawhide."
infecho "HEAVY WIP, minimally tested."
infecho "Configuring DNF..."
infecho "Link temp-resolv.conf"
ln -sfv /etc/tmp-resolv.conf /etc/resolv.conf

infecho "Removing old kernel..."
{
dnf -q -y remove kernel || rpm -e --noscripts kerne-core
} >/dev/null 2>&1

infecho "Setting dnf to 20 consecutive downloads..."
{
echo '[main]'
echo 'gpgcheck=1'
echo 'installonly_limit=2'
echo 'clean_requirements_on_remove=True'
echo 'best=True'
echo 'skip_if_unavailable=True'
echo 'timeout=60'
echo 'rpmverbosity=critical'
echo 'retries=0'
echo 'fastestmirror=true'
echo 'deltarpm=0'
echo 'max_parallel_downloads=20'
echo 'metadata_expire=7d'
} > /etc/dnf/dnf.conf

infecho "Enabling COPR repository..."
{
dnf -q -y copr enable njha/mobile
dnf -q -y copr enable alho/Pine 
} >/dev/null 2>&1

infecho "Installing Plasma, this might take a while..."
{
dnf -q -y install wireplumber alsa-ucm purple-mm-sms okular-mobile kalk maui-mauikit-index-fm plasma-disks plasma-phonebook qmlkonsole megapixels wlr-randr rtl8723cs-firmware NetworkManager-wwan gvfs-goa megi-kernel-fedora feedbackd  ModemManager-nosuspend evolution-data-server xdg-user-dirs plasma-dialer spacebar plasma-settings koko angelfish calindori  --setopt=install_weak_deps=False
dnf -q -y install plasma-workspace dolphin
} >/dev/null 2>&1
infecho "About half done..."
{
dnf -q clean packages
dnf -q -y group install kde-mobile-apps kde-mobile kde-desktop --with-optional --setopt=install_weak_deps=True
dnf -q clean packages
dnf -q -y download pinephone-helpers
rpm -ivh --force *pinephone-helpers*.rpm
dnf -q -y remove *firefox*
dnf -q clean packages
} >/dev/null 2>&1 

if [[ -n $CPACK ]]; then
    infecho "Base pacakages installed, installing packages: $CPACK..."
    {
    dnf -q -y install  $CPACK
    } >/dev/null 2>&1
else
    infecho "Packages installed..."
fi

infecho "Making COPR higher priority for kernel updates..."
echo "priority=10" >> /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:alho\:Pine.repo

infecho "Upgrading packages..."
dnf -y upgrade >/dev/null 2>&1



infecho "Setting dnf to sane defaults for a phone..."
{
echo '[main]'
echo 'gpgcheck=1'
echo 'installonly_limit=2'
echo 'clean_requirements_on_remove=True'
echo 'best=True'
echo 'skip_if_unavailable=True'
echo 'timeout=60'
echo 'retries=0'
echo 'fastestmirror=true'
echo 'deltarpm=1'
echo 'deltarpm_percentage=30'
echo 'max_parallel_downloads=10'
echo 'metadata_expire=7d'
} > /etc/dnf/dnf.conf

infecho "Removing kernel again..."
{
dnf -q -y remove kernel || rpm -e --noscripts kerne-core
} >/dev/null 2>&1

infecho "Enabling graphical boot..."
systemctl enable initial-setup.service
#systemctl disable gdm
#systemctl disable lightdm
#systemctl enable sddm
systemctl set-default graphical.target


infecho "SDDM autologin settings..."
{
echo "[Autologin]"
echo "Relogin=false"
echo "Session=plasma-mobile"
echo "User=$USER"
echo " "
echo "[General]"
echo "HaltCommand="
echo "RebootCommand="
echo " "
echo "[Theme]"
echo "Current=breeze"
echo " "
echo "[Users]"
echo "MaximumUid=60000"
echo "MinimumUid=1000"
} > /etc/sddm.conf.d/kde_settings.conf
dnf clean all
