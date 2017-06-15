FROM quay.io/geomesa/accumulo-geomesa:__TAG__

MAINTAINER GeoMesa team <geomesa@ccri.com>

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

ENV GEOMESA_VERSION ${GEOMESA_VERSION}

USER root

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER hdfs
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV NB_HOME /var/lib/hadoop-hdfs
# Setup work directory
RUN mkdir $CONDA_DIR && chown hdfs:hdfs $CONDA_DIR

USER $NB_USER

# Setup hdfs home directory
RUN mkdir -p ${NB_HOME}/work  && \
    mkdir ${NB_HOME}/.jupyter && \
    mkdir ${NB_HOME}/work/js

COPY js/ ${NB_HOME}/work/js/

# copy the sample notebook
USER root
COPY GDELT+Analysis.ipynb ${NB_HOME}/work/
RUN chmod a+rw ${NB_HOME}/work/*.ipynb
USER $NB_USER

# Install conda as hdfs
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh && \
    echo "efd6a9362fc6b4085f599a881d20e57de628da8c1a898c08ec82874f3bad41bf *Miniconda3-4.1.11-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash Miniconda3-4.1.11-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.1.11-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --quiet --yes conda==4.1.11 && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

# Install Jupyter notebook as hdfs
RUN conda install --quiet --yes \
    'notebook=4.2*' \
    jupyterhub=0.7 \
    && conda clean -tipsy

USER root

EXPOSE 8888
WORKDIR ${NB_HOME}/work

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py ${NB_HOME}/.jupyter/
RUN chown -R $NB_USER:hdfs ${NB_HOME}/.jupyter

# install toree
COPY toree-0.2.0.dev1.tar.gz /tmp
RUN pip install --upgrade --pre /tmp/toree-0.2.0.dev1.tar.gz

# install Spark
ENV APACHE_SPARK_VERSION 2.0.2
ENV HADOOP_VERSION 2.7

RUN cd /tmp && \
        wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
        echo "e6349dd38ded84831e3ff7d391ae7f2525c359fb452b0fc32ee2ab637673552a *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha256sum -c - && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

# Spark and Mesos config
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.3-src.zip
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so

# copy vegas libs to spark jars dir
COPY lib/* /usr/local/spark/jars/

# Switch back to hdfs to avoid accidental container runs as root
USER $NB_USER

ENV GEOMESA_SPARK_HOME file:///opt/geomesa/dist/spark
ENV GEOMESA_SPARK_JARS ${GEOMESA_SPARK_HOME}/geomesa-accumulo-spark-runtime_2.11-${GEOMESA_VERSION}.jar,${GEOMESA_SPARK_HOME}/geomesa-spark-converter_2.11-${GEOMESA_VERSION}.jar,${GEOMESA_SPARK_HOME}/geomesa-spark-geotools_2.11-${GEOMESA_VERSION}.jar

# install GeoMesa kernel
RUN jupyter toree install       \
 --replace                      \
 --user                         \
 --kernel_name="GeoMesa Spark"  \
 --spark_home=${SPARK_HOME}     \
 --spark_opts="--driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info --master yarn --jars ${GEOMESA_SPARK_JARS}"
