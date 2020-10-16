#!/usr/bin/env bash

echo "Running dse.sh"

#echo "Disabling IBRS"
#echo 0 > /sys/kernel/debug/x86/ibrs_enabled

#######################################################
################# Turn Off the Firewall ###############
#######################################################
echo "Turning off the Firewall..."

echo "" > /etc/iptables/rules.v4
echo "" > /etc/iptables/rules.v6

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#######################################################
######################### Java ########################
#######################################################
echo "Installing Oracle Java 8 JDK..."
wget -O ~/jdk8.rpm -N --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.rpm
yum -y localinstall ~/jdk8.rpm

#######################################################
######################### Disks #######################
#######################################################
echo "Formatting the drives..."

dcount=$(cat /proc/partitions | grep -iv sda | sed 1,2d | gawk '{print $4}' | wc | gawk '{print $1}')

# RAID 0 of 3 disks, if available, otherwise 2
# This is assuming we have at least 2 disks
#if [ "$dcount" -ge 3 ]; then
#  mdadm --create --verbose --force --run /dev/md1 --level=0 \
#    --raid-devices=3 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1
#fi

#if [ "$dcount" -eq 2 ]; then
#  mdadm --create --verbose --force --run /dev/md1 --level=0 \
#    --raid-devices=2 /dev/nvme0n1 /dev/nvme1n1
#fi

mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 /dev/nvme0n1
mkdir /data
mount -t ext4 -o noatime /dev/nvme0n1 /data
UUID=$(lsblk -no UUID /dev/nvme0n1)
echo "UUID=$UUID   /data    ext4   defaults,noatime,discard,barrier=0 0 1" | sudo tee -a /etc/fstab

echo "Disabling swap"
swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab

echo "Installing jna, jemalloc"
yum install -y jna jemalloc

echo "Setting/persisting sysctl"
sysctl -w vm.max_map_count=1048575
sysctl -w \
net.core.rmem_max=16777216 \
net.core.wmem_max=16777216 \
net.core.rmem_default=16777216 \
net.core.wmem_default=16777216 \
net.core.optmem_max=40960 \
net.ipv4.tcp_rmem="4096 87380 16777216" \
net.ipv4.tcp_wmem="4096 65536 16777216"

cat << EOF > /etc/sysctl.conf
###
# C* settings
###
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.core.rmem_default=16777216
net.core.wmem_default=16777216
net.core.optmem_max=40960
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
EOF

#######################################################
####################### DataStax ######################
#######################################################
echo "Installing Cassandra..."

# replace 311x with 21x for 2.1.x
echo "[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS" | \
  sudo tee -a /etc/yum.repos.d/cassandra.repo
sudo yum -y install cassandra

# sed over yamls
node_ip=$(hostname -I)
node_broadcast_ip=$node_ip

seeds=$(dig +short dse-0.datastax.datastax.oraclevcn.com)

listen_address=$node_ip
broadcast_address=$node_broadcast_ip
rpc_address="0.0.0.0"
broadcast_rpc_address=$node_broadcast_ip

endpoint_snitch="GossipingPropertyFileSnitch"
num_tokens=32
data_file_directories="/data/cassandra/data"
commitlog_directory="/data/cassandra/commitlog"
saved_caches_directory="/data/cassandra/saved_caches"
phi_convict_threshold=12
auto_bootstrap="false"

# Create the data and commitlog directories
mkdir -p $data_file_directories
chown -R cassandra $data_file_directories
chgrp -R cassandra $data_file_directories

mkdir -p $commitlog_directory
chown -R cassandra $commitlog_directory
chgrp -R cassandra $commitlog_directory

mkdir -p $saved_caches_directory
chown -R cassandra $saved_caches_directory
chgrp -R cassandra $saved_caches_directory

file=/etc/cassandra/default.conf/cassandra.yaml

date=$(date +%F)
backup="$file.$date"
cp $file $backup

cat $file \
| sed -e "s:\(.*- *seeds\:\).*:\1 \"$seeds\":" \
| sed -e "s:[# ]*\(listen_address\:\).*:listen_address\: $listen_address:" \
| sed -e "s:[# ]*\(broadcast_address\:\).*:broadcast_address\: $broadcast_address:" \
| sed -e "s:[# ]*\(rpc_address\:\).*:rpc_address\: $rpc_address:" \
| sed -e "s:[# ]*\(broadcast_rpc_address\:\).*:broadcast_rpc_address\: $broadcast_rpc_address:" \
| sed -e "s:.*\(endpoint_snitch\:\).*:endpoint_snitch\: $endpoint_snitch:" \
| sed -e "s:.*\(num_tokens\:\).*:\1 $num_tokens:" \
| sed -e "s:\(.*- \)/var/lib/cassandra/data.*:\1$data_file_directories:" \
| sed -e "s:.*\(commitlog_directory\:\).*:commitlog_directory\: $commitlog_directory:" \
| sed -e "s:.*\(saved_caches_directory\:\).*:saved_caches_directory\: $saved_caches_directory:" \
| sed -e "s:.*\(phi_convict_threshold\:\).*:phi_convict_threshold\: $phi_convict_threshold:" \

> $file.new

echo "auto_bootstrap: $auto_bootstrap" >> $file.new
echo "" >> $file.new

mv $file.new $file

# Owner was ending up as root which caused the backup service to fail
chown cassandra $file
chgrp cassandra $file

service cassandra start

#######################################################
########################## Test #######################
#######################################################
#curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/runtest.sh
#chmod +x runtest.sh
