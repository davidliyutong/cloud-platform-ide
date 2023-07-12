#!/bin/zsh
microk8s.kubectl exec -n students $1 -it -- /bin/zsh