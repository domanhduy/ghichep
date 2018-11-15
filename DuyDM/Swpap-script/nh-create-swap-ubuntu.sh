#!/bin/bash
#Swap Ubuntu 16.04
#--------Run-------- 
#	wget https://raw.githubusercontent.com/domanhduy/ghichep/nhanhoadocs/master/DuyDM/Swpap-script/nh-create-swap-ubuntu.sh
#	bash nh-create-swap-ubuntu.sh
#	rm -rf nh-create-swap-ubuntu.sh

# Tao swapfile
echo "Nhap swap can tao VD: 2"
read swap
fallocate -l "$swap"G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon --show
sleep 3
# Chinh sua de luu cau hinh khi reboot
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
free -m


