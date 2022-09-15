#!/bin/bash

set -e
cd home
tar -cf home.tar .config .oh-my-zsh .zshrc
mv home.tar ../
cd ..
set +e

docker build -t code-server-ice3302p .