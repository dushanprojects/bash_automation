#!/bin/bash
#Author: Dushan Wijesinghe | 2021
S3_BUCKET='example-s3-bucket'
ENVIRONMENT='production'

maillog () {
   find /var/log/ -name "maillog" -exec /root/Mail_logs_reformat_for_Athena.sh {} \;
   aws s3 sync /var/log/  s3://$S3_BUCKET/mail_logs/$ENVIRONMENT/`hostname`/ --exclude "*" --include "*.s3"
   find /var/log/ -name "maillog-*" -type f -mtime +1 -delete
   rm -rf /var/log/*.s3
}

app_logs () {
  cd /application_path/log/
  /root/App_logs_reformat.sh example.log
  aws s3 sync /application_path/log/  s3://$S3_BUCKET/app_logs/sso_sp/$ENVIRONMENT/`hostname`/  --exclude "*" --include "*.s3"
  find /application_path/log/ -name "*.log*" -type f -mtime +1 -delete
  rm -rf *.s3
}

apache_error_logs () {
  cd /var/log/httpd
  gunzip error.log-*.gz
  aws s3 sync /var/log/httpd/ s3://$S3_BUCKET/apache_error_logs/$ENVIRONMENT/`hostname`/ --exclude "*" --include "error.log*"
  find /var/log/httpd/ -name "error.log*" -type f -mtime +1 -delete
}

apache_access_logs () {
  cd /var/log/httpd
  gunzip access.log-*.gz
  aws s3 sync /var/log/httpd/ s3://$S3_BUCKET/apache_access_logs/$ENVIRONMENT/`hostname`/ --exclude "*" --include "access.log*"
  find /var/log/httpd/ -name "*" -type f -mtime +1 -delete
}

maillog
app_logs
apache_error_logs
apache_access_logs
