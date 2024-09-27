#!/bin/bash
if [[ -z $AUTHOR ]]; then
    AUTHOR=davidliyutong
fi
echo "AUTHOR: $AUTHOR"

if [[ -z $TAG ]]; then
    TAG=$(git describe --abbrev=0)-kathara
    # default architecture amd64
fi
echo "TAG: $TAG"

echo "HTTP_PROXY: $HTTP_PROXY"

# Prepare home.tar.gz
PATH_OF_HOME=build/home/kathara
set -e
mkdir -p .cache
mkdir -p $PATH_OF_HOME
echo "Updating home payload"
rsync -a manifests/home/kathara/ $PATH_OF_HOME
echo "Compressing home payload"
tar -cf - -C $PATH_OF_HOME . | pv -s $(du -sb $PATH_OF_HOME | awk '{print $1}') | xz -9 -T 4 -k -z > .cache/home.kathara.tar.xz
set +e

# Docker Build
docker build --build-arg HTTP_PROXY=$HTTP_PROXY -t $AUTHOR/code-server-speit:$TAG-kathara -f manifests/docker/kathara/Dockerfile .
docker tag $AUTHOR/code-server-speit:$TAG-kathara $AUTHOR/code-server-speit:latest-kathara