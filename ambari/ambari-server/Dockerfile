FROM saxcorp/hadoop_2.7.3

RUN wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu14/2.x/updates/2.6.0.0/ambari.list \
    && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD\
    && apt-get update \
    && apt-get install -y ambari-server \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O /var/lib/ambari-server/resources/postgres-jdbc-driver.jar

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV AMBARI_NODETYPE "SERVER"

EXPOSE 8080

CMD ["/run.sh"]



