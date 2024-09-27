docker pull core.harbor.speit.site/kathara/base
docker pull core.harbor.speit.site/kathara/frr
docker pull core.harbor.speit.site/kathara/quagga

docker tag core.harbor.speit.site/kathara/base kathara/base
docker tag core.harbor.speit.site/kathara/frr kathara/frr
docker tag core.harbor.speit.site/kathara/quagga kathara/quagga

docker plugin install --grant-all-permissions --alias kathara/katharanp:amd64 core.harbor.speit.site/kathara/katharanp:amd64
docker plugin install --grant-all-permissions --alias kathara/katharanp_vde:amd64 core.harbor.speit.site/kathara/katharanp_vde:amd64