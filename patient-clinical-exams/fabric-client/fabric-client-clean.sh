#!/bin/bash
source init.sh

echo "******* Cleaning environment ******"
aws cloudformation delete-stack --stack-name $NETWORKNAME-fabric-client-node --region $REGION
aws ec2 delete-key-pair --key-name $NETWORKNAME-keypair
rm -f ~/$NETWORKNAME-keypair.pem 