export GOPATH=~/bk-blockchain-demos/patient-clinical-exams/healthcare-fabric/src
export GOPATH=~/non-profit-blockchain/ngo-chaincode/src

peer chaincode install -n ngo -l node -v 1.0 -p $GOPATH

peer chaincode instantiate -o $ORDERER -C $CHANNEL -n ngo -v 1.0 -c '{"Args":["init"]}' --cafile $CAFILE --tls


=====================
export FABRICUSER=$ADMINUSER-msp
export FABRICUSERPASSWORD=$ADMINPWD
export CERTS_FOLDER=~/admin-msp

aws secretsmanager create-secret --name "dev/fabricOrgs/$MEMBERNAME/$FABRICUSER/pk" --secret-string "`cat $CERTS_FOLDER/$FABRICUSER/keystore/*`" --region $REGION

aws secretsmanager create-secret --name "dev/fabricOrgs/$MEMBERNAME/$FABRICUSER/signcert" --secret-string "`cat $CERTS_FOLDER/$FABRICUSER/signcerts/*`" --region $REGION

