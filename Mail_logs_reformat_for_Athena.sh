# Author : Dushan Wijesinghe | 2021
## This script will allow to reformat your log by in order to use for AWS athena.
#Eg/-
#Original log format
# ----------------------------------------------------------------------------------------------------------------------------------------
# May 10 09:00:04 app1     postfix/cleanup[16235]: 2FF22618A7: message-id=<20210510090004.2FF22618A7@at2-dev-app1.localdomain>
# ----------------------------------------------------------------------------------------------------------------------------------------
#
# This script will spilt coloumn 1 - 3 and print rest of the coloumn at next. Please refer below
# ----------------------------------------------------------------------------------------------------------------------------------------
# May ^10 ^09:00:04 ^app1 ^    postfix/cleanup[16235]: 2FF22618A7: message-id=<20210510090004.2FF22618A7@at2-dev-app1.localdomain>
# ----------------------------------------------------------------------------------------------------------------------------------------

#Then you can use following athena table structure for Log Aggregation 
#CREATE EXTERNAL TABLE `production`(
#  `month` string, 
#  `date` string, 
#  `timestamp` string, 
#  `hostname` string,
#  `details` string
#  )
#ROW FORMAT DELIMITED 
#  FIELDS TERMINATED BY '^' 
#STORED AS INPUTFORMAT 
#  'org.apache.hadoop.mapred.TextInputFormat' 
#OUTPUTFORMAT 
#  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
#LOCATION
#  's3://my-prod-athena-bucket/mail_logs/production/'

# Script use 
# find /var/log/ -name "maillog" -exec /root/Mail_logs_reformat_for_Athena.sh {} \;
# aws s3 sync /var/log/  s3://my-prod-athena-bucket/mail_logs/production/`hostname`/ --exclude "*" --include "*.s3"


# ------------------------------------------ Script start ------------------------------------------------------------
#!/bin/bash
IFS='
'

x=($(cat $1 | awk '{print $1, "^"$2, "^"$3}'))
y=($(cat $1 | awk '{first = $1; $1 = ""; second = $2; $2 = "" ; third = $3; $3 = ""; print "^"$0 }'))
loop=${#x[*]}
for ((z=0; z<=$loop; z++))
do
  echo "${x[$z]}" "${y[$z]}" >> $1`date +%H%M`.s3
done

# ------------------------------------------ Script end ------------------------------------------------------------
