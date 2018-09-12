#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

current_container_id="$(container_id)"
synchronize_configs_process ${current_container_id}

log "[ENTRYPOINT][INFO] Begin."
print_node_type
${DOCKER_CLUSTER_TOOLS_BIN_DIR}/update_etc_host.sh
${DOCKER_CLUSTER_TOOLS_BIN_DIR}/update_slaves_file.sh
${DOCKER_CLUSTER_TOOLS_BIN_DIR}/update_cluster_xml_files.sh
${DOCKER_CLUSTER_TOOLS_BIN_DIR}/update_ambari_agents.sh
synchronize_all_conf_files
log "[ENTRYPOINT][INFO] End."
log "[ENTRYPOINT][INFO] Sub command to exec : [$@]"
release_configs_process ${current_container_id}
exec $@