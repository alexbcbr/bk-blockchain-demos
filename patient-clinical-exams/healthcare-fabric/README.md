# Introduction

This steps allow you to run setup `credentials`, `fabric channels` and `chaincode` to run a smart contract

# Setting Fabric Server

```
* export REGION=us-east-1

cd ~/non-profit-blockchain/ngo-fabric
````

source fabric-exports.sh
source ~/peer-exports.sh



echo '** Peer endpoint: '$PEERSERVICEENDPOINT
echo '** Membership service provider: '$MSP
 
aws s3 cp s3://us-east-1.managedblockchain/etc/managedblockchain-tls-chain.pem managedblockchain-tls-chain.pem

1. Enroll an admin identity with the Fabric CA (certificate authority). We will use this identity to administer the Fabric network and perform tasks such as creating channels and instantiating chaincode.

fabric-ca-client enroll -u https://$ADMINUSER:$ADMINPWD@$CASERVICEENDPOINT --tls.certfiles ~/managedblockchain-tls-chain.pem -M ~/admin-msp

mkdir admin-msp/admincerts
cp admin-msp/signcerts/* admin-msp/admincerts/

2. Update the configtx channel configuration

cp configtx-template.yaml configtx.yaml
sed -i "s|__MEMBERID__|$MEMBERID|g" ~/configtx.yaml
configtxgen -outputCreateChannelTx $CHANNEL.pb -profile OneOrgChannel -channelID $CHANNEL --configPath ~/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/home/ubuntu/managedblockchain-tls-chain.pem
export CORE_PEER_ADDRESS=$PEER
export CORE_PEER_LOCALMSPID=$MSP
export CORE_PEER_MSPCONFIGPATH=$MSP_PATH

peer channel create -c $CHANNEL -f /home/ubuntu/$CHANNEL.pb -o $ORDERER --cafile $CAFILE --tls --timeout 900s
peer channel join -b $CHANNEL.block  -o $ORDERER --cafile $CAFILE --tls

3. Install chaincode
export GOPATH=~/gopath/
peer chaincode install -n $CHAINCODENAME -v $CHAINCODEVERSION -p $CHAINCODEDIR

peer chaincode instantiate -o $ORDERER -C $CHANNEL \
    -n $CHAINCODENAME -v $CHAINCODEVERSION \
    -c '{"Args":["init","a","100","b","200"]}' --cafile $CAFILE --tls

peer chaincode invoke -o $ORDERER -C $CHANNEL -n $CHAINCODENAME \
    -c '{"Args":["invoke","a","b","10"]}' --cafile $CAFILE --tls

peer chaincode query -C $CHANNEL -n $CHAINCODENAME -c '{"Args":["query","a"]}'

