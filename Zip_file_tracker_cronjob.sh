#!/bin/bash
# Author = Dushan Wijesinghe
# Original Post = https://devopslinux.wordpress.com/2014/07/04/create-zip-file-tracker-cronjob/

shopt -s nullglob  #prevent lameness from glob matching

#shopt use to toggle the values of variables controlling optional behavior. Usually it can be on or off only. On other hand, IFS value can be anything as per users requirements.

SUBJECT=”ZIP FILE FOUND IN DEPLOY FOLDER of TestServer3 – $(hostname) – NODE 1″
EMAIL=”student@example.com.com”
EMAIL_MESSAGE=”/tmp/emailmessage.txt”

echo “This is to inform that someone has copied a zip file to TestServer3 node 1 Deploy folder (/www/jboss/server/default/deploy/). Delete the zip file immediatly” > $EMAIL_MESSAGE

PATH=”/www/jboss/server/default/deploy”
Y=0
for x in ${PATH}/*.zip ; do
Y=1
done

if test $Y -gt 0
then
echo “Zip Files are Available”
/bin/mail -s “$SUBJECT” “$EMAIL” < $EMAIL_MESSAGE
else
echo “No Zip Files Found”
fi