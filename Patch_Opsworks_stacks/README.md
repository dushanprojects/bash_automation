# Patch_Opsworks_stack
This solution is to replace your Opsworks instance with the latest custom AMI which will be released by your organization's cloud management team or your AMI build pipeline.

During the instance replacement, it will keep the elastic IP (EIP) and re-allocate the same EIP to the instance. if the EIP is not enabled in your layer settings, it will allocate new public IP for each instance. The instance replace process will follow a sequence order to avoid any downtime. However, if your layer having one instance, you will experience a downtime during the instance replace process.

## Example Stack with multiple layers and instances
![instances_in_multiple_layers](https://github.com/dushan566/bash_automation/blob/main/Patch_Opsworks_stacks/instances_in_multiple_layers.PNG?raw=true)


## Prerequisite
1. Latest AWS AMI

You can query the latest image by name and pass to "latest_ami" variable
```
latest_ami=$( aws ec2 describe-images --region $REGION --owners $OWNER  \
--filters "Name=name,Values=amznamazonlinux-custom-ami-prod-2021-08-*" \
--query 'sort_by(Images, &CreationDate)[].ImageId' --output text )
```
Or else you can set "latest_ami" variable as an argument and pass during runtime.
Eg/- latest_ami=$3
`
./Patching.sh <Stack Name> <region> <imageid>
`

2. You should have an Opsworks stack
The stack will be having one or more layers, instances.

## Usage
```
./Patching.sh <Stack Name> <region>
```
