HTTP_PROXY=http://192.168.105.2:7890
AUTHOR=davidliyutong
TAG=$(shell git describe --abbrev=0)

bootstrap:
	scripts/build/bootstrap.sh

build.base:
	export HTTP_PROXY=${HTTP_PROXY}; export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/base/build.sh

build.ie:
	export HTTP_PROXY=${HTTP_PROXY}; export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/ie/build.sh

build.math:
	export HTTP_PROXY=${HTTP_PROXY}; export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/math/build.sh

build.aio:
	export HTTP_PROXY=${HTTP_PROXY}; export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/aio/build.sh

build.all: build.base build.ie build.math build.aio

push.all:
	docker push ${AUTHOR}/code-server-speit:${TAG}-base
	docker push ${AUTHOR}/code-server-speit:${TAG}-ie
	docker push ${AUTHOR}/code-server-speit:${TAG}-math
	docker push ${AUTHOR}/code-server-speit:${TAG}-aio

	docker push ${AUTHOR}/code-server-speit:latest-base
	docker push ${AUTHOR}/code-server-speit:latest-ie
	docker push ${AUTHOR}/code-server-speit:latest-math
	docker push ${AUTHOR}/code-server-speit:latest-aio

