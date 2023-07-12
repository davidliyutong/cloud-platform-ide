#!/bin/bash

# 默认值
ID=""
CODE_HOSTNAME=""
VNC_HOSTNAME=""
CODE_TLS_SECRET=""
VNC_TLS_SECRET=""
IMAGE_REF=""

# 解析命令行参数
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -i|--id) ID="$2"; shift ;;
    -c|--code-hostname) CODE_HOSTNAME="$2"; shift ;;
    -v|--vnc-hostname) VNC_HOSTNAME="$2"; shift ;;
    -t|--code-tls-secret) CODE_TLS_SECRET="$2"; shift ;;
    -u|--vnc-tls-secret) VNC_TLS_SECRET="$2"; shift ;;
    -r|--image-ref) IMAGE_REF="$2"; shift ;;
    *) echo "无效的选项: $1" >&2; exit 1 ;;
  esac
  shift
done

# 将输入管道中的变量进行替换
while IFS= read -r line || [[ -n "$line" ]]; do
  line=$(echo "$line" | sed "s/\${{ ID }}/$(echo $ID | sed 's/\//\\\//g')/g")
  line=$(echo "$line" | sed "s/\${{ CODE_HOSTNAME }}/$(echo $CODE_HOSTNAME | sed 's/\//\\\//g')/g")
  line=$(echo "$line" | sed "s/\${{ VNC_HOSTNAME }}/$(echo $VNC_HOSTNAME | sed 's/\//\\\//g')/g")
  line=$(echo "$line" | sed "s/\${{ CODE_TLS_SECRET }}/$(echo $CODE_TLS_SECRET | sed 's/\//\\\//g')/g")
  line=$(echo "$line" | sed "s/\${{ VNC_TLS_SECRET }}/$(echo $VNC_TLS_SECRET | sed 's/\//\\\//g')/g")
  line=$(echo "$line" | sed "s/\${{ IMAGE_REF }}/$(echo $IMAGE_REF | sed 's/\//\\\//g')/g")
  echo "$line"
done