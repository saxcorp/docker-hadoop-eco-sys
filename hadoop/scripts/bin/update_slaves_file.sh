#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh
log "[UPDATE_SLAVES_FILE][BEGIN]"

if [ "$(is_slave_node ${NODETYPE})" = "false" ]
then
 log "[UPDATE_SLAVES_FILE][WARNING] The current node is not eligible to be add on slaves file."
else
 log "[UPDATE_SLAVES_FILE][INFO] The current node is eligible to be add on slaves file."
 current_hostname=$(hostname -f)
 log "[UPDATE_SLAVES_FILE][INFO] current_hostname=[${current_hostname}]"
 slave_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/slaves"

 if [ "$(hostname_is_on_slave_file "${slave_file}" "${current_hostname}")" = "true" ]
 then
  log "[UPDATE_SLAVES_FILE][INFO] Hostname already exist [${current_hostname}]."
 else
  log "[UPDATE_SLAVES_FILE][INFO] Adding [${current_hostname}] on file [${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/slaves]."
  echo -e "${current_hostname}" >> "${slave_file}"
 fi
fi
log "[UPDATE_SLAVES_FILE][END]"