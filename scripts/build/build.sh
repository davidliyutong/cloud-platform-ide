#!/bin/bash
AUTHOR=davidliyutong
if [[ $# -lt 1 ]]; then
    TAG=$(git describe --abbrev=0) # default architecture amd64
else
    TAG=$1
fi
echo "TAG: $TAG"

# Prepare home.tar.gz
set -e
mkdir -p .cache
rsync -a manifests/home/ home/
echo "Compressing home payload"
tar -cf - -C home . | pv -s $(du -sb home | awk '{print $1}') | pigz -9 -p 4 > .cache/home.tar.gz
set +e

# Docker Build
docker build --build-arg HTTP_PROXY=http://192.168.105.2:7890 -t $AUTHOR/code-server-speit:$TAG .