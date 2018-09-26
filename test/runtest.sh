#!/usr/bin/env bash

cd /data0
mkdir test
cd test

curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/writefile.py
python writefile.py

curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/test/test.cql
cat test.cql | cqlsh localhost
