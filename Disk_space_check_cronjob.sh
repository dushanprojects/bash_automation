# Author = Dushan Wijesinghe
# Original Post = https://devopslinux.wordpress.com/2014/06/22/disk-space-check-cronjob/

#!/bin/bash

output=$(df -h | grep -vE ‘^Filesystem|tmpfs|cdrom’ | awk ‘{ print $4 ” ” $1 }’)
USAGE=$(echo $output | awk ‘{ print $1}’ | cut -d’G’ -f1 |cut -d ‘.’ -f1 )
PARTITION=$(echo $output | awk ‘{ print $2 }’ )
if [ $USAGE -le 90 ]; then
echo “Running out of space ”$PARTITION ($USAGE GB)” on $(hostname) as on $(date)” |
mail -s “Alert from Test Server: Almost out of disk space $USAGE GB” student@example.com
fi

output1=$(df -h | grep -vE ‘^Filesystem|tmpfs|cdrom’ | awk ‘{ print $4 ” ” $1 }’)
USAGE1=$(echo $output1 | awk ‘{ print $3}’ | cut -d’G’ -f1 |cut -d ‘.’ -f1 )
PARTITION1=$(echo $output1 | awk ‘{ print $4 }’ )
if [ $USAGE1 -le 90 ]; then
echo “Running out of space ”$PARTITION1 ($USAGE1 GB)” on $(hostname) as on $(date)” |
mail -s “Alert from Test Server: Almost out of disk space $USAGE1 GB” student@example.com
fi

output2=$(df -h | grep -vE ‘^Filesystem|tmpfs|cdrom’ | awk ‘{ print $4 ” ” $1 }’)
USAGE2=$(echo $output2 | awk ‘{ print $5}’ | cut -d’G’ -f1 |cut -d ‘.’ -f1 )
PARTITION2=$(echo $output2 | awk ‘{ print $6 }’ )
if [ $USAGE2 -le 90 ]; then
echo “Running out of space ”$PARTITION2 ($USAGE2 GB)” on $(hostname) as on $(date)” |
mail -s “Alert from Test Server: Almost out of disk space $USAGE2 GB” student@example.com
fi

#You can use the following two methods for mail body
#echo “something” | mail -s “subject” email@address
#echo “something” > $mailbody. Then, mail -s “subject” email@address < $mailbody