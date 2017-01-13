#!/usr/bin/env bash
#
# Bootstrap docker and accumulo on EMR cluster
#

REPO=quay.io/geomesa
ACCUMULO_SECRET=DEFAULT
ACCUMULO_PASSWORD=secret
INSTANCE_NAME=accumulo
ARGS=$@

for i in "$@"
do
    case $i in
        --continue)
            CONTINUE=true
            shift
            ;;
        -t=*|--tag=*)
            TAG="${i#*=}"
            shift
            ;;
        -s=*|--accumulo-secret=*)
            ACCUMULO_SECRET="${i#*=}"
            shift
            ;;
        -p=*|--accumulo-password=*)
            ACCUMULO_PASSWORD="${i#*=}"
            shift
            ;;
        -n=*|--instance-name=*)
            INSTANCE_NAME="${i#*=}"
            shift
            ;;
        -e=*|--env=*)
            ENV_VARS+=("-e ${i#*=}")
            shift
            ;;
        *)
            ;;
    esac
done

# Parses a configuration file put in place by EMR to determine the role of this node
is_master() {
  if [ $(jq '.isMaster' /mnt/var/lib/info/instance.json) = 'true' ]; then
    return 0
  else
    return 1
  fi
}

### MAIN ####

# EMR bootstrap runs before HDFS or YARN are initilized
if [ ! $CONTINUE ]; then
    sudo yum -y install docker
    sudo usermod -aG docker hadoop
    sudo service docker start

    THIS_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
	  TIMEOUT= is_master && TIMEOUT=3 || TIMEOUT=4
	  echo "bash -x $THIS_SCRIPT --continue $ARGS > /tmp/geodocker-accumulo-bootstrap.log" | at now + $TIMEOUT min
	  exit 0 # Bail and let EMR finish initializing
fi

YARN_RM=$(xmllint --xpath "//property[name='yarn.resourcemanager.hostname']/value/text()"  /etc/hadoop/conf/yarn-site.xml)
DOCKER_ENV="-e USER=hadoop \
-e ZOOKEEPERS=$YARN_RM \
-e ACCUMULO_SECRET=$ACCUMULO_SECRET \
-e ACCUMULO_PASSWORD=$ACCUMULO_PASSWORD \
-e INSTANCE_NAME=$INSTANCE_NAME \
${ENV_VARS[@]} \
-v /etc/hadoop/conf:/etc/hadoop/conf \
-v /usr/lib/hadoop-hdfs/bin:/usr/lib/hadoop-hdfs/bin"

IMAGE=${REPO}/accumulo-geomesa:${TAG}

DOCKER_OPT="-d --net=host --restart=always --memory-swappiness=0"
if is_master ; then
    docker run $DOCKER_OPT --name=accumulo-master $DOCKER_ENV $IMAGE master --auto-init
    docker run $DOCKER_OPT --name=accumulo-monitor $DOCKER_ENV $IMAGE monitor
    docker run $DOCKER_OPT --name=accumulo-tracer $DOCKER_ENV $IMAGE tracer
    docker run $DOCKER_OPT --name=accumulo-gc $DOCKER_ENV $IMAGE gc
    docker run $DOCKER_OPT --name=geoserver quay.io/geomesa/geoserver:$TAG
    docker run $DOCKER_OPT --name=jupyter $DOCKER_ENV quay.io/geomesa/geomesa-jupyter:$TAG
else # is worker
    docker run -d --net=host --name=accumulo-tserver $DOCKER_ENV $IMAGE tserver
fi
