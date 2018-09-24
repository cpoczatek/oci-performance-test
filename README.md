# oci-performance-test

## September 24, 2018
We have Python and CQL scripts.  I'm running those on a single node cluster of the following shapes.  This is using:

| Variable      | Value                         |
|---------------|-------------------------------|
| Nodes         | 1                             |
| OS            | Oracle-Linux-7.5-2018.08.14-0 |
| Java          | Oracle jdk-8u152              |
| DataStax      | DSE 4.8.15-1                  |

Our results are:hav

| Shape         | Rows/s        |
|---------------|---------------|
| DenseIO1.8    | 123           |
| DenseIO1.16   | 123           |
| DenseIO2.8    | 123           |
| DenseIO2.16   | 123           |
