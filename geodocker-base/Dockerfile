FROM centos:7

MAINTAINER Nathan Zimmerman, npzimmerman@gmail.com

RUN yum install -y wget curl unzip which nc bzip2

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

# JAVA
ENV JAVA_HOME /usr/java/jdk1.8.0_45
ENV PATH $PATH:$JAVA_HOME/bin

RUN set -x \
  && curl -sS -LO 'http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
  && rpm -Uvh jdk-8u45-linux-x64.rpm \
  && rm -rf jdk-8u45-linux-x64.rpm \
  && curl -sS http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo > /etc/yum.repos.d/bigtop.repo
