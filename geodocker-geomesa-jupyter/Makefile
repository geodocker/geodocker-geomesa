BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build: vegas dockerfile
	docker build \
                --build-arg GEOMESA_VERSION=${GEOMESA_VERSION} \
                --build-arg TAG=${TAG} \
                --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
		-f target/Dockerfile \
                -t ${IMG}:${TAG} .

dockerfile:
	mkdir -p target
	sed 's/__TAG__/'"${TAG}"'/' Dockerfile.template > target/Dockerfile


ivy-2.3.0.jar: 
	curl -L -O 'http://search.maven.org/remotecontent?filepath=org/apache/ivy/ivy/2.3.0/ivy-2.3.0.jar'

vegas: ivy-2.3.0.jar
	java -jar ivy-2.3.0.jar -dependency org.vegas-viz vegas-spark_2.11 0.3.6 -retrieve "lib/[artifact]-[revision](-[classifier]).[ext]"

publish: build
	docker push ${IMG}:${TAG}

clean:
	rm -rf ivy-2.3.0.jar
	rm -rf lib
