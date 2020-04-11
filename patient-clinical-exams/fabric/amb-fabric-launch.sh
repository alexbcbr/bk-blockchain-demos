#!/bin/bash
source init.sh

echo Creating Amazon Managed Blockchain network, member and peer node

aws cloudformation deploy --stack-name $STACKNAME --template-file amb.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--region $REGION
