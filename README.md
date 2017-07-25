# GeoDocker Geomesa

Pre-built images are available on [quay.io](https://quay.io/organization/geomesa).

To create a GeoMesa Accumulo instance, clone the repo and execute the following commands:

```bash
$ cd geodocker-accumulo-geomesa
$ docker-compose up
```

This will create a small cluster consisting of HDFS, Zookeeper, Accumulo and GeoServer. The GeoMesa
distributed-runtime jar is installed in the Accumulo classpath. The GeoMesa command line tools are
installed in the Accumulo master instance under `/opt/geomesa/`.

Accumulo is available on the standard ports, and GeoServer is available on port `9090`.

# Quick Start

To connect to the Accumulo master instance, run:

```bash
$ docker exec -ti geodockeraccumulogeomesa_accumulo-master_1 /usr/bin/bash
```

To ingest some sample data, use the GeoMesa command line tools:

```
$ cd /opt/geomesa/bin
$ ./geomesa ingest -C example-csv -c example -u root -p GisPwd -s example-csv ../examples/ingest/csv/example.csv
```

To export data:

```bash
$ ./geomesa export -c example -u root -p GisPwd -f example-csv
```

To view data in GeoServer, go to `http://localhost:9090/geoserver/web`, login with `admin:geoserver`, click
'Stores' in the left gutter, then 'Add new store', then `Accumulo (GeoMesa)`. Use the following parameters:

* instanceId = accumulo
* zookeepers = zookeeper
* user = root
* password = GisPwd
* tableName = example (from the ingest command above)

Click 'save'. You should see the 'example-csv' layer available to publish.
