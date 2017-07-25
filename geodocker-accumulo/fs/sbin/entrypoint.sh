#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source /sbin/accumulo-lib.sh

# Set default configurations if not provided
: ${ACCUMULO_SECRET:=DEFAULT}
: ${INSTANCE_NAME:=accumulo}
: ${TSERVER_CACHE_DATA_SIZE:=128M}
: ${TSERVER_CACHE_INDEX_SIZE:=128M}
: ${TSERVER_MEMORY_MAPS_MAX:=1G}
: ${TSERVER_XMX:=3g}
: ${MASTER_XMX:=2g}
: ${MONITOR_XMX:=1g}
: ${GC_XMX:=1g}

# HDFS Configuration
template $HADOOP_CONF_DIR/core-site.xml

# Accumulo Configuration
# core-site.xml could have been volume mounted, use it as default
DEFAULT_FS=$(xmllint --xpath "//property[name='fs.defaultFS']/value/text()"  $HADOOP_CONF_DIR/core-site.xml)
INSTANCE_VOLUME=${INSTANCE_VOLUME:-$DEFAULT_FS/$INSTANCE_NAME}
template $ACCUMULO_CONF_DIR/accumulo-site.xml
template $ACCUMULO_CONF_DIR/client.conf

# The first argument determines this container's role in the accumulo cluster
ROLE=${1:-}
if [ -z $ROLE ]; then
  echo "Select the role for this container with the docker cmd 'master', 'monitor', 'gc', 'tracer', or 'tserver'"
  exit 1
else
  case $ROLE in
    "master" | "tserver" | "monitor" | "gc" | "tracer")
      ATTEMPTS=7 # ~2 min before timeout failure
      with_backoff zookeeper_is_available "$ZOOKEEPERS" || exit 1
      wait_until_hdfs_is_available || exit 1

      USER=${USER:-root}
      ensure_user $USER
      echo "Running as $USER"

      # Initialize Accumulo if required
      if [[ ($ROLE = "master") && (${2:-} = "--auto-init")]]; then
        if accumulo_instance_exists $INSTANCE_NAME $ZOOKEEPERS; then
          echo "Found accumulo instance at: $INSTANCE_VOLUME"
        else
          echo "Initializing accumulo instance $INSTANCE_VOLUME ..."
          runuser -p -u $USER hdfs -- dfs -mkdir -p ${INSTANCE_VOLUME}-classpath
          runuser -p -u $USER accumulo -- init --instance-name ${INSTANCE_NAME} --password ${ACCUMULO_PASSWORD}

	  if [[ -n ${POSTINIT:-} ]]; then
	     echo "Post-initializing accumulo instance $INSTANCE_VOLUME ..."
	     (setsid $POSTINIT &> /tmp/${INSTANCE_NAME}-postinit.log &)
	  fi
        fi
      fi

      if [[ $ROLE != "master" ]]; then
        with_backoff accumulo_instance_exists $INSTANCE_NAME $ZOOKEEPERS || exit 1
      fi

      exec runuser -p -u $USER accumulo -- $ROLE ;;
    *)
      exec "$@"
  esac
fi
