#!/bin/bash

cd ~/bk-blockchain-demos/ngo-lambda

echo Copy the Managed Blockchain TLS Certificate
cp ~/managedblockchain-tls-chain.pem ./src/certs/managedblockchain-tls-chain.pem

echo Generate the Fabric connection profile
./gen-connection-profile.sh
sed -i "s|/home/ubuntu/managedblockchain-tls-chain.pem|./certs/managedblockchain-tls-chain.pem|g" ./src/connection-profile.yaml

# Install the gcc compiler to be used when installing the npm dependencies
sudo yum install gcc-c++ -y

echo Install Node.js. We will use v10.x.
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install lts/dubnium
nvm use lts/dubnium
cd src
npm install
cd ..

echo Package the Cloudformation template
aws s3 mb s3://$BUCKETNAME --region $REGION

aws cloudformation package --template-file lambda-api-template.yaml \
    --output-template-file packaged-lambda-api-template.yaml \
    --s3-bucket $BUCKETNAME

echo Deploy the Lambda Cloudformation stack
export CHAINCODEID=ngo
export LAMBDA_STACK_NAME=fabric-lambda-stack
export VPC_STACK_NAME=$NETWORKNAME-fabric-client-node
export VPCID=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='VPCID'].OutputValue" --output text --region $REGION)

aws cloudformation deploy --stack-name $LAMBDA_STACK_NAME --template-file packaged-lambda-api-template.yaml \
--region $REGION --capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides CAENDPOINT=$CASERVICEENDPOINT PEERENDPOINT=grpcs://$PEERSERVICEENDPOINT \
ORDERERENDPOINT=grpcs://$ORDERINGSERVICEENDPOINT CHANNELNAME=$CHANNEL \
CHAINCODEID=$CHAINCODEID MSP=$MSP MEMBERNAME=$MEMBERNAME VPCID=$VPCID \
SECURITYGROUPID=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='SecurityGroupID'].OutputValue" --output text --region $REGION ) \
SUBNETID=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='PublicSubnetID'].OutputValue" --output text --region $REGION ) LAMBDANAME=$LAMBDANAME

echo Lambda creation completed. API Gateway is active at:
echo $(aws cloudformation describe-stacks --stack-name $LAMBDA_STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='APIGatewayURL'].OutputValue" --output text --region $REGION )