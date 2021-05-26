# Original Post = https://devopslinux.wordpress.com/2014/06/22/java-memory-usage/
#!/bin/bash
output=$(ps -eo pid,cmd,pmem|more |grep java | grep -v grep)
usep=$(echo $output | awk ‘{ print $3}’)
mem=${usep%.*}

if [ $mem -gt 80 ]; then
echo “Running out of Java Memory ”$mem%” on $(hostname) as on $(date)” |
mail -s “Alert from TestServer: Almost out of Java – Memory – $mem%” test@xxxxxxx.com
fi