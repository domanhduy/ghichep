#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use HTTP installation media
url --url="http://10.10.10.30/cblr/links/CentOS7-x86_64/"

# Root password
rootpw --iscrypted $1$LZPjRqrT$1Co2OVdHMuNluneJkDPex.

# Network information
network --bootproto=dhcp --nameserver=8.8.8.8
services --enabled=NetworkManager,sshd,chronyd

# Reboot after installation
reboot

# System authorization information
auth useshadow passalgo=sha512

# Use graphical install
graphical

firstboot disable

# System keyboard
keyboard us

# System language
lang en_US

# SELinux configuration
selinux disabled

# Installation logging level
logging level=info

# System timezone
timezone Asia/Ho_Chi_Minh

# System bootloader configuration
# Thiet lap o cung voi layout nhu sau: 
# - Thu muc /boot co dung luong 512MB va khong su dung LVM, 
# - Phan vung SWAP thiet lap tu dong theo RAM va nam trong LVM
# - Phan vung / tu dong gian no theo dung luong cua disk nam trong LVM
# Detect the used hardware type
bootloader --location=mbr --boot-drive=vda --append="net.ifnames=0 biosdevname=0"
clearpart --all --initlabel

part / --fstype ext4 --size 5 --grow --asprimary --ondisk=vda
part swap --size 1024 --ondisk=vda
part /boot --fstype ext4 --size 1024 --ondisk=vda

%packages
@^minimal

@core
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end

