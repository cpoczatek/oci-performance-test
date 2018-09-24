#!/usr/bin/env bash

echo "Running node.sh"

# Java
echo "Installing Oracle Java 8 JDK"
cd ~
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
yum localinstall jdk-8u152-linux-x64.rpm

# DataStax
echo "
[datastax]
name = DataStax Repo for DataStax Enterprise
baseurl=https://datastax@oracle.com:*9En9HH4j^p4@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/datastax.repo
yum install dse-full-4.8.15-1

# Grab the test scripts and drop them in /
curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/test.cql
curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/writefile.py
