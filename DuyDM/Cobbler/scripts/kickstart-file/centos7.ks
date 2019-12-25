#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use HTTP installation media
url --url="http://10.10.14.34/cblr/links/Centos7-x86_64/"

# Root password
rootpw --iscrypted $default_password_crypted

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

part /boot --fstype ext4 --size=512 --asprimary
part pv.4 --size=1 --grow --ondisk=vda
volgroup VolGroup00 pv.4
logvol swap --fstype swap --name=LogVol00 --vgname=VolGroup00 --recommended
logvol / --fstype xfs --name=LogVol01 --vgname=VolGroup00 --size=1 --grow

%packages
@^minimal

@core
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end

