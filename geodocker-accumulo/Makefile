BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
ACCUMULO_VERSION := 1.8.0

build: accumulo-${ACCUMULO_VERSION}-bin.tar.gz
	docker build \
		--build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
		-t ${IMG}:latest .

accumulo-${ACCUMULO_VERSION}-bin.tar.gz:
	curl -L -C - -O "http://apache.mirrors.pair.com/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz"

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

cleaner: clean

cleanest: cleaner
	rm -f accumulo-${ACCUMULO_VERSION}-bin.tar.gz
