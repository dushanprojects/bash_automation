#!/bin/bash
cd Qualys_Agent_Install
rpm -i qualys-cloud-agent.x86_64.rpm
cd /usr/local/qualys/cloud-agent/bin/
./qualys-cloud-agent.sh ActivationId=xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx CustomerId=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx
