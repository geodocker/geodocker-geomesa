#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source /sbin/accumulo-lib.sh

ACCUMULO_USER=${ACCUMULO_USER:-root}

wait_until_accumulo_is_available ${INSTANCE_NAME} ${ZOOKEEPERS}
accumulo shell -u ${ACCUMULO_USER} -p ${ACCUMULO_PASSWORD} -e \
  "createnamespace geomesa"
accumulo shell -u ${ACCUMULO_USER} -p ${ACCUMULO_PASSWORD} -e \
  "config -s general.vfs.context.classpath.geomesa=file:///opt/geomesa/accumulo/[^.].*.jar"
accumulo shell -u ${ACCUMULO_USER} -p ${ACCUMULO_PASSWORD} -e \
  "config -ns geomesa -s table.classpath.context=geomesa"
echo "Accumulo namespace configured: geomesa"

