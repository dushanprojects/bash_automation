# Author = Dushan Wijesinghe
# Original Post = https://devopslinux.wordpress.com/2014/07/04/to-configure-history-command-print-date-and-time-2/

To add date and time to history
===============================

vim /etc/bashrc and add below to the bottom of file

export HISTTIMEFORMAT=”%Y-%m-%d_%H:%M:%S “

NOTE: it is better if to add the contents in the /home/student/.bashrc to to the bottom of /etc/bashrc file as well.

Eg:
export HISTTIMEFORMAT=”%Y-%m-%d_%H:%M:%S “

 

To add colour code to hightlight root
=====================================

vim /root/.bashrc

add below to the bottom of file

PS1=’[e[33;1;41m][u@h W]$[e[0m]‘