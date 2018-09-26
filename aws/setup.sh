#!/usr/bin/env bash

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
mkdir -p /dev/shm/cassandra/data
chown -R cassandra /dev/shm/cassandra/data
chgrp -R cassandra /dev/shm/cassandra/data
sed -i -e 's|/var/lib/cassandra/data|/dev/shm/cassandra/data|g' /etc/dse/cassandra/cassandra.yaml

mkdir -p /dev/shm/cassandra/commitlog
chown -R cassandra /dev/shm/cassandra/commitlog
chgrp -R cassandra /dev/shm/cassandra/commitlog
sed -i -e 's|/var/lib/cassandra/commitlog|/dev/shm/cassandra/commitlog|g' /etc/dse/cassandra/cassandra.yaml

service dse start

#######################################################
########################## Test #######################
#######################################################
curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/aws/test/runtest.sh
chmod +x runtest.sh
