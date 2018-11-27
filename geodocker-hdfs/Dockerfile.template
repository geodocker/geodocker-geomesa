FROM quay.io/geomesa/base:__TAG__

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ENV HADOOP_VERSION 2.8.4-1.el7
ENV HADOOP_HOME /usr/lib/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop/conf

RUN set -x \
&& wget -nv -O /etc/yum.repos.d/bigtop.repo http://www.apache.org/dist/bigtop/stable/repos/centos7/bigtop.repo \
&& yum install -y hadoop-hdfs-${HADOOP_VERSION} hadoop-mapreduce-${HADOOP_VERSION} openssl-devel nmap

COPY ./fs /
VOLUME ["/data/hdfs"]
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
