#!/bin/bash

# download version
VERSION=$(curl -sL https://api.github.com/repos/microsoft/vscode-cpptools/releases/latest | jq -r ".tag_name")
VERSION=${VERSION:1} # Remove character 'v'
echo "VERSION: $VERSION"

# prepare download destination
DOWNLOAD_DESTINATION="$HOME/Downloads"
if [[ ! -d $DOWNLOAD_DESTINATION ]]; then
    echo "Creating $DOWNLOAD_DESTINATION"
    mkdir -p $DOWNLOAD_DESTINATION
fi

# check local file
DOWNLOAD_FILE="$DOWNLOAD_DESTINATION/cpptools.vsix"
if [[ -f $DOWNLOAD_FILE ]]; then
    echo "$DOWNLOAD_FILE exists, removing"
    rm $DOWNLOAD_FILE
fi

# download file
echo "Downloading VSIX file"
wget https://github.com/microsoft/vscode-cpptools/releases/download/v$VERSION/cpptools-linux.vsix -O $DOWNLOAD_FILE

echo "Downloaded to $DOWNLOAD_FILE, now select it in UI to install"