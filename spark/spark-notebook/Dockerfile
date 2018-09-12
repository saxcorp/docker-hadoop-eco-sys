FROM saxcorp/hadoop_2.7.3_hive-server

ENV APACHE_SPARK_VERSION 2.1.1
ENV APACHE_HADOOP_VERSION 2.7.3

RUN set -x \
    && curl -fSL "https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-0.7.0-scala-2.11.8-spark-$APACHE_SPARK_VERSION-hadoop-$APACHE_HADOOP_VERSION-with-hive.tgz" -o /tmp/spark-notebook.tgz \
    && tar -xzvf /tmp/spark-notebook.tgz -C /opt/ \
    && mv /opt/spark-notebook-* /opt/spark-notebook \
    && rm /tmp/spark-notebook.tgz

COPY run.sh /run.sh
RUN chmod a+x /run.sh

COPY application.conf /opt/spark-notebook/conf/
COPY clusters /opt/spark-notebook/conf/
COPY profiles /opt/spark-notebook/conf/
COPY jars /jars

RUN mkdir -p /data/resources

ENV NOTEBOOKS_DIR "/opt/spark-notebook/notebooks"
ENV RESOURCES_DIR "/data/resources"
ENV SPARK_MASTER "spark://spark-master:7077"
ENV SPARK_EXECUTOR_MEMORY "4G"
ENV EXTRA_CLASSPATH "/jars/*"

WORKDIR /opt/spark-notebook/

CMD ["/run.sh"]
