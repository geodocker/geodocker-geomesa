build: base hdfs accumulo geomesa geoserver geomesa-jupyter

base:
	cd geodocker-base && make publish

hdfs:
	cd geodocker-hdfs && make publish

accumulo:
	cd geodocker-accumulo && make publish

geomesa:
	cd geodocker-accumulo-geomesa && make publish

geoserver:
	cd geodocker-geoserver && make publish

geomesa-jupyter:
	cd geodocker-geomesa-jupyter && make publish

clean:
	cd geodocker-base && make clean
	cd geodocker-hdfs && make clean
	cd geodocker-accumulo && make clean
	cd geodocker-accumulo-geomesa && make clean
	cd geodocker-geoserver && make clean
	cd geodocker-geomesa-jupyter && make clean
