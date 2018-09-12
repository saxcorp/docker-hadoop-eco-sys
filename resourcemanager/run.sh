#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[RUN][INFO]Create HDFS Yarn temp directory."
create_hdfs_path "/tmp/mapred" "mapred" "1750"
create_hdfs_path "/tmp/hadoop-yarn" "mapred" "1775"
create_hdfs_path "/tmp/logs" "yarn" "1775"

log "[RUN][INFO]Starting resourcemanager."
su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/yarn --config $HADOOP_CONF_DIR resourcemanager" yarn

