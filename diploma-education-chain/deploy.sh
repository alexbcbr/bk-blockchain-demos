#!/bin/sh
# Deploy QLDB with data
# deploy.sh - Deploy ledger database with data
#
# Revisions:
# Versao 1.0 - First version for MacOSX and Linux

echo "******************** QLDB DEPLOYMENT **************"
aws qldb create-ledger --name students-exam --permissions-mode ALLOW_ALL
echo "\n********************** END **********************"
