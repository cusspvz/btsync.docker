VERSION ?= development
TAG := ${VERSION}

TEST_CONTAINERS := 4
TEST_NAMESPACE := testing

run: build
	@docker run --rm -ti --privileged --name=btsync cusspvz/btsync:${TAG}

run-bootstrap: build
	@echo "Starting container cusspvz/btsync:${TAG}";
	@docker run --rm -ti --privileged cusspvz/btsync:${TAG} bootstrap A22QYMGFPY3EVHZY2OWU6HR3ZLXEZBT54 default

run-bash: build
	@docker run --rm -ti --privileged --name=btsync cusspvz/btsync:${TAG} bash

build:
	@echo "Building image cusspvz/btsync:${TAG}";
	@docker build -t cusspvz/btsync:${TAG}  .

push: build
	@docker push cusspvz/openwrt:${TAG}

build-test-suite:
	@docker build -t cusspvz/btsync:test-suite test/

test: build build-test-suite
	@\
	SECRET=$$(docker run --rm -ti --entrypoint=/bin/bash cusspvz/btsync:${TAG} -c "btsync --generate-secret" | tr -cd '[[:alnum:]]._-'); \
	echo "Generated a secret for this tests: $$SECRET"; \
	LINKS=""; \
	for i in `seq 1 ${TEST_CONTAINERS}`; do \
		echo "Starting $$i testee container cusspvz/btsync:${TAG}"; \
		docker run -d --privileged --name=btsync-$$i cusspvz/btsync:${TAG} bootstrap $$SECRET ${TEST_NAMESPACE}; \
		LINKS="$$LINKS -l btsync-$$i:btsync-$$i"; \
	done; \
	echo "Starting test container"; \
	docker run --rm -ti --privileged \
		--name "test-suite" \
		$$LINKS \
		-e NAMESPACE=${TEST_NAMESPACE} \
		-e SECRET=$$SECRET \
		cusspvz/btsync:test-suite ; \
	for i in `seq 1 ${TEST_CONTAINERS}`; do \
		echo "Removing $$i testee container"; \
		docker kill btsync-$$i > /dev/null; \
		docker rm --force btsync-$$i; \
	done;
