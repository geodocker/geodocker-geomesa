BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geomesa
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build: vegas
	echo ${BASE} \
        && echo ${REPO} \
	&& echo ${IMG} \
	&& docker build -t ${IMG}:latest .


ivy-2.3.0.jar: 
	curl -L -O 'http://search.maven.org/remotecontent?filepath=org/apache/ivy/ivy/2.3.0/ivy-2.3.0.jar'

vegas: ivy-2.3.0.jar
	java -jar ivy-2.3.0.jar -dependency org.vegas-viz vegas-spark_2.11 0.3.6 -retrieve "lib/[artifact]-[revision](-[classifier]).[ext]"

publish: build
	docker push ${IMG}:latest
	if [ "${TAG}" != "" -a "${TAG}" != "latest" ]; then docker tag ${IMG}:latest ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

clean:
	rm -rf ivy-2.3.0.jar
	rm -rf lib
