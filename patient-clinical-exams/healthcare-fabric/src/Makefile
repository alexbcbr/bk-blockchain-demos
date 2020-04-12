install:
	go get -u \
		github.com/hyperledger/fabric/core/chaincode/shim \
		github.com/hyperledger/fabric/protos/peer

clean:
	sudo rm -rf state
	sudo rm -rf chaincode/github.com

blockchain:
	echo "2020-04-12 18:01:55.756 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable"
	echo "2020-04-12 18:01:55.760 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable"
	figlet -f big 'Happy Easter Bev and Jeff' 

build:
	go build -o bin/main main.go

run:
	go run main.go

compile-OtherPlatforms:
	echo "Compiling for every OS and Platform"
	GOOS=linux GOARCH=arm go build -o bin/main-linux-arm main.go
	GOOS=linux GOARCH=arm64 go build -o bin/main-linux-arm64 main.go
	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go

all: hello build run
