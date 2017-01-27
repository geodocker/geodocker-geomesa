# building the current images

**step 0: clone the repos**

`git clone https://github.com/geoHeil/geodocker-geomesa.git`

**step 1: choose correct settings**

- choose settings for accumulo / geomesa / ... version which fits your environment
- if there are major changes you might need to recompile geomsa as well
	```
	git clone https://github.com/locationtech/geomesa.git
	cd geomesa
	git checkout geomesa_2.11-1.3.0
	update ./build.sh to desired version numbers then
	build/mvn clean install -DskipTests=true #test failures otherwise (timeouts on macbook)
	```

**step 2: build the image for the tutorial**
```
git clone https://github.com/geoHeil/geomesa-tutorials.git
cd geomesa-tutorials/docker-tutorial/
docker build -t geomesa-tutorial:1.3.0 .
```

**step 3: start all the images**

```
docker-compose up
```

**step 4: run the quickstart**

- connect into the java container which is already running
```
docker ps # shows all the containers
e5b2bb33c0b0        geomesa-tutorial:1.3.0 # I see this one
docker exec -ti <id> bash # id is here e5b2bb33c0b0
```

Now run the quickstart. This requires connection credentials as defined in the `docker-compose.yml` file:

```
java -cp geomesa-quickstart-accumulo/target/geomesa-quickstart-accumulo-1.3.0.jar \
  com.example.geomesa.accumulo.AccumuloQuickStart \
  -instanceId accumulo \
  -zookeepers zookeeper \
  -user root \
  -password GisPwd \
  -tableName quickstart
```
- you can monitor accumulo here http://localhost:9995/accumulo

# TODO

 - currently it is crashing
 - checkout geomesas gitter, there are some really interesting notes
 - apparently the iterators ore (not yet out of the box) available in the geodocker implementation
 - you need to add the jar into `ACCUMULO_HOME/lib` to *globally* install it. Otherwise namespaces are possible as well
```
The version of ZooKeeper being used doesn't support Container nodes. CreateMode.PERSISTENT will be used instead.
Configured server-side iterators do not match client version - client version: 1.3.0, server version: unavailable
Creating new features
Inserting new features
Submitting query
Exception in thread "main" java.lang.RuntimeException: org.apache.accumulo.core.client.impl.AccumuloServerException: Error on server 845c80b29b3a:9997
```