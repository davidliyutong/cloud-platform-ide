#!/bin/bash
# read from env, with default
IMAGE_MIRROR=${IMAGE_MIRROR:-core.harbor.speit.site}

KATHARA_TAG=latest
KATHARA_IMAGES="kathara/base kathara/frr kathara/quagga"

for image in $KATHARA_IMAGES; do
    if [[ -z $(docker images -q $image:$KATHARA_TAG) ]]; then
        echo "Pulling $image:$KATHARA_TAG"
        docker pull $IMAGE_MIRROR/$image:$KATHARA_TAG
        docker tag $IMAGE_MIRROR/$image:$KATHARA_TAG $image:$KATHARA_TAG
    fi
done

KATHARA_PLUGIN_IMAGES="kathara/katharanp kathara/katharanp_vde"
KATHARA_PLUGIN_TAG=amd64
for image in $KATHARA_PLUGIN_IMAGES; do
    docker plugin install --grant-all-permissions --alias $image:$KATHARA_PLUGIN_TAG $IMAGE_MIRROR/$image:$KATHARA_PLUGIN_TAG
done