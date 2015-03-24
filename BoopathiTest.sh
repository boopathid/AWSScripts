#!/usr/local/bin/bash
. /home/ec2/.profile
/home/ec2/bin/ec2-describe-instances  > ScriptLog_new.txt
