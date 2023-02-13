#!/bin/bash
# ./scripts/bootstrap.sh <arch> <version> <https://example.com/
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

if [[ ! -f "code-server.tar.gz" ]]; then
    echo "Downloading src tarball for $ARCH"
    wget https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-$ARCH.tar.gz -O code-server.tar.gz
else
    echo "code-server.tar.gz exists, skipping download"
fi

# Make up ./home directory
if [[ ! -d "home" ]]; then
    cp -a manifests/home/ home/

    # Download oh-my-zsh package
    # if [[ $# -gt 2 ]]; then
    #     OH_MY_ZSH_DOWNLOAD_URL=$3
    #     echo "Downloading oh-my-zsh package from $OH_MY_ZSH_DOWNLOAD_URL"
    # fi
    # if [[ -n "$OH_MY_ZSH_DOWNLOAD_URL" ]]; then
    #     wget $OH_MY_ZSH_DOWNLOAD_URL -O oh-my-zsh.tar
    #     tar -xf oh-my-zsh.tar -C ./home
    # fi
fi

# Build template render
# echo "Building render.go"
# go build ./scripts/render.go