#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[RUN][INFO]Starting nodemanager."

su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/yarn --config $HADOOP_CONF_DIR nodemanager" yarn
