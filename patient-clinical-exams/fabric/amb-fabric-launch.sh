#!/bin/bash

export REGION=us-east-1
export STACKNAME=healthcare-fabric-amb

echo Creating Amazon Managed Blockchain network, member and peer node

aws cloudformation deploy --stack-name $STACKNAME --template-file amb.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--region $REGION
