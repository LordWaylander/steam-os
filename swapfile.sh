#!/bin/bash

responseUser="not_defined"
futureSizeSwapFile=8192 #define swapfile size


if [ $USER != "root" ]; then
  echo -e "You are not root, exiting... \n"
  exit 
fi

while [ $responseUser != "N" ] && [ $responseUser != "Y" ]; do
  echo "want to set swapFile ? [Y/n]"
  read responseUser
  responseUser=${responseUser^^}
done

if [ $responseUser = "N" ]; then
  echo -e "end script \n"
  exit 1
fi

actualSizeSwapFile=$(($(wc -c < /home/swapfile )/1024/1024))

echo "size swapFile : $actualSizeSwapFile MB"

if [ $actualSizeSwapFile -lt futureSizeSwapFile ]; then
  echo "-- set swapFile to $futureSizeSwapFile MB --"
  swapoff /home/swapfile
  dd if=/dev/zero of=/home/swapfile bs=1G count=8
  mkswap /home/swapfile
  swapon /home/swapfile
  echo "-- swapFile defined to $futureSizeSwapFile MB --"
fi