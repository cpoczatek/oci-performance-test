#!/usr/bin/env bash

cd /dev/shm
mkdir test
cd test

curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/aws/test/writefile.py
python writefile.py

curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/aws/test/test.cql
cat test.cql | cqlsh localhost
