# Build a Hyperledger Fabric blockchain network using Amazon Managed Blockchain

These steps allow you to run setup `credentials`, `fabric channels` and `chaincode` to run a smart contract

## Step 1 - Amazon Blockchain Network Configuration
The script allow set a environment with Fabric Network and one peer. You don't need to run init.sh which will be called automatically.

```
cd fabric
./amb-fabric-launch.sh
```

## Step 2 - Hyperledger Fabric client
This script will create a VPC and EC2 instance dedicated to fabric client. One of key configurations is setting the Endpoint allowing EC2 communication with AMB.

```
cd ../fabric-client
./fabric-client-launch.sh
```

Connect in the EC2 instance to create a Fabric network using the provided CloudFormation template. You will clone the code to run scripts.

```
ssh -i ~/"healthcare-keypair.pem" ubuntu@<EC2 instance>

git config --global user.name "fabric-developer"
git config --global user.email fabric@abcgov.com.br
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/bk-blockchain-demos

cd bk-blockchain-demos/patient-clinical-exams/healthcare-fabric
source fabric-exports.sh
source ~/peer-exports.sh
```

This step is only to check if the environment variable was set correctcly. Be aware that you're in the /home/ubuntu folder now. No changes is needed.

```
echo '** Peer endpoint: '$PEERSERVICEENDPOINT
```

## Step 3 - Enroll an identity in the blockchain network
Enroll an admin identity with the Fabric CA (certificate authority). We will use this identity to administer the Fabric network and perform tasks such as creating channels and instantiating chaincode.

```
aws s3 cp s3://us-east-1.managedblockchain/etc/managedblockchain-tls-chain.pem managedblockchain-tls-chain.pem

fabric-ca-client enroll -u https://$ADMINUSER:$ADMINPWD@$CASERVICEENDPOINT --tls.certfiles ~/managedblockchain-tls-chain.pem -M ~/admin-msp

mkdir admin-msp/admincerts
cp admin-msp/signcerts/* admin-msp/admincerts/
```

## Step 4 - Update the configtx channel configuration and create the channel
This step can be done only once. The result is having the channel created.
```
cp bk-blockchain-demos/patient-clinical-exams/healthcare-fabric/configtx-template.yaml configtx.yaml
sed -i "s|__MEMBERID__|$MEMBERID|g" ~/configtx.yaml
configtxgen -outputCreateChannelTx $CHANNEL.pb -profile OneOrgChannel -channelID $CHANNEL --configPath ~/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/home/ubuntu/managedblockchain-tls-chain.pem
export CORE_PEER_ADDRESS=$PEER
export CORE_PEER_LOCALMSPID=$MSP
export CORE_PEER_MSPCONFIGPATH=$MSP_PATH

cp bk-blockchain-demos/patient-clinical-exams/healthcare-fabric/core.yaml .

peer channel create -c $CHANNEL -f /home/ubuntu/$CHANNEL.pb -o $ORDERER --cafile $CAFILE --tls --timeout 900s

peer channel join -b $CHANNEL.block  -o $ORDERER --cafile $CAFILE --tls
```

## Step 5 - Install, instantiate and invoke chaincode
Install the chaincode in GO.

```
peer channel list

export GOPATH=~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric/

peer chaincode install -n $CHAINCODENAME -v $CHAINCODEVERSION -p $CHAINCODEDIR

peer chaincode instantiate -o $ORDERER -C $CHANNEL -n $CHAINCODENAME -v $CHAINCODEVERSION -c '{"Args":["init","a","100","b","200"]}' --cafile $CAFILE --tls
```

## Step 6 - Invoke the chaincode
When you Invoke and query transactions, you cat set the log level 
(FATAL | PANIC | ERROR | WARNING | INFO | DEBUG)

```
export FABRIC_LOGGING_SPEC=ERROR

peer chaincode invoke -o $ORDERER -C $CHANNEL -n $CHAINCODENAME \
    -c '{"Args":["invoke","a","b","10"]}' --cafile $CAFILE --tls

peer chaincode query -C $CHANNEL -n $CHAINCODENAME -c '{"Args":["query","a"]}'
```