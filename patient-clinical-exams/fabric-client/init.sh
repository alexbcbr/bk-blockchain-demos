#!/bin/bash

echo "******* Setting global variables ******"

export REGION=us-east-1
STACKNAME=$(aws cloudformation describe-stacks --region $REGION --query 'Stacks[?Description==`Amazon Managed Blockchain. Creates network with a single member and peer node`] | [0].StackName' --output text)
NETWORKNAME=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkName`].OutputValue' --output text)

