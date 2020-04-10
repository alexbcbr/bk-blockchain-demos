#!/bin/sh
# Delete QLDB with data

echo "*********** QLDB DEPLOYMENT **********"
aws qldb update-ledger --name students-exam --no-deletion-protection
aws qldb delete-ledger --name students-exam
echo "\n********************** END **********************"
