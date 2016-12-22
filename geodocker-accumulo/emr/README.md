# Amazon EMR Docker Accumulo Bootstrap

Amazon EMR already provides an environment with HDFS, Zookeeper, and YARN. This bootstrap script enables us to deploy Apache Accumulo on top of EMR cluster through docker containers. The main advantage of using docker in this scenario is ability to extend the container, for instance by adding GeoWave or GeoMesa iterator jars and still use the same bootstrap scripts.

## Parameters

The script is parametrized on following arguments:

  - `-i | --image` docker image to be used for accumulo
  - `-s | --accumulo-secret` accumulo secret to be used
  - `-p | --accumulo-password` accumulo password for root account
  - `-n | --instance-name` accumulo instance name
  - `-e | --env` additional environment variables for docker containers

These parameters have default values defined at the top of the bootstrap script.

## Usage

In order to use this bootstrap script it should be copied to an S3 bucket under your control so it accessed by the EMR cluster during the bootstrap phase.

```console
aws emr create-cluster --name "GeoDocker Accumulo" \
--release-label emr-5.0.0 \
--output text \
--use-default-roles \
--ec2-attributes KeyName=geotrellis-cluster \
--applications Name=Hadoop Name=Zookeeper \
--instance-groups \
Name=Master,BidPrice=0.5,InstanceCount=1,InstanceGroupType=MASTER,InstanceType=m3.xlarge \
Name=Workers,BidPrice=0.5,InstanceCount=1,InstanceGroupType=CORE,InstanceType=m3.xlarge \
--bootstrap-actions \
Name=BootstrapGeoWave,Path=s3://geotrellis-test/geodocker/accumulo-0.2/bootstrap-geodocker-accumulo.sh,\
Args=[-i=quay.io/geodocker/accumulo:latest,-n=gis,-p=secret,\
-e=TSERVER_XMX=10G,-e=TSERVER_CACHE_DATA_SIZE=6G,-e=TSERVER_CACHE_INDEX_SIZE=2G]
```
