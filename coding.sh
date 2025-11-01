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
echo "installation base-devel glibc linux-api-headers"
pacman --sync --noconfirm --needed base-devel glibc linux-api-headers
echo "ACTIVATION system read only"
steamos-readonly enable



