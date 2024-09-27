AUTHOR:=davidliyutong
TAG=$(shell git describe --abbrev=0)

bootstrap:
	scripts/build/bootstrap.sh

build.base:
	export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/base/build.sh

build.ie:
	export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/ie/build.sh

build.math:
	export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/math/build.sh

build.aio:
	export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/aio/build.sh

build.kathara:
	export AUTHOR=${AUTHOR}; export TAG=${TAG}; scripts/build/kathara/build.sh

build.all: build.base build.ie build.math build.aio build.kathara

push.all:
	docker push ${AUTHOR}/code-server-speit:${TAG}-base
	docker push ${AUTHOR}/code-server-speit:${TAG}-ie
	docker push ${AUTHOR}/code-server-speit:${TAG}-math
	docker push ${AUTHOR}/code-server-speit:${TAG}-aio

	docker push ${AUTHOR}/code-server-speit:latest-base
	docker push ${AUTHOR}/code-server-speit:latest-ie
	docker push ${AUTHOR}/code-server-speit:latest-math
	docker push ${AUTHOR}/code-server-speit:latest-aio

