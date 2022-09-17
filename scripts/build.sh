#!/bin/bash

set -e
echo "Compressing home payload"
cd home
tar -cf - $(ls -a . | grep -v "^\.$" | grep -v "^\.\.$" | grep -v "home.tar") | pigz -9 -p 4 > home.tar.gz
mv home.tar.gz ../
cd ..
set +e

docker build -t code-server-ice3302p .