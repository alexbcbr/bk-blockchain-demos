# Part 2: Install NodeJS chaincode NGO on Hyperledger Fabric

The chaincode in ngo.js supports donors donating funds to an NGO (i.e. non-profit), while tracking 
the spending of those funds and the allocation of the spending records against each donation. Donors
are therefore able to track how their donations are being spent. The Fabric Chaincode is written in Node.js.

## Pre-requisites
 There are multiple parts to this demo.  Before starting on Part 3, you should have completed [Part 1](../patient-clinical-exams/README.md)

 cd ~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric
 source init.sh

## Step 1 Install NodeJS chaincode
You can install a new version of chaincode 

```
export GOPATH=~/bk-blockchain-demos/health-chaincode/src

peer chaincode install -n health -l node -v 1.0 -p $GOPATH
````
and then instantiate or upgrade the chaincode

```
peer chaincode instantiate -o $ORDERER -C $CHANNEL -n health -v 1.0 -c '{"Args":["init"]}' --cafile $CAFILE --tls
```

OR upgrade the chaincode

```
peer chaincode upgrade -o $ORDERER -C $CHANNEL -n health -v 2.0 -c '{"Args":["init"]}' --cafile $CAFILE --tls
```

## Step 2 Test chaincode

peer chaincode invoke -C $CHANNEL -n health \
    -c  '{"Args":["createPatient","{\"donorUserName\": \"John\", \"exam\": \"001\", \"substance\": \"XPTO\", \"registeredDate\": \"2018-10-22T11:52:20.182Z\"}"]}' -o $ORDERER --cafile $CAFILE --tls

peer chaincode query -C mychannel -n health -c '{"Args":["queryAllPatients"]}'

peer chaincode query -C mychannel -n health -c '{"Args":["queryPatient","{\"donorUserName\": \"edge\"}"]}'

peer chaincode query -C mychannel -n health -c '{"Args":["queryPatient","{\"donorUserName\": \"99ALEX88\"}"]}'

peer chaincode query -C mychannel -n health -c '{"Args":["queryHistoryForKey","{\"Key\": \"donoredge\"}"]}'

## Step 4 Run Lambda functions

export FABRICUSER=$ADMINUSER-msp
export FABRICUSERPASSWORD=$ADMINPWD
export CERTS_FOLDER=~/admin-msp

export BUCKETNAME=`echo "ngo-fabric-lambda-$(date +%N)" | tr '[:upper:]' '[:lower:]'`
export LAMBDANAME=`echo "$NETWORKNAME-fabric-lambda" | tr '[:upper:]' '[:lower:]'`

Change the property in the lambda code from `ngo` to `health`

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"invoke\",\"chaincodeFunction\":\"createPatient\",\"chaincodeFunctionArgs\":{\"donorUserName\":\"sueli\",\"email\":\"sueli@melissasngo.org\"}}" --region $REGION /tmp/lambda-output-createDonor.txt

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"queryObject\",\"chaincodeFunction\":\"queryPatient\",\"chaincodeFunctionArgs\":{\"donorUserName\":\"sueli\"}}" --region $REGION /tmp/lambda-output-queryDonor.txt
cat /tmp/lambda-output-queryDonor.txt

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"queryObject\",\"chaincodeFunction\":\"queryAllPatients\",\"chaincodeFunctionArgs\":{}}" --region $REGION /tmp/lambda-output-queryAllDonors.txt

cat /tmp/lambda-output-queryAllDonors.txt

