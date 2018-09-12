FROM saxcorp/hadoop_2.7.3

#ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
RUN mkdir -p /hadoop/yarn/timeline

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV NODETYPE "HISTORYSERVER"

CMD ["/run.sh"]
