#!/bin/bash
# Date: 29.09.2018
# Cach thuc hien
# wget https://raw.githubusercontent.com/domanhduy/ghichep/nhanhoadocs/master/DuyDM/Swpap-script/nh-create-swap-centos.sh
# bash nh-create-swap-centos.sh
# rm -rf nh-create-swap-centos.sh

echo "Nhap swap can tao VD: 2"
read swap

sudo fallocate -l "$swap"G /swapfile

#sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
free -m

echo "DONE"
