#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[RUN][INFO]Create HDFS user on HDFS."
add_hdfs_user hadoop

log "[RUN][INFO]Starting Datanode."
su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs --config $HADOOP_CONF_DIR datanode" hdfs

