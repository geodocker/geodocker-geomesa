BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build: dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg TAG=${TAG} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
		-f target/Dockerfile \
                -t ${IMG}:${TAG}	.

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile


publish: build
	docker push ${IMG}:${TAG}

test: build
	docker run -it --rm ${IMG}:${TAG} bash -c "zkServer.sh start; zkCli.sh stat /zookeeper"
