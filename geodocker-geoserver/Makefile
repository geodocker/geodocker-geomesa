BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
GEOMESA_VERSION := 2.2.1
ACCUMULO_VERSION := 1.9.2
THRIFT_VERSION := 0.9.3
TAG := geomesa-${GEOMESA_VERSION}-accumulo-${ACCUMULO_VERSION}
GEOMESA_ACCUMULO_TARBALL := geomesa-accumulo-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz
GEOMESA_ACCUMULO_GS_INSTALL := geomesa-accumulo-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz
GEOMESA_KAFKA_TARBALL := geomesa-kafka-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz
GEOMESA_KAFKA_GS_INSTALL := geomesa-kafka-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz

build: tarball dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
                --build-arg THRIFT_VERSION=${THRIFT_VERSION} \
		-f target/Dockerfile \
                -t ${IMG}:${TAG} .

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile

tarball:
	mkdir -p tarballs
	cp ${HOME}/.m2/repository/org/locationtech/geomesa/geomesa-accumulo-dist_2.11/${GEOMESA_VERSION}/${GEOMESA_ACCUMULO_TARBALL} tarballs/.
	cp ${HOME}/.m2/repository/org/locationtech/geomesa/geomesa-kafka-dist_2.11/${GEOMESA_VERSION}/${GEOMESA_KAFKA_TARBALL} tarballs/.

publish: build
	docker push ${IMG}:${TAG}

clean:
	rm -rf tarballs
