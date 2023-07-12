#!/bin/bash
AUTHOR=davidliyutong
if [[ $# -lt 1 ]]; then
    TAG=$(git describe --abbrev=0) # default architecture amd64
else
    TAG=$1
fi
echo "TAG: $TAG"

# Prepare home.tar.gz
PATH_OF_HOME=build/home/
set -e
mkdir -p .cache
echo "Updating home payload"
rsync -a manifests/home/ $PATH_OF_HOME
echo "Compressing home payload"
tar -cf - -C $PATH_OF_HOME . | pv -s $(du -sb $PATH_OF_HOME | awk '{print $1}') | xz -9 -T 4 -k -z > .cache/home.tar.xz
set +e

# Docker Build
docker build --build-arg HTTP_PROXY=http://192.168.105.2:7890 -t $AUTHOR/code-server-speit:$TAG .