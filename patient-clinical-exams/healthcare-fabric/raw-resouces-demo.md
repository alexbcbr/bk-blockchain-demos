# Deploy and Test Chaincode

## Step 0 - Set the environment

Set the environment variable only when you reconnect the shell

```
cd bk-blockchain-demos/patient-clinical-exams/healthcare-fabric
source init.sh
```

When you Invoke and query transactions, you cat set the log level 
(FATAL | PANIC | ERROR | WARNING | INFO | DEBUG)

```
export FABRIC_LOGGING_SPEC=ERROR
```

## Step 1 - Install, instantiate and invoke chaincode
Install the chaincode in GO.

```
peer channel list

export GOPATH=~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric/

peer chaincode install -n rawresources -v 1.0 -p rawresources/go

peer chaincode instantiate -o $ORDERER -C $CHANNEL -n rawresources -v 1.0 -c '{"Args":[]}' --cafile $CAFILE --tls
```

## Step 2 - Run the code

```
peer chaincode invoke -o $ORDERER -C $CHANNEL -n rawresources -c '{"Args":["index","0","10000"]}' --cafile $CAFILE --tls

peer chaincode invoke -o $ORDERER -C $CHANNEL -n rawresources -c '{"Args":["store","{\"id\": 1, \"name\": \"Iron\", \"weight\": 10}"]}' --cafile $CAFILE --tls

peer chaincode query -C $CHANNEL -n rawresources -c '{"Args":["index","0","10000"]}'

```

## Step 3 - Update code with a new version
```

peer chaincode install -n rawresources -v 1.1 -p rawresources/go

peer chaincode upgrade -o $ORDERER -C $CHANNEL -n rawresources -v 1.1 -c '{"Args":[]}' --cafile $CAFILE --tls
```