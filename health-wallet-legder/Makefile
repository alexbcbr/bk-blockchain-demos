install:
	figlet "QLDB DEPLOYMENT"
	aws qldb create-ledger --name health-wallet-ledger --permissions-mode ALLOW_ALL

data-load:
	/usr/local/bin/python3 load_document_table.py

list:
	/usr/local/bin/python3 scan_table.py

unittest:
	/usr/local/bin/python3 -m unittest discover 

clean:
	aws qldb update-ledger --name health-wallet-ledger --no-deletion-protection
	aws qldb delete-ledger --name health-wallet-ledger