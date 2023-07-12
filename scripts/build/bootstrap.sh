#!/bin/bash
# ./scripts/bootstrap.sh <arch> <version>
# Choose an architecture
if [[ $# -lt 1 ]]; then
    ARCH=amd64 # default architecture amd64
else
    ARCH=$1
fi
echo "ARCH: $ARCH"

# Download the code-server
if [[ $# -gt 1 ]]; then
    VERSION=$2
else
    VERSION=""
fi
if [[ ! -n $VERSION ]]; then
    VERSION=$(curl -sL https://api.github.com/repos/cdr/code-server/releases/latest | jq -r ".tag_name")
    VERSION=${VERSION:1} # Remove character 'v'
fi
echo "VERSION: $VERSION"

DOWNLOAD_DESTINATION=".cache/code-server.tar.gz"
if [[ ! -f $DOWNLOAD_DESTINATION ]]; then
    echo "Downloading src tarball for $ARCH"
    wget https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-$ARCH.tar.gz -O $DOWNLOAD_DESTINATION
else
    echo "$DOWNLOAD_DESTINATION exists, skipping download"
fi

# Build template render if go exists. Output directory is build/
if [[ -x "$(command -v go)" ]]; then
    mkdir -p build
    echo "Building render.go"
    go build ./scripts/crd/render.go
    mv render build/

fi

# Make up ./home directory
if [[ ! -d "build/home" ]]; then
    mkdir -p build/home
fi