# Author = Dushan Wijesinghe
# Original Post = https://devopslinux.wordpress.com/2015/12/31/find-all-non-password-user-accounts-and-lock-them/

# passwd -S : Display account status information using following


#--------- format:-------------------
# PS : Account has a usable password
# LK : User account is locked
# NP : Account has no password

#!/bin/sh
USERS=”$(cut -d: -f 1 /etc/shadow)”
for u in $USERS do passwd -S $u | grep “NP” > /dev/null ## this will return 0 if found
if [ $? -eq 0 ]; then
passwd -l $u
fi
done