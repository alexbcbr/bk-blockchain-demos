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

```
peer chaincode invoke -C $CHANNEL -n health \
    -c  '{"Args":["recordBloodDonation","{\"donorUserName\": \"Jeff K\", \"volumeDonated\": \"13500\", \"bloodType\": \"O+\", \"registeredDate\": \"2020-04-22T10:52:20.182Z\"}"]}' -o $ORDERER --cafile $CAFILE --tls

peer chaincode query -C mychannel -n health -c '{"Args":["queryDonationByPatient","{\"donorUserName\": \"Alex BC\"}"]}'

```
Query the results

```

bk-blockchain-demos/health-chaincode/list-all-donations.sh 

peer chaincode query -C mychannel -n health -c '{"Args":["queryAllDonations"]}'

```

You can view JSON using https://jsonparseronline.com/ 


## Step 4 Run Lambda functions

```
export FABRICUSER=$ADMINUSER-msp
export FABRICUSERPASSWORD=$ADMINPWD
export CERTS_FOLDER=~/admin-msp

export BUCKETNAME=`echo "ngo-fabric-lambda-$(date +%N)" | tr '[:upper:]' '[:lower:]'`
export LAMBDANAME=`echo "$NETWORKNAME-fabric-lambda" | tr '[:upper:]' '[:lower:]'`

Change the property in the lambda code from `ngo` to `health`

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"invoke\",\"chaincodeFunction\":\"recordBloodDonation\",\"chaincodeFunctionArgs\":{\"donorUserName\":\"Sueli Coqueiro\",\"volumeDonated\":\"7800\"}}" --region $REGION lambda-output-createDonor.json

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"queryObject\",\"chaincodeFunction\":\"queryDonationByPatient\",\"chaincodeFunctionArgs\":{\"donorUserName\":\"Sueli Coqueiro\"}}" --region $REGION lambda-output-queryDonor.json

aws lambda invoke --function-name $LAMBDANAME --payload "{\"fabricUsername\":\"$FABRICUSER\",\"functionType\":\"queryObject\",\"chaincodeFunction\":\"queryAllDonations\",\"chaincodeFunctionArgs\":{}}" --region $REGION lambda-output-queryAllDonors.json
```


