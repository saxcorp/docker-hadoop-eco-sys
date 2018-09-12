#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[UPDATE_AMBARI_AGENTS][BEGIN]"
case "${AMBARI_NODETYPE}" in
  SERVER)  log "[UPDATE_AMBARI_AGENTS][INFO] It's ambari SERVER node.";;
  AGENT)   log "[UPDATE_AMBARI_AGENTS][INFO] It's ambari AGENT node.";
           sed -i "s/^hostname=.*/hostname=ambari-server/" /etc/ambari-agent/conf/ambari-agent.ini;
           ambari-agent start;;
esac

log "[UPDATE_AMBARI_AGENTS][END]"

