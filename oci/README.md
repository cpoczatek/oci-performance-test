# oci

## September 24, 2018
I'm running the Python and CQL on a single node cluster of the following shapes.  This is using:

| Variable      | Value                         |
|---------------|-------------------------------|
| Nodes         | 1                             |
| OS            | Oracle-Linux-7.5-2018.08.14-0 |
| Java          | Oracle jdk-8u181              |
| DataStax      | DSE 4.8.15-1                  |

We're not using jdk-8u152 because it is so old that the rpm been pulled from the Oracle download site, though a tar.gz is still available.  Instead, we're using the current 181.

This version of DSE is also extremely old.  Newer versions have far better performance because both the storage engine and file system have been rewritten, resulting is a [3x-10x performance speedup](https://www.datastax.com/2018/06/zdata-benchmark-study-shows-datastax-enterprise-6-outperforms-open-source-apache-cassandra) depending on what you're measuring.

This test is a bit unrepresentative in that it's a single node.  Typical clusters are 3 or more nodes with a replication of three.  Often those are distributed across ADs, though we're actually exploring single AD deployment, leveraging FDs for resilience in OCI.

Typically tests like this use [cassandra-stress](https://docs.datastax.com/en/cassandra/2.1/cassandra/tools/toolsCStress_t.html), not copy.  This performance is unlikely to be indicative of more typical CQL workloads.  I recall a DataStax engineer at one point saying he wouldn't trust a benchmark that was run for less than 24 hours.

To run the test:

    terraform init
    terraform apply

Then SSH to the machine using the value from the Terraform output and run:

    cd /
    sudo su
    ./runtest.sh

## September 25, 2018
I wasn't thinking and was just using the boot volume for these tests.  I'm going to rerun with the local drive and modify the repo appropriately.
