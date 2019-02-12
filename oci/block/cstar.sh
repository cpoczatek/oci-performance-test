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

# find/login/raid/mount block

for n in $(seq 2 9); do
  iqn=$(iscsiadm -m discovery -t sendtargets -p 169.254.2.$n:3260 | awk '{print $2}')
  if  [[ $iqn != iqn.* ]] ;
  then
    echo "Error: unexpected iqn value: $iqn"
    continue
  fi
  iscsiadm -m node -o update -T $iqn -n node.startup -v automatic
  iscsiadm -m node -T $iqn -p 169.254.2.$n:3260 -l
done

# use **all** iscsi disks to build raid
disks=$(ls /dev/disk/by-path/ip-169.254*)

mdadm --create --verbose --force --run /dev/md0 --level=0 \
  --raid-devices=8 \
  $disks

mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 /dev/md1

mkdir /data
mount -t ext4 -o noatime /dev/md0 /data
UUID=$(lsblk -no UUID /dev/md0)
echo "UUID=$UUID   /data    ext4   defaults,noatime,_netdev,nofail,discard,barrier=0 0 1" | sudo tee -a /etc/fstab

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
num_tokens=8
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
