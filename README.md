# oci-performance-test

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

### Results

| Shape         | Write - Rows/s      | Read - Rows/s       |
|---------------|---------------------|---------------------|
| DenseIO1.8    | 91750, 87833, 94438 | 53860, 61656, 54321 |
| DenseIO1.16   | 98965, 98969, 99622 | 59546, 54565, 50383 |
| DenseIO2.8    | 84025, 90316, 90995 | 22636, 20679, 19295 |
| DenseIO2.16   | 98493, 99291, 99286 | 49216, 44196, 40638 |

### Analysis

Write seems to perform the same regardless of hardware.  Reads are the same for generation 1 and the same for generation 2.  It's fascinating that the read performance on the 8 core is 1-2 to 1/3 on generation 2 of what it was on generation 1. For the 16 core the performance difference on reads seems less pronounced across generations.

This isn't a great test.  Because of the short time frame, the results don't stabilize.  Additionally, it's not a representative workload.  We'd strongly suggest building some acceptance criteria based on cassandra-stress and working from there.

It's possible the JDK version is influencing results.  Everything else seems to be the same.

I don't believe this is actually stressing the hardware in any meaningful way, rather we're bottlenecking on some part of the system that is uncharacteristic of real load.  This is clear because of the similar performance observed on different hardware.

### Next Steps
I'd suggest we identify a representative cassandra-stress load and tune for that.  We'd want to identify acceptance criteria, for instance throughput and latency targets.  Alternatively, we could try to build a test harness for a real world workload.
