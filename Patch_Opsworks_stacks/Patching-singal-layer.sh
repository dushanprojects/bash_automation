#!/bin/bash
# Author : Dushan Wijesinghe | © 2021-08-08
# Singal Layer instance Patching (image replace)

STACK_NAME=$1
REGION=$2
#latest_ami=$3 # if you enable this usage will be "/your_script_path/Patcing.sh <stack-name> <region> <AMI ID>"
OWNER=$( aws sts get-caller-identity --query Account --output text )
StackId=$( aws opsworks describe-stacks --region $REGION --query 'Stacks[*].[Name,StackId]' --output text | grep -i $STACK_NAME | awk '{print $2}' )
latest_ami=$( aws ec2 describe-images --region $REGION --owners $OWNER  --filters "Name=name,Values=amznamazonlinux-custom-ami-prod-2021-08-**" --query 'sort_by(Images, &CreationDate)[].ImageId' --output text )
LayerId=$( aws opsworks --region $REGION describe-layers --stack-id  $StackId --query Layers[*].[LayerId] --output text )
# List layers of a stack

# Functions
#######################################################################################################################
# Gather Old instance details -----------------------------------------------------------------------------------------
get_instance_details () {
    aws opsworks --region $REGION describe-instances --layer-id  $LayerId \
     --query 'Instances[*].[Status, InstanceId, SubnetId, InstanceType, ElasticIp, Hostname, AmiId, AutoScalingType]' --output text > $LayerId-old-instance.txt
}

# Check instance status when start/stop/deleted ------------------------------------------------------------------------
Check_instance_status () {
    aws opsworks --region $REGION describe-instances --instance-ids $InstanceId --query 'Instances[*].[Status]' --output text
}

# Stop old instance  ----------------------------------------------------------------------------------------------------
stop_instance () {
    aws opsworks  stop-instance --instance-id $InstanceId --region $REGION #--force 
}
# Delete old instance  --------------------------------------------------------------------------------------------------
delete_instance () {
    aws opsworks  delete-instance --no-delete-elastic-ip --instance-id $InstanceId --region $REGION
}
# Create instance with latest AMI ----------------------------------------------------------------------------------------
create_instance () {
   aws opsworks create-instance --region $REGION --stack-id $StackId --layer-ids $LayerId --instance-type $InstanceType \
   --os Custom --ami-id $latest_ami --hostname $Hostname --subnet-id $SubnetId 
}
# Start new instance  ----------------------------------------------------------------------------------------------------
start_instance () {
    aws opsworks start-instance --instance-id $InstanceId --region $REGION
}

# Usage
echo -e "#################### Usage #######################"
echo -e "/your_script_path/Patcing.sh <stack-name> <region>"
echo -e "##################################################"

#Tasks
#######################################################################################################################
# 1. Get the available instance details of the provided Layer
get_instance_details

IFS=$'\n'
for instances in $( cat $LayerId-old-instance.txt ); do
# 2. Set random variables of each instance
Status=$( echo $instances | awk '{ print $1}' )
InstanceId=$( echo $instances | awk '{ print $2}' )
SubnetId=$( echo $instances | awk '{ print $3}' )
InstanceType=$( echo $instances | awk '{ print $4}' )
ElasticIp=$( echo $instances | awk '{ print $5}' )
Hostname=$( echo $instances | awk '{ print $6}' )
AmiId=$( echo $instances | awk '{ print $7}' )

  if [ $Status == "stopped" ]; then
    echo "$Hostname is already stoppd"
    echo "Skipping AMI replace"
  else
    ## 3. Stop Old Instance
    echo -e "Stopping $Hostname in progress\n" 
    stop_instance
        CHECK=$( Check_instance_status )
        while [ "$CHECK" == "stopping" ] ; do
        echo -e "Still Instance $Hostname is stopping"
        sleep 20
        CHECK=$( Check_instance_status )
        done
    ## 4. Deleting the instance
    delete_instance
    echo -e "Instance $Hostname is deleted\n"
    sleep 10
    ## 5. Creating new instance wit latest AMI
    create_instance > instance-id.txt
    echo -e "Instance $Hostname is created\n"
    ## 6. Start new instance
    InstanceId=$( grep "InstanceId"  instance-id.txt | awk '{ print $2 }' | tr -d \" )
    start_instance
    echo -e "Instance $Hostname start initiated\n"
        CHECK=$( Check_instance_status )
        # 7. Check new instance starting process
        while [ "$CHECK" == "pending" ] || [ "$CHECK" == "requested" ] || [ "$CHECK" == "booting" ] || [ "$CHECK" == "running_setup" ] ; do
        echo -e "Still Instance $Hostname is starting"
        sleep 20
        CHECK=$( Check_instance_status )
        done
    echo -e "Instance $Hostname is online\n"
   fi
done   