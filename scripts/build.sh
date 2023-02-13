#!/bin/bash
if [[ $# -lt 1 ]]; then
    TAG=$(git describe --abbrev=0) # default architecture amd64
else
    TAG=$1
fi

rsync -a manifests/home/ home/
set -e
echo "Compressing home payload"
cd home
tar -cf - $(ls -a . | grep -v "^\.$" | grep -v "^\.\.$" | grep -v "home.tar") | pigz -9 -p 4 > home.tar.gz
mv home.tar.gz ../
cd ..
set +e

docker build -t code-server-speit:$TAG .