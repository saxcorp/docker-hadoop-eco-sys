FROM saxcorp/hadoop_2.7.3

RUN mkdir -p /hadoop/dfs/data && \
    chown -R yarn:hadoop /hadoop/dfs/data &&\
    chmod -R 755 /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV NODETYPE "NODEMANAGER"

CMD ["/run.sh"]

