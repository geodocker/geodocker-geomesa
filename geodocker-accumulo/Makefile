BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build: accumulo-${ACCUMULO_VERSION}-bin.tar.gz
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg TAG=${TAG} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
		-t ${IMG}:${TAG} .

accumulo-${ACCUMULO_VERSION}-bin.tar.gz:
	curl -L -C - -O "http://apache.mirrors.pair.com/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz"

publish: build
	docker push ${IMG}:${TAG}
	if [ "${TAG}" != "" -a "${TAG}" != "latest" ]; then docker tag ${IMG}:latest ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

clean:

cleaner: clean

cleanest: cleaner
	rm -f accumulo-*-bin.tar.gz
