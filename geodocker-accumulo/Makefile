BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build: accumulo-${ACCUMULO_VERSION}-bin.tar.gz dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg TAG=${TAG} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
		-f target/Dockerfile \
		-t ${IMG}:${TAG} .

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile


accumulo-${ACCUMULO_VERSION}-bin.tar.gz:
	curl -L -C - -O "http://apache.mirrors.lucidnetworks.net/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz"

publish: build
	docker push ${IMG}:${TAG}

clean:

cleaner: clean

cleanest: cleaner
	rm -f accumulo-*-bin.tar.gz
