#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

if [ ! -d /hadoop/dfs/name ]; then
  log "[RUN][ERROR]Namenode name directory not found: /hadoop/dfs/name"
  exit 2
fi

if [ "$(ls -A /hadoop/dfs/name)" == "" ]; then
  log "[RUN][INFO]Formatting namenode name directory: /hadoop/dfs/name"
  su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs --config $HADOOP_CONF_DIR namenode -format '$(conf_get_cluster_name)'" hdfs
fi

log "[RUN][INFO]Starting Namenode"
su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs --config $HADOOP_CONF_DIR namenode" hdfs

