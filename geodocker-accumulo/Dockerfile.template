FROM quay.io/geomesa/hdfs:__TAG__

MAINTAINER Pomadchin Grigory <daunnc@gmail.com>

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ENV ACCUMULO_VERSION ${ACCUMULO_VERSION}
ENV ACCUMULO_HOME /opt/accumulo
ENV ACCUMULO_CONF_DIR $ACCUMULO_HOME/conf
ENV ZOOKEEPER_HOME /usr/lib/zookeeper
ENV PATH=$PATH:$ACCUMULO_HOME/bin

ADD accumulo-${ACCUMULO_VERSION}-bin.tar.gz /opt

# Accumulo and Zookeeper client
RUN set -x \
  && mv /opt/accumulo-${ACCUMULO_VERSION} ${ACCUMULO_HOME} \
  && yum install -y make gcc-c++ \
  && bash -c "${ACCUMULO_HOME}/bin/build_native_library.sh" \
  && yum -y autoremove gcc-c++
  # TODO: Clean up after build_native_library

WORKDIR "${ACCUMULO_HOME}"
COPY ./fs /
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
