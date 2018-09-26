#!/usr/bin/env bash

echo "Running node.sh"

#######################################################
######################### Disks #######################
#######################################################
echo "Formatting the drives..."

## Give ISCSI time to intiate
iscsi="1"
while [ $iscsi = "1" ]; do
	if [ -f /tmp/iscsi.lock ]; then
		iscsi="1"
		sleep 1
	else
		## Wait 10 seconds to allow for any latent iscsi operations to finish, then proceed
		sleep 10
		iscsi="0"
	fi
done

## Primary Disk Mounting Function
data_mount () {
	echo -e "Mounting /dev/$disk to /data$dcount"
	sudo mkdir -p /data$dcount
	sudo mount -o noatime,barrier=1 -t ext4 /dev/$disk /data$dcount
	UUID=`sudo lsblk -no UUID /dev/$disk`
	echo "UUID=$UUID   /data$dcount    ext4   defaults,noatime,discard,barrier=0 0 1" | sudo tee -a /etc/fstab
}

## Check for x>0 devices
echo -n "Checking for disks..."
nvcount="0"
bvcount="0"

## Execute - will format all devices except sda for use as data disks in HDFS
dcount=0
for disk in `sudo cat /proc/partitions | grep -iv sda | sed 1,2d | gawk '{print $4}'`; do
	echo -e "\nProcessing /dev/$disk"
	sudo mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 /dev/$disk
	data_mount
	sudo /sbin/tune2fs -i0 -c0 /dev/$disk
	if [ "$is_worker" = "true" ]; then
		if [ "$enable_data_tiering" = "1" ]; then
			data_tiering
		fi
	fi
	dcount=$((dcount+1))
	nv_chk=`echo $disk | grep nv`;
	nv_chk=$?
	if [ $nv_chk = "0" ]; then
		nvcount=$((nvcount+1))
	else
		bvcount=$((bvcount+1))
	fi
done;
ibvcount=`cat /tmp/bvcount`
if [ $ibvcount -gt $bvcount ]; then
	echo -e "ERROR - $ibvcount Block Volumes detected but $bvcount processed."
else
	echo -e "DONE - $nvcount NVME disks processed, $bvcount Block Volumes processed."
fi

# The drive is at /data0
# There may be more drives, but we're just going to use that one for now.

#######################################################
######################### Java ########################
#######################################################
echo "Installing Oracle Java 8 JDK..."
wget -O ~/jdk8.rpm -N --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm
yum -y localinstall ~/jdk8.rpm

#######################################################
####################### DataStax ######################
#######################################################
echo "Installing DataStax..."

echo "[datastax]
name = DataStax Repository
baseurl=https://datastax%40oracle.com:*9En9HH4j^p4@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0" > /etc/yum.repos.d/datastax.repo
yum -y install dse-full-4.8.15-1

# Configure the data and commitlog directories
mkdir -p /data0/cassandra/data
chown -R cassandra /data0/cassandra/data
chgrp -R cassandra /data0/cassandra/data
sed -i -e 's|/var/lib/cassandra/data|/data0/cassandra/data|g' /etc/dse/cassandra/cassandra.yaml

mkdir -p /data0/cassandra/commitlog
chown -R cassandra /data0/cassandra/commitlog
chgrp -R cassandra /data0/cassandra/commitlog
sed -i -e 's|/var/lib/cassandra/commitlog|/data0/cassandra/commitlog|g' /etc/dse/cassandra/cassandra.yaml

service dse start

#######################################################
########################## Test #######################
#######################################################
curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/runtest.sh
chmod +x runtest.sh
