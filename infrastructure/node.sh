#!/usr/bin/env bash

echo "Running node.sh"

# Java
echo "Installing Oracle Java 8 JDK"
# The old 152 JDK seems to have been removed from the download site.  We're using a newer one instead.
#wget -O ~/jdk8.rpm -N --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u152-b16/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u152-linux-x64.rpm
wget -O ~/jdk8.rpm -N --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm
yum -y localinstall ~/jdk8.rpm

# DataStax
echo "[datastax]
name = DataStax Repository
baseurl=https://datastax%40oracle.com:*9En9HH4j^p4@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0" > /etc/yum.repos.d/datastax.repo
yum -y install dse-full-4.8.15-1
service dse start

# Test
curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/runtest.sh
chmod +x runtest.sh
/runtest.sh
