VERSION ?= development

TAG := $VERSION

run: build
	@docker run --rm -ti --privileged --name=btsync cusspvz/btsync:${TAG}

run-bash: build
	@docker run --rm -ti --privileged --name=btsync cusspvz/btsync:${TAG} bash

build:
	@docker build -t cusspvz/btsync:${TAG}  .

push: build
	@docker push cusspvz/openwrt:${TAG}

test: build
	# Initialize containers that will be tested
	@docker run --rm -d --privileged --name=btsync-1 cusspvz/btsync:${TAG} \
		bootstrap testing
	@docker run --rm -d --privileged --name=btsync-2 cusspvz/btsync:${TAG} \
		bootstrap testing

	# Initialize test container
	@docker run --rm -ri --privileged cusspvz/btsync:test btsync-1 btsync-2

	@docker kill btsync-1 btsync-2
	@docker rm btsync-1 btsync-2
