#!/bin/bash

usage() { echo "Usage: $0 [-t <tag>] [-g <geomesa.version>] [-a <accumulo.version>]" 1>&2; exit 1; }

ACCUMULO_VERSION=1.9.2
GEOMESA_VERSION=2.2.0
THRIFT_VERSION=0.9.3

while getopts ":t:g:a:" o; do
    case "${o}" in
        a)
            ACCUMULO_VERSION=${OPTARG}
            ;;
        g)
            GEOMESA_VERSION=${OPTARG}
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

echo "GEOMESA_VERSION = ${GEOMESA_VERSION}"
echo "ACCUMULO_VERSION = ${ACCUMULO_VERSION}"
echo "TAG = ${TAG}"

export ACCUMULO_VERSION GEOMESA_VERSION TAG THRIFT_VERSION
make publish

