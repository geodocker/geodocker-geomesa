BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
GEOMESA_VERSION := 1.3.0-m3-SNAPSHOT
DIST_TARBALL := tarballs/geomesa-accumulo-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz
RUNTIME := geomesa-accumulo-distributed-runtime_2.11-${GEOMESA_VERSION}.jar

build: ${RUNTIME}
	 docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                -t ${IMG}:latest .

${DIST_TARBALL}:
	(cd tarballs ;  cp ${HOME}/.m2/repository/org/locationtech/geomesa/geomesa-accumulo-dist_2.11/1.3.0-m3-SNAPSHOT/geomesa-accumulo-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz . )

${RUNTIME}: ${DIST_TARBALL}
	tar zxvf $<
	cp geomesa-accumulo_2.11-${GEOMESA_VERSION}/dist/accumulo/${RUNTIME} .

publish: build
	docker push ${IMG}:latest
	if [ "${TAG}" != "" -a "${TAG}" != "latest" ]; then docker tag ${IMG}:latest ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

test: build
	 docker-compose up -d
	 docker-compose run --rm accumulo-master bash -c "set -e \
                && source /sbin/accumulo-lib.sh \
                && wait_until_accumulo_is_available accumulo zookeeper \
                && accumulo shell -p GisPwd -e 'info'"
	docker-compose down

clean:
	rm -rf geomesa-accumulo_2.11-${GEOMESA_VERSION}/

cleaner: clean
	rm -f ${RUNTIME}

cleanest: cleaner
	rm -f ${DIST_TARBALL}
