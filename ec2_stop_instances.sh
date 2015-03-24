#!/usr/local/bin/bash

#
## Setup variables
#
. /home/ec2/.profile
EXC=`cat excluded_instances.log`
DATE=`date`
LOGFILE=/home/ec2/ec2instancestatus.log
LOGFILE2=/home/ec2/ec2instancestatus2.log

#
## Grab all EBS instances, remove reservations, instance-store, blockdevice.
## Then print only the instance id's. Finally grep out the excluded instance id's
## and provide a valid list of them to stop or start.
#
EC2INSTANCES=`/home/ec2/bin/ec2-describe-instances | grep -v 'RESERVATION' | grep -v 'instance-store' | grep -v 'BLOCKDEVICE' | awk '{print $2}' | egrep -v $EXC`

#
## Execute the stop command using the automated generated list of instances.
## Date the log file and the status of the process.
#
echo "STOPPING INSTANCES -- $DATE" >> $LOGFILE
/home/ec2/bin/ec2-stop-instances $EC2INSTANCES >> $LOGFILE
