#!/usr/bin/env bash

DEFAULT_PASSWORD=speit
DEFAULT_CONFIG_PATH=/root/.config/code-server/config.yaml
KUBECTL_EXEC=microk8s.kubectl
TARGET_NAMESPACE=students
TARGET_PODS=$($KUBECTL_EXEC top pods -A | grep $TARGET_NAMESPACE | awk '{print $2}')

for pod in $TARGET_PODS;
do
	password_unchanged=$($KUBECTL_EXEC exec -n $TARGET_NAMESPACE $pod -- /bin/zsh -c "cat $DEFAULT_CONFIG_PATH" | grep "password: $DEFAULT_PASSWORD$")
	if  test -n "$password_unchanged"; then
    	echo $pod
	fi
done
