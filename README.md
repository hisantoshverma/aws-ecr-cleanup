# Bash Script to AWS ECR Cleanup

## Author : Santosh verma

There are two scripts.

  - aws-ecr-cleanup.sh : Can be use individually for ad-hoc purpose.
  - aws-ecr-bulk-cleanup.sh : To delete from multiple ecr repositories. it's call aws-ecr-cleanup.sh in loop.
  - aws-ecr-list.txt : Contains list of repositories for bulk cleanup:

# Dependencies!

  - AWS CLI
  - aws credentials with delete access are require. These can be set up using the "aws configure" command or by IAM role.
  - Tested on aws-cli/1.14.20

# Usage
  - ./aws-ecr-bulk-cleanup.sh
  - To set in cron, use Non-interactive mode
    sh aws-ecr-bulk-cleanup.sh  > /dev/null 2>&1
  - To be use once for ad-hoc purpose
    ./aws-ecr-cleanup.sh <IMAGE-REPO-NAME> <RETAIN-COUNT>
  - Update aws-ecr-list.txt with valid ecr repositories (currently has sample repositories).
