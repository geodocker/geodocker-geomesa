# building a current image

- update accumulo and geomesa version number
git clone https://github.com/locationtech/geomesa.git
cd geomesa
git checkout geomesa_2.11-1.3.0
update ./build.sh to desired version numbers then
build/mvn clean install -DskipTests=true #test failures otherwise (timeouts on macbook)

## to start the image

cd geodocker-accumulo-geomesa
docker-compose up

## geomesa tutorial quickstart

git clone the tutorials

make sure versions are matching (you can get git clone https://github.com/geoHeil/geomesa-tutorials.git)
Change all pom xml files

build the quickstart via
mvn clean install -pl geomesa-quickstart-accumulo

copy jar into java container which is connected to geomesa
docker cp geomesa-quickstart-accumulo/target/geomesa-quickstart-accumulo-1.3.0.jar java8JDK:/geomesaQuickstart.jar
docker exec -ti bash java8JDK bash
java -cp geomesaQuickstart.jar \
  com.example.geomesa.accumulo.AccumuloQuickStart \
  -instanceId accumulo \
  -zookeepers zookeeper \
  -user accumulo \
  -password secret \
  -tableName quickstart

  **todo**
  what is the user /password of the default dockerized geDocker version?