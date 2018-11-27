BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
GEOMESA_VERSION := 2.1.0
ACCUMULO_VERSION := 1.9.2
THRIFT_VERSION := 0.9.3
TAG := geomesa-${GEOMESA_VERSION}-accumulo-${ACCUMULO_VERSION}

build: dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
                --build-arg THRIFT_VERSION=${THRIFT_VERSION} \
		-f target/Dockerfile \
                -t ${IMG}:${TAG} .

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile

publish: build
	docker push ${IMG}:${TAG}

clean:
	rm -rf .cache
	rm -rf ${GEOMESA_ACCUMULO_GS_INSTALL}
	rm -rf ${GEOMESA_KAFKA_GS_INSTALL}
