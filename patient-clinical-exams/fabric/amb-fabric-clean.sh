#!/bin/bash
source init.sh

echo '******* CLEANING AMAZON BLOCKCHAIN FABRIC environment ******'

aws cloudformation delete-stack --stack-name $STACKNAME --region $REGION

echo "******* END ******"

