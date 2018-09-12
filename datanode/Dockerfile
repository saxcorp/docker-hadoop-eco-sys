FROM saxcorp/hadoop_2.7.3

RUN mkdir -p /hadoop/dfs/data && \
    chown -R hdfs:hadoop /hadoop/dfs/data &&\
    chmod -R 750 /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV NODETYPE "DATANODE"

CMD ["/run.sh"]

