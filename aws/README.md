# AWS

I logged into the AWS console and launched an x1e.4xlarge using the AMI:
Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-04681a1dbd79675a5

SSH connect to the machine with:

    ssh -i ~/.ssh/aws.pem ec2-user@52.45.118.31

This machine has an ssd on /dev/shm

Run setup.sh on the machine.  When that's complete runtest.sh
