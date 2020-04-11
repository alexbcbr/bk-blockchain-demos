#!/bin/bash

echo 'Setting environment varible in the sheel to invoke fabric remotely'

source fabric-exports.sh
source ~/peer-exports.sh

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/home/ubuntu/managedblockchain-tls-chain.pem
export CORE_PEER_ADDRESS=$PEER
export CORE_PEER_LOCALMSPID=$MSP
export CORE_PEER_MSPCONFIGPATH=$MSP_PATH

echo '*** Environment ready'