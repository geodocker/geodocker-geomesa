# building a current image

- update accumulo and geomesa version number
```
git clone https://github.com/locationtech/geomesa.git
cd geomesa
git checkout geomesa_2.11-1.3.0
update ./build.sh to desired version numbers then
build/mvn clean install -DskipTests=true #test failures otherwise (timeouts on macbook)
```

## to start the image

```
cd geodocker-accumulo-geomesa
docker-compose up
```

## geomesa tutorial quickstart

```
git clone https://github.com/geoHeil/geomesa-tutorials
```
- follow the readme there to build the container

make sure versions are matching (you can get git clone https://github.com/geoHeil/geomesa-tutorials.git)
Change all pom xml files

connect into the java container which is already running
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
  -user accumulo \
  -password secret \
  -tableName quickstart
```