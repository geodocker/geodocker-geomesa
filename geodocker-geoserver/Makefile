BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
GEOMESA_ACCUMULO_TARBALL := geomesa-accumulo-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz
GEOMESA_ACCUMULO_GS_INSTALL := geomesa-accumulo-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz
GEOMESA_KAFKA_TARBALL := geomesa-kafka-${KAFKA_VERSION}-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz
GEOMESA_KAFKA_GS_INSTALL := geomesa-kafka-${KAFKA_VERSION}-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz
KAFKA_TAG := ${TAG}-kafka-${KAFKA_VERSION}

build: ${GEOMESA_ACCUMULO_GS_INSTALL} ${GEOMESA_KAFKA_GS_INSTALL} dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg TAG=${TAG} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
                --build-arg THRIFT_VERSION=${THRIFT_VERSION} \
                --build-arg KAFKA_VERSION=${KAFKA_VERSION} \
		-f target/Dockerfile \
                -t ${IMG}:${KAFKA_TAG} .

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile


.cache/${GEOMESA_ACCUMULO_TARBALL}:
	mkdir -p .cache \
          && cp ${HOME}/.m2/repository/org/locationtech/geomesa/geomesa-accumulo-dist_2.11/${GEOMESA_VERSION}/${GEOMESA_ACCUMULO_TARBALL} .cache

${GEOMESA_ACCUMULO_GS_INSTALL}: .cache/${GEOMESA_ACCUMULO_TARBALL}
	tar -zx --strip-components=3 \
          -f .cache/${GEOMESA_ACCUMULO_TARBALL} \
	geomesa-accumulo_2.11-${GEOMESA_VERSION}/dist/gs-plugins/${GEOMESA_ACCUMULO_GS_INSTALL}
	@touch -am ${GEOMESA_ACCUMULO_GS_INSTALL}

.cache/${GEOMESA_KAFKA_TARBALL}:
	mkdir -p .cache \
          && cp ${HOME}/.m2/repository/org/locationtech/geomesa/geomesa-kafka-${KAFKA_VERSION}-dist_2.11/${GEOMESA_VERSION}/${GEOMESA_KAFKA_TARBALL} .cache

${GEOMESA_KAFKA_GS_INSTALL}: .cache/${GEOMESA_KAFKA_TARBALL}
	tar -zx --strip-components=3 \
          -f .cache/${GEOMESA_KAFKA_TARBALL} \
	geomesa-kafka-${KAFKA_VERSION}_2.11-${GEOMESA_VERSION}/dist/gs-plugins/${GEOMESA_KAFKA_GS_INSTALL}
	@touch -am ${GEOMESA_ACCUMULO_GS_INSTALL}

publish: build
	docker push ${IMG}:${KAFKA_TAG}

clean:
	rm -rf .cache
	rm -rf ${GEOMESA_ACCUMULO_GS_INSTALL}
