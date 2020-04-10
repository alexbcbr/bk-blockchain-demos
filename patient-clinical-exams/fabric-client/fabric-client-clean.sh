#!/bin/bash

echo "******* Cleaning environment ******"

export REGION=us-east-1
NETWORKNAME=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkName`].OutputValue' --output text)

aws cloudformation delete-stack --stack-name $NETWORKNAME-fabric-client-node --region $REGION
aws ec2 delete-key-pair --key-name $NETWORKNAME-keypair
rm -f ~/$NETWORKNAME-keypair.pem 