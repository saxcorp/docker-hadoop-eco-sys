FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends  software-properties-common ca-certificates

RUN add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends  software-properties-common ca-certificates openjdk-8-jdk net-tools xmlstarlet curl vim wget openssh-server openssh-client

RUN wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu14/2.x/updates/2.6.0.0/ambari.list \
    && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD \
    && apt-get update \
    && apt-get install -y ambari-agent \
    && rm -rf /var/lib/apt/lists/*

#RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
#    07617D4968B34D8F13D56E20BE5AAA0BA210C095 \
#    2CAC83124870D88586166115220F69801F27E622 \
#    4B96409A098DBD511DF2BC18DBAF69BEA7239D59 \
#    9DD955653083EFED6171256408458C39E964B5FF \
#    B6B3F7EDA5BA7D1E827DE5180DFF492D8EE2F25C \
#    6A67379BEFC1AE4D5595770A34005598B8F47547 \
#    47660BC98BC433F01E5C90581209E7F13D0C92B9 \
#    CE83449FDC6DACF9D24174DCD1F99F6EE3CD2163 \
#    A11DF05DEA40DA19CE4B43C01214CF3F852ADB85 \
#    686E5EDF04A4830554160910DF0F5BBC30CD0996 \
#    5BAE7CB144D05AD1BB1C47C75C6CC6EFABE49180 \
#    AF7610D2E378B33AB026D7574FB955854318F669 \
#    6AE70A2A38F466A5D683F939255ADF56C36C5F0F \
#    70F7AB3B62257ABFBD0618D79FDB12767CC7352A \
#    842AAB2D0BC5415B4E19D429A342433A56D8D31A \
#    1B5D384B734F368052862EB55E43CAB9AEC77EAF \
#    785436A782586B71829C67A04169AA27ECB31663 \
#    5E49DA09E2EC9950733A4FF48F1895E97869A2FB \
#    A13B3869454536F1852C17D0477E02D33DD51430 \
#    A6220FFCC86FE81CE5AAC880E3814B59E4E11856 \
#    EFE2E7C571309FE00BEBA78D5E314EEF7340E1CB \
#    EB34498A9261F343F09F60E0A9510905F0B000F0 \
#    3442A6594268AC7B88F5C1D25104A731B021B57F \
#    6E83C32562C909D289E6C3D98B25B9B71EFF7770 \
#    E9216532BF11728C86A11E3132CF4BF4E72E74D3 \
#    E8966520DA24E9642E119A5F13971DA39475BD5D \
#    1D369094D4CFAC140E0EF05E992230B1EB8C6EFA \
#    A312CE6A1FA98892CB2C44EBA79AB712DE5868E6 \
#    0445B7BFC4515847C157ECD16BA72FF1C99785DE \
#    B74F188889D159F3D7E64A7F348C6D7A0DCED714 \
#    4A6AC5C675B6155682729C9E08D51A0A7501105C \
#    8B44A05C308955D191956559A5CEE20A90348D47

ENV HADOOP_VERSION 2.7.3
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

#ADD ./sources/hadoop-${HADOOP_VERSION}.tar.gz /tmp

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN ln -s /usr/bin/java /bin/java

ENV HADOOP_PREFIX /usr/local/hadoop-$HADOOP_VERSION
ENV HADOOP_HOME ${HADOOP_PREFIX}
ENV HADOOP_CONF_DIR /etc/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH

ENV DOCKER_CLUSTER_TOOLS_HOME /etc/docker_cluster_tools
ENV DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR $DOCKER_CLUSTER_TOOLS_HOME/shared_conf
ENV DOCKER_CLUSTER_TOOLS_BIN_DIR $DOCKER_CLUSTER_TOOLS_HOME/bin
ENV DOCKER_CLUSTER_TOOLS_LOG_DIR $DOCKER_CLUSTER_TOOLS_HOME/log

RUN mv /tmp/hadoop-$HADOOP_VERSION /usr/local
RUN ln -s /usr/local/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

ADD ./scripts $DOCKER_CLUSTER_TOOLS_HOME

RUN chmod 777 $DOCKER_CLUSTER_TOOLS_BIN_DIR/*.sh &&\
    chmod 777 $DOCKER_CLUSTER_TOOLS_HOME/*.sh

RUN $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh hadoop &&\
    $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh hdfs &&\
    $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh mapred &&\
    $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh yarn &&\
    $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh hive &&\
    $DOCKER_CLUSTER_TOOLS_BIN_DIR/create_local_users.sh spark

ENV YQ_URL "https://github.com/mikefarah/yq/releases/download/1.14.1/yq_linux_amd64"
RUN curl -fSL "$YQ_URL" --output "/tmp/yq" &&\
    chmod ugo+x /tmp/yq &&\
    mv /tmp/yq /usr/bin

ENV AMBARI_NODETYPE "AGENT"

ENTRYPOINT ["/etc/docker_cluster_tools/entrypoint.sh"]










