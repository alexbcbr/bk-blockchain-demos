#!/bin/bash

git config --global user.name "fabric-developer"
git config --global user.email fabric@abcgov.com.br
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/bk-blockchain-demos
