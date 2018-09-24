# oci-performance-test

## September 24, 2018
We have Python and CQL scripts.  I'm running those on a single node cluster of the following shapes.  This is using:

| Variable      | Value                         |
|---------------|-------------------------------|
| Nodes         | 1                             |
| OS            | Oracle-Linux-7.5-2018.08.14-0 |
| Java          | Oracle jdk-8u181              |
| DataStax      | DSE 4.8.15-1                  |

We're not using jdk-8u152 because it is so old that it's been pulled from the Oracle download site.  Instead, we're using the current 181.

This version of DSE is also extremely old.  Newer versions have far better performance because both the storage engine and file system have been rewritten, resulting is a [3x-10x performance speedup](https://www.datastax.com/2018/06/zdata-benchmark-study-shows-datastax-enterprise-6-outperforms-open-source-apache-cassandra) depending on what you're measuring.

This test is a bit unrepresentative in that it's a single node.

Our results are:

| Shape         | Read - Seconds | Read - Rows/s | Write - Seconds | Write - Rows/s |
|---------------|----------------|---------------|-----------------|----------------|
| DenseIO1.8    | 32.697         | 9175          | 55.695          | 5386
| DenseIO1.16   | 123     |
| DenseIO2.8    | 123     |
| DenseIO2.16   | 123     |
