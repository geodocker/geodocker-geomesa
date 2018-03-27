#!/bin/bash

usage() { echo "Usage: $0 [-t <tag>] [-k <kafka.version>] [-g <geomesa.version>] [-a <accumulo.version>]" 1>&2; exit 1; }

ACCUMULO_VERSION=1.7.3
GEOMESA_VERSION=2.0.0-m.1
KAFKA_VERSION=10

while getopts ":t:k:g:a:" o; do
    case "${o}" in
        a)
            ACCUMULO_VERSION=${OPTARG}
            ;;
        g)
            GEOMESA_VERSION=${OPTARG}
            ;;
        k)
            KAFKA_VERSION=${OPTARG}
            ;;
        t)
            TAG=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$TAG" ]; then TAG=geomesa-${GEOMESA_VERSION}-accumulo-${ACCUMULO_VERSION}; fi

if [[ $ACCUMULO_VERSION == 1.8* ]]; then THRIFT_VERSION=0.9.3; else THRIFT_VERSION=0.9.2; fi

echo "ACCUMULO_VERSION = ${ACCUMULO_VERSION}"
echo "GEOMESA_VERSION = ${GEOMESA_VERSION}"
echo "KAFKA_VERSION = ${KAFKA_VERSION}"
echo "TAG = ${TAG}"

export ACCUMULO_VERSION GEOMESA_VERSION KAFKA_VERSION TAG THRIFT_VERSION
make publish
