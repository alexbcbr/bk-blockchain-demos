# Part 2: Install NodeJS chaincode NGO on Hyperledger Fabric

The chaincode in ngo.js supports donors donating funds to an NGO (i.e. non-profit), while tracking 
the spending of those funds and the allocation of the spending records against each donation. Donors
are therefore able to track how their donations are being spent. The Fabric Chaincode is written in Node.js.

## Pre-requisites
 There are multiple parts to this demo.  Before starting on Part 3, you should have completed [Part 1](../patient-clinical-exams/README.md)

cd ~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric
source init.sh

## Step 1 Install NodeJS chaincode

export GOPATH=~/bk-blockchain-demos/ngo-chaincode/src

peer chaincode install -n ngo -l node -v 10.0 -p $GOPATH

peer chaincode instantiate -o $ORDERER -C $CHANNEL -n ngo -v 5.0 -c '{"Args":["init"]}' --cafile $CAFILE --tls

OR

peer chaincode upgrade -o $ORDERER -C $CHANNEL -n ngo -v 10.0 -c '{"Args":["init"]}' --cafile $CAFILE --tls

## Step 2 Test chaincode

peer chaincode invoke -C $CHANNEL -n ngo \
    -c  '{"Args":["createDonor","{\"donorUserName\": \"edge\", \"email\": \"edge@def.com\", \"registeredDate\": \"2018-10-22T11:52:20.182Z\"}"]}' -o $ORDERER --cafile $CAFILE --tls

peer chaincode invoke -C mychannel -n ngo \
    -c  '{"Args":["createDonor","{\"donorUserName\": \"sue\", \"email\": \"sueolis@def.com\", \"registeredDate\": \"2018-11-05T14:31:20.182Z\"}"]}' -o $ORDERER --cafile $CAFILE --tls

peer chaincode query -C mychannel -n ngo -c '{"Args":["queryAllDonors"]}'
