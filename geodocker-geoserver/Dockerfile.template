FROM centos:7
ARG GEOMESA_VERSION
COPY tarballs/geomesa-accumulo-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz accumulo-dist.tar.gz
RUN tar -zxf accumulo-dist.tar.gz

FROM centos:7
ARG GEOMESA_VERSION
COPY tarballs/geomesa-kafka-dist_2.11-${GEOMESA_VERSION}-bin.tar.gz kafka-dist.tar.gz
RUN tar -zxf kafka-dist.tar.gz

FROM quay.io/geomesa/base:__TAG__
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ENV ACCUMULO_VERSION ${ACCUMULO_VERSION}
ENV THRIFT_VERSION ${THRIFT_VERSION}
ENV HADOOP_VERSION 2.8.4
ENV GEOSERVER_VERSION 2.14.1
ENV TOMCAT_VERSION 8.5.23

# Install tomcat
RUN set -x \
  && mkdir -p /opt/tomcat/webapps/geoserver \
  && curl -sS  https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
  | tar -zx -C /opt/tomcat --strip-components=1

RUN set -x \
  && curl -sS -L -o /tmp/geoserver-war.zip \
    https://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip \
  && unzip /tmp/geoserver-war.zip geoserver.war -d /tmp \
  && unzip /tmp/geoserver.war -d /opt/tomcat/webapps/geoserver \
  && rm -rf /tmp/geoserver-war.zip /tmp/geoserver.war /opt/tomcat/webapps/geoserver/META-INF

# Install geoserver WPS plugin
RUN set -x \
  && curl -sS -L -o /tmp/geoserver-wps.zip \
    https://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip \
  && unzip -j /tmp/geoserver-wps.zip -d /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
  && rm -rf /tmp/geoserver-wps.zip

# Install Geomesa Accumulo Distribution
COPY --from=0 /geomesa-accumulo* /opt/geomesa/
  
# Install GeoMesa Accumulo DataStore
RUN set -x \
    && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
    && tar zxvf /opt/geomesa/dist/gs-plugins/geomesa-accumulo-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz

# Install GeoMesa Accumulo BlobStore
RUN set -x \
    && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
    && tar zxvf /opt/geomesa/dist/gs-plugins/geomesa-blobstore-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz

# Install GeoMesa Stream Store
RUN set -x \
    && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
    && tar zxvf /opt/geomesa/dist/gs-plugins/geomesa-stream-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz

# Install GeoMesa GeoJson Support
RUN set -x \
    && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
    && tar zxvf /opt/geomesa/dist/gs-plugins/geomesa-geojson-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz

# Install GeoMesa Process Jar
RUN set -x \
    && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
    && cp /opt/geomesa/dist/gs-plugins/geomesa-process-wps_2.11-${GEOMESA_VERSION}.jar .

# Install Hadoop and Accumulo specific jars
RUN set -x \
    && /opt/geomesa/bin/install-hadoop-accumulo.sh /opt/tomcat/webapps/geoserver/WEB-INF/lib -a ${ACCUMULO_VERSION} -h ${HADOOP_VERSION} -t ${THRIFT_VERSION}

# Install Geomesa Kafka Distribution
COPY --from=1 /geomesa-kafka* /opt/geomesa-kafka/

# Install GeoMesa Kafka DataStore
RUN set -x \
  && cd /opt/tomcat/webapps/geoserver/WEB-INF/lib/ \
  && tar zxvf /opt/geomesa-kafka/dist/gs-plugins/geomesa-kafka-gs-plugin_2.11-${GEOMESA_VERSION}-install.tar.gz \
  && rm /opt/tomcat/webapps/geoserver/WEB-INF/lib/zookeeper*.jar \
  && /opt/geomesa-kafka/bin/install-kafka.sh /opt/tomcat/webapps/geoserver/WEB-INF/lib


FROM quay.io/geomesa/base:__TAG__

ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ENV ACCUMULO_VERSION ${ACCUMULO_VERSION}
ENV GEOMESA_VERSION ${GEOMESA_VERSION}
ENV THRIFT_VERSION ${THRIFT_VERSION}
ENV HADOOP_VERSION 2.8.4
ENV GEOSERVER_VERSION 2.14.1
ENV TOMCAT_VERSION 8.5.23
ENV CATALINA_OPTS "-Xmx8g -XX:MaxPermSize=512M -Duser.timezone=UTC -server -Djava.awt.headless=true"

COPY --from=2 /opt/tomcat /opt/tomcat/
RUN set -x \
  && groupadd tomcat \
  && useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat \
  && chown root /opt/tomcat/webapps/geoserver/WEB-INF/lib/* \
  && chgrp root /opt/tomcat/webapps/geoserver/WEB-INF/lib/*

COPY server.xml /opt/tomcat/conf/server.xml
VOLUME ["/opt/tomcat/webapps/geoserver/data"]
EXPOSE 9090
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
