#!/bin/bash
yum update -y
wget https://package.perforce.com/perforce.pubkey
gpg --with-fingerprint perforce.pubkey
rpm --import https://package.perforce.com/perforce.pubkey
touch /etc/yum.repos.d/perforce.repo
echo '[perforce]' > /etc/yum.repos.d/perforce.repo
echo 'name=Perforce' >> /etc/yum.repos.d/perforce.repo
echo 'baseurl=http://package.perforce.com/yum/rhel/7/x86_64' >> /etc/yum.repos.d/perforce.repo
echo 'enabled=1' >> /etc/yum.repos.d/perforce.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/perforce.repo
yum -y install helix-p4d
export pwd=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
export localip=$(curl --silent curl http://169.254.169.254/latest/meta-data/local-ipv4)
export p4port=":1666"
export p4address=$localip$p4port
echo $p4address
sudo mkfs -t xfs /dev/sdb
sudo mkdir /mnt/depot
sudo mount /dev/sdb /mnt/depot
export p4root="/mnt/depot"
sudo /opt/perforce/sbin/configure-helix-p4d.sh master -p $p4address -r $p4root -u super -P $pwd --case 0 -n
