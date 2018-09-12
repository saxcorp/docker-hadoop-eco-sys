FROM saxcorp/hadoop_2.7.3_hive-server

ENV SPARK_VERSION 2.2.2
ENV SPARK_HADOOP_PROFILE 2.7

ENV SPARK_BIN_URL https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION

RUN set -x \
    && curl -fSL "$SPARK_BIN_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-* $SPARK_HOME \
    && rm -f /tmp/spark.tar.gz

WORKDIR $SPARK_HOME
ENV PATH $SPARK_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

ENV NODETYPE "SPARK"

ADD run.sh /run.sh
RUN chmod a+x /run.sh
    
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh

RUN chown -R spark:hadoop /opt/spark-$SPARK_VERSION

CMD ["/run.sh"]
