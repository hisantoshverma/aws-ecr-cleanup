#!/bin/bash

##########################################
# Author : Santosh verma
#########################################

## NOTE :
## Ensure aws-ecr-list.txt contains correct list before execute:


# Script to clean up AWS ECR repos and keep desire count.

## Usage:
## ./aws-ecr-bulk-cleanup.sh
##
## To set in cron, use Non-interactive mode:
## sh aws-ecr-bulk-cleanup.sh  > /dev/null 2>&1
## Dependencies
## Require aws-ecr-list.txt and aws-ecr-cleanup.sh on same path
## aws credentials with delete access are require. These can be set up using the "aws configure" command or by IAM role.
## Tested on following aws version
## aws-cli/1.14.20 Python/2.7.13 Linux/4.9.70-25.242.amzn1.x86_64 botocore/1.8.24

set +e
## Set the retain count for ECR repo in below parameters:
retainCount=200

## reading repo list form file:
for i in `cat aws-ecr-list.txt`
do
  echo "CleanUp start for $i"
  sh aws-ecr-cleanup.sh $i ${retainCount}
done
