#!/usr/bin/env bash

echo "Running node.sh"

# JDK 8u152

# DSE 4.8.15
echo "
[datastax]
name = DataStax Repo for DataStax Enterprise
baseurl=https://datastax@oracle.com:*9En9HH4j^p4@rpm.datastax.com/enterprise
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/datastax.repo

yum install dse-full-4.8.15-1
