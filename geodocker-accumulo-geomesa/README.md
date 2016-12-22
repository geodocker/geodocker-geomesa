# GeoDocker Accumulo GeoMesa

[![Build Status](https://api.travis-ci.org/geodocker/geodocker-accumulo.svg)](http://travis-ci.org/geodocker/geodocker-accumulo-geomesa)
[![Docker Repository on Quay](https://quay.io/repository/geodocker/base/status "Docker Repository on Quay")](https://quay.io/repository/geodocker/accumulo)
[![Join the chat at https://gitter.im/geotrellis/geotrellis](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/geotrellis/geotrellis?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Apache Accumulo](https://accumulo.apache.org/) container for [GeoDocker Cluster](https://github.com/geodocker/geodocker)

# Roles
This container has three roles that can be supplied as `CMD`:

  - `master` - master instance, handles synchronization
    - `--auto-init` - initialize an accumulo instance if one is not found at `hdfs://${HADOOP_MASTER_ADDRESS}/accumulo`
  - `tserver` - tablet server, serves data
  - `monitor` - monitor instance, provides Web GUI at 50095
  - `gc` - garbage collector for accumulo tablets
  - `tracer` - trace for debugging

# Environment
  - `HADOOP_MASTER_ADDRESS` - hostname for accumulo root, required for all roles
  - `ZOOKEEPERS` - list of zookeeper instance, at least one
  - `ACCUMULO_SECRET` - secret value for inter-instance communication
  - `INSTANCE_NAME` - accumulo instance name
  - `ACCUMULO_PASSWORD` - root password

# Testing
This container should be tested with `docker-compose` and through `make test`

# Use on Amazon EMR
For information on the use of this container and its siblings on top of
EMR, go
[here](https://github.com/geodocker/geodocker-accumulo/tree/master/emr).

