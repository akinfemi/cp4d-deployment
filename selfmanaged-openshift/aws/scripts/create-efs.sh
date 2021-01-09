#!/bin/bash

#Install aws CLI
curl -O https://bootstrap.pypa.io/get-pip.py > /dev/null
python get-pip.py --user > /dev/null
export PATH="~/.local/bin:$PATH"
source ~/.bash_profile > /dev/null
pip install awscli --upgrade --user > /dev/null
pip install pssh > /dev/null

CLUSTERID=$(oc get machineset -n openshift-machine-api -o jsonpath='{.items[0].metadata.labels.machine\.openshift\.io/cluster-api-cluster}')
EFS_SG_GROUPID=`aws ec2 create-security-group --group-name EFSSecutityGroup --description "EFS security group" --vpc-id $3 | awk -F':' '{print $2}' | awk '{print $1}' | xargs | tr -d '"'`
aws ec2 authorize-security-group-ingress --group-id $EFS_SG_GROUPID --protocol tcp --port 2049 --cidr $2
aws ec2 authorize-security-group-ingress --group-id $EFS_SG_GROUPID --protocol tcp --port 22 --cidr $2
FILESYSTEM_ID=`aws efs create-file-system --performance-mode $4 --tags "Key=Name,Value=$CLUSTERID-efs" --region $1 --query 'FileSystemId' | tr -d '"'`
sleep 30
aws efs put-lifecycle-configuration --file-system-id $FILESYSTEM_ID --lifecycle-policies "TransitionToIA=AFTER_30_DAYS" --region $1
SUBNET_IDS=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$3" "Name=tag:Name,Values=*private*" --query 'Subnets[*].SubnetId' --output text`
for subnets in ${SUBNET_IDS[@]}; do
aws efs create-mount-target --file-system-id $FILESYSTEM_ID --subnet-id $subnets --security-group $EFS_SG_GROUPID
done
