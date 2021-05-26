#!/bin/bash
# Note: This will fix the dongle connectivity issue in Ubuntu laprops.
## Replace 12d1:14fe based on your dongle model ##
GG=$( lsusb | awk '{print $6}' | grep 12d1:14fe | wc -l )
if [ $GG = 1 ]; then
usb_modeswitch -J -v 0x12d1 -p 0x14fe
else
 echo lsusb
fi
