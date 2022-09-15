#!/bin/bash

CODE_SERVER_VERSION=3.12.0

docker run -d --name code-server -p 8080:8080 code-server:$CODE_SERVER_VERSION