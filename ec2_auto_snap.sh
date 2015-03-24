#!/usr/local/bin/bash

#
## Setup variables
#
. /home/ec2/.profile
DATE=`date`
LOGFILE=/home/ec2/ec2autosnap.log
LOGFILE2=/home/ec2/ec2autosnap2.log

function autosnap(){

        local VOLUME=$1
        local LOGFILE=$2
        local SAVESNAP=$3
        local LOGFILE2=$4

                /home/ec2/bin/ec2-create-snapshot -d "AutoSnap Volume: $VOLUME" $VOLUME| awk '{print $2, $3, $5}' >> $LOGFILE

                if [ -f $LOGFILE ]
                then

                        REMOVESNAP=`grep $VOLUME $LOGFILE| awk '{print $1}'|awk 'NR==1'`
                        SNAPNUMBER=`grep $VOLUME $LOGFILE| wc -l`

                                if [ "$SNAPNUMBER" -gt "$SAVESNAP" ]
                                then

                                        /home/ec2/bin/ec2-delete-snapshot $REMOVESNAP
                                        cat $LOGFILE|grep -v $REMOVESNAP > $LOGFILE2
                                        mv $LOGFILE2 $LOGFILE

                                fi

                fi

}

#
## Execute the snapshot command using the list of volumes.
## Date the log file, volume ID, and snapshot ID.
#
while IFS=":" read VOLUME SAVESNAP DAY HOUR MINUTE
do

DAYOFWEEK=`date +%a`
HOUROFDAY=`date +%H`
MINUTEOFDAY=`date +%M`

if [ "$DAY" == "Everyday" -a "$HOUR" -eq "$HOUROFDAY" -a "$MINUTE" -eq "$MINUTEOFDAY" ]
then
autosnap $VOLUME $LOGFILE $SAVESNAP $LOGFILE2
fi

if [ "$DAY" == "$DAYOFWEEK" -a "$HOUR" -eq "$HOUROFDAY" -a "$MINUTE" -eq "$MINUTEOFDAY" ]
then
autosnap $VOLUME $LOGFILE $SAVESNAP $LOGFILE2
fi

done < volumes_autosnapped.log
