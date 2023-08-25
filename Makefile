HTTP_PROXY=http://192.168.105.2:7890
AUTHOR=davidliyutong

bootstrap:
	scripts/build/bootstrap.sh

build.base:
	export HTTP_PROXY=${HTTP_PROXY}; scripts/build/base/build.sh

build.ie:
	export HTTP_PROXY=${HTTP_PROXY}; scripts/build/ie/build.sh

build.math:
	export HTTP_PROXY=${HTTP_PROXY}; scripts/build/math/build.sh