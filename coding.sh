#!/bin/bash

if [ $USER != "root" ]; then
  echo -e "You are not root, exiting... \n"
  exit 
fi

CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2 | tr -d '"')

echo "initialisation pacman-key"
pacman-key --init

echo "population de pacman-key archlinux"
pacman-key --populate archlinux
echo "population de pacman-key $CODENAME"
pacman-key --populate "$CODENAME"

echo "DESACTIVATION system read only"
steamos-readonly disable
#echo "installation base-devel glibc linux-api-headers"
#pacman --sync --noconfirm --needed base-devel glibc linux-api-headers
echo "installation libvirt"
pacman --sync --noconfirm --needed libvirt qemu-base dnsmasq

echo "add user to libvirt group"
usermod -aG libvirt deck

echo "start libvirt service"
systemctl start libvirtd.service #enable ?
systemctl start dnsmasq

firewall-cmd --permanent --new-zone=libvirt 2>/dev/null || true
firewall-cmd --reload
virsh net-start default 2>/dev/null || true
virsh net-autostart default

grep -qxF 'user = "deck"' /etc/libvirt/qemu.conf || echo 'user = "deck"' >> /etc/libvirt/qemu.conf
grep -qxF 'group = "deck"' /etc/libvirt/qemu.conf || echo 'group = "deck"' >> /etc/libvirt/qemu.conf

echo "ACTIVATION system read only"
steamos-readonly enable



