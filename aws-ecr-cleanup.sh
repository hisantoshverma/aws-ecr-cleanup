#!/bin/bash

# Script to clean up AWS ECR repos and keep desire count.

## Usage:
## ./aws-ecr-cleanup.sh <IMAGE-REPO-NAME> <RETAIN-COUNT>
##
## Dependencies
## aws credentials with delete access are require. These can be set up using the "aws configure" command or by IAM role.
## Tested on following aws version
## aws-cli/1.14.20 Python/2.7.13 Linux/4.9.70-25.242.amzn1.x86_64 botocore/1.8.24

set +e
repoName=$1
retainCount=$2
## Set the region in the parameters below.
awsRregion=us-east-1
# set YES/NO
# Any value other than NO will not delete any image
#dryRun=YES
dryRun=NO


ImageCount=`aws ecr describe-images --repository-name ${repoName} --region ${awsRregion} --output text | awk {'print $3'} | grep -v ^$ | sort |wc -l`
echo "Total Image = $ImageCount"
echo -n "To be delete = "
echo $(( $ImageCount - $retainCount ))
if [ $(( $ImageCount - $retainCount )) \< 1 ] ; then
   echo "No action require"
   exit 0
fi
aws ecr describe-images --repository-name ${repoName} --region ${awsRregion} --output text | awk {'print $3'} | grep -v ^$ | sort | head -n $(( $ImageCount - $retainCount )) > oldImageTimeStamp.txt

echo -n "Oldest image going to delete is of :"
date -d @$(head -1 oldImageTimeStamp.txt)

echo -n "Recent image going to delete is of :"
date -d @$(tail -1 oldImageTimeStamp.txt)

if [ $dryRun == 'NO' ];then
  echo "Deleting old images .."
  for i in `cat oldImageTimeStamp.txt`
  do
    oldImageDigest=`aws ecr describe-images --repository-name ${repoName} --region ${awsRregion} --output text | grep -w $i | awk {'print $2'}`
    aws ecr batch-delete-image --repository-name ${repoName} --image-ids imageDigest=${oldImageDigest}
  done
else
    echo "Running is dry run mode"
fi
