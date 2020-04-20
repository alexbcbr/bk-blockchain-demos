#!/bin/bash

# List all donations in Hyperledger fabric and upload it in datalake for future analysis

export FABRIC_CFG_PATH="/home/ubuntu/"
export FABRIC_LOGGING_SPEC="ERROR"

cd ~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric
source init.sh

figlet 'Invoking Chaincode'
peer chaincode query -C mychannel -n health -c '{"Args":["queryAllDonations"]}' > all-donations.json
cat all-donations.json
aws s3 cp all-donations.json s3://alexbc.healthcare/blood-donation/ &> /dev/null
rm all-donations.json