#!/bin/bash

# Choose an architecture
if [ $# -lt 1 ]; then
    ARCH=amd64 # default architecture amd64
else
    ARCH=$1
fi
echo "Downloading src tarball for $ARCH"

# Download the code-server
if [ $# -gt 1 ]; then
    VERSION=$2
fi
if [ ! -z $VERSION ]; then
VERSION=$(curl -sL https://api.github.com/repos/cdr/code-server/releases/latest | jq -r ".tag_name")
VERSION=${VERSION:1} # Remove character 'v'
fi
if [ ! -f "code-server.tar.gz"]; then
echo "Downloading src tarball for $ARCH"
wget https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-$ARCH.tar.gz -O code-server.tar.gz
fi

# Make up ./home directory
if [ ! -d "home"]; then
    mkdir -p home/.config/code-server
    echo "bind-addr: 0.0.0.0:8080\nauth: password\npassword: changeme\ncert: false" > home/.config/code-server/config.yaml
    touch home/.config/code-server/CONFIGURED

    # Download oh-my-zsh package
    if [ $# -gt 2 ]; then
        OH_MY_ZSH_DOWNLOAD_URL=$3
    fi
    if [ -z $OH_MY_ZSH_DOWNLOAD_URL ]
        wget $OH_MY_ZSH_DOWNLOAD_URL -O oh-my-zsh.tar
        tar -xf oh-my-zsh.tar -C ./home
    fi
fi

# Build template render
go build ./scripts/render.go