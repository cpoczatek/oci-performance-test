# VM

This test is a VirtualBox image running on my laptop.

## Laptop
* MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports)
* macOS High Sierra 10.13.6 (17G65)

## VirtualBox
* VirtualBox 5.2.18 r124319 (Qt5.6.3)
* Oracle Linux (64-bit)
* 8192 GB RAM
* 12GB Virtual Disk
* VDI
* Dynamically Allocated

## Oracle Linux
* https://www.oracle.com/technetwork/server-storage/linux/downloads/index.html
* Oracle Linux 7.5.0.0.0 x86 64-bit
* V975363-01.iso Oracle Linux Release 7 Update 5 Boot ISO image for x86 (64 bit), 540.0 MB
* Network install with https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64

## Test
These commands will run the test:

    cd /
    curl -O https://raw.githubusercontent.com/benofben/oci-performance-test/master/vm/setup.sh
    chmod +x setup.sh
    ./setup.sh
    ./runtest.sh
