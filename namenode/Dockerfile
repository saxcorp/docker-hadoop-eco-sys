FROM saxcorp/hadoop_2.7.3

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV NODETYPE "NAMENODE"

EXPOSE 50070

CMD ["/run.sh"]

