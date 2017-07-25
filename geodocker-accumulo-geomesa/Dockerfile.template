FROM quay.io/geomesa/accumulo:__TAG__

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ARG GEOMESA_VERSION
ENV GEOMESA_VERSION ${GEOMESA_VERSION}
ENV GEOMESA_DIST /opt/geomesa
ENV GEOMESA_RUNTIME ${GEOMESA_DIST}/accumulo
ENV GEOMESA_HOME ${GEOMESA_DIST}
ENV PATH="${PATH}:${GEOMESA_HOME}/bin"

ADD geomesa-accumulo_2.11-${GEOMESA_VERSION} ${GEOMESA_HOME}
ADD geomesa-accumulo-distributed-runtime_2.11-${GEOMESA_VERSION}.jar ${ACCUMULO_HOME}/lib/ext/

RUN set -x \
  && (echo yes | ${GEOMESA_DIST}/bin/install-jai.sh) \
  && (echo yes | ${GEOMESA_DIST}/bin/install-jline.sh)

COPY ./fs /
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
