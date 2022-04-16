#!/bin/bash
yum update -y
mkfs -t xfs /dev/sdb
mkdir /mnt/depot
mount /dev/sdb /mnt/depot
export p4root="/mnt/depot"
export pwd=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
export localip=$(curl --silent curl http://169.254.169.254/latest/meta-data/local-ipv4)
export p4port=":1666"
export p4address=$localip$p4port
/opt/perforce/sbin/configure-helix-p4d.sh master -p $p4address -r $p4root -u super -P $pwd --case 0 -n
