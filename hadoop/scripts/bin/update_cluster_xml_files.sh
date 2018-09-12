#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh
log "[UPDATE_CLUSTER_XML_FILES][BEGIN]"
file_config=""

if [ $(find "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}" -maxdepth 1 -type f -name "*.yaml" | wc -l) -lt 1 ]
then
 log "[UPDATE_CLUSTER_XML_FILES][WARNING] No yaml configuration file found!"

else
 file_config=$(find "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}" -maxdepth 1 -type f -name "*.yaml" | head -1)
 file_config_name=$(basename ${file_config})
 log "[UPDATE_CLUSTER_XML_FILES][INFO] file_config : [${file_config}]"

 if [ "$(yaml_conf_exist_xpath ${file_config_name} ${NODETYPE})" == "false" ]
 then
  log "[UPDATE_CLUSTER_XML_FILES][WARNING] No configuration found for nodetype [${NODETYPE}] on file [${file_config}]!"

 else
  log "[UPDATE_CLUSTER_XML_FILES][INFO] Configuration found for nodetype [${NODETYPE}] on file [${file_config}]."
  nb_files=$(yaml_conf_get_xml_node_nb_files ${file_config_name} ${NODETYPE})
  log "[UPDATE_CLUSTER_XML_FILES][INFO] ${NODETYPE} nb_files = ${nb_files}."
  for (( index_file=0; index_file<${nb_files}; index_file++ ))
  do
   xml_file_name=$(yaml_conf_get_xml_node_file_name ${file_config_name} ${NODETYPE} ${index_file})
   log "[UPDATE_CLUSTER_XML_FILES][INFO] Managing file ${xml_file_name}"
   nb_propertie=$(yaml_conf_get_xml_node_nb_properties ${file_config_name} ${NODETYPE} ${index_file})
   log "[UPDATE_CLUSTER_XML_FILES][INFO] ${xml_file_name} nb_propertie = ${nb_propertie}."

   for (( index_prop=0; index_prop<${nb_propertie}; index_prop++ ))
   do
    propertie_key=$(yaml_conf_get_xml_node_properties_key ${file_config_name} ${NODETYPE} ${index_file} ${index_prop})
    propertie_val=$(yaml_conf_get_xml_node_properties_val ${file_config_name} ${NODETYPE} ${index_file} ${index_prop})

    case "${NODETYPE}" in
     SPARK )
      log "[UPDATE_CLUSTER_XML_FILES][INFO] Spark propertie (${xml_file_name}) => [${propertie_key} : ${propertie_val}]"
      echo -e "${propertie_key} ${propertie_val}" >> "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/spark/${xml_file_name}"
     ;;
     * )
      log "[UPDATE_CLUSTER_XML_FILES][INFO] propertie => [${propertie_key} : ${propertie_val}]"
      add_hadoop_xml_properties ${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/${xml_file_name} "${propertie_key}" "${propertie_val}"
     ;;
    esac
   done
  done
 fi
fi

log "[UPDATE_CLUSTER_XML_FILES][END]"
