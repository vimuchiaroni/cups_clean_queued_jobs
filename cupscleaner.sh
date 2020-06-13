#!/bin/bash

################################ Clean cups print jobs ###############################
#
#  Author : Victor Muchiaroni
#  Version: 1.0
#  Date   : 20200114
#
# This script automates cups printer cleaning defined by a retention policy

###################################################################################

#################################### VARIABLES ######################################
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
today=`date "+%Y-%m-%d"`
IFS=$'\n'
RETENTION='3days'
####################################################################################
#convert the date to Y-m-d format and add the RETENTION in order to compare to today's date
get_date() {
    date --utc --date="$1 +$RETENTION" +"%Y-%m-%d"
}


#Compare the job date with todays date and cancel it if it is greater than the defined RETENTION
for line in $(lpstat -o);do
        job_date=$(echo $line|awk '{print $5 "-" $6 "-" $7}')
        if [[ $today > $(get_date $job_date) ]]
        then
                print_job=$(echo $line|awk '{print $1}')
                echo "canceling print job $print_job on $today. Queued since $job_date"
                cancel $print_job
        else
                echo "Job $(echo $line|awk '{print $1}') is too recent to be canceled. Queued since $job_date"
fi
done

