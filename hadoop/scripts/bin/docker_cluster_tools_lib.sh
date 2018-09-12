#!/usr/bin/env bash

function container_id(){
 echo "$(hostname)_$(hostname -i)"
}

function log(){
 echo -e "$(date +"%Y/%m/%d %H:%M:%S")-$(container_id) $1" | tee -a ${DOCKER_CLUSTER_TOOLS_LOG_DIR}/trace.log
}

function print_node_type(){
 case "${NODETYPE}" in
  NAMENODE)log "[PRINT_NODE_TYPE][INFO][NAMENODE]";;
  NAMENODE_S1) log "[PRINT_NODE_TYPE][INFO][NAMENODE_S1]";;
  DATANODE)log "[PRINT_NODE_TYPE][INFO][DATANODE]";;
  RESOURCEMANAGER)log "[PRINT_NODE_TYPE][INFO][RESOURCEMANAGER]";;
  NODEMANAGER)log "[PRINT_NODE_TYPE][INFO][NODEMANAGER]";;
  HISTORYSERVER)log "[PRINT_NODE_TYPE][INFO][HISTORYSERVER]";;
  HIVE)log "[PRINT_NODE_TYPE][INFO][HIVE]";;
 esac
}

#arg1: conf_file_name
#arg2: xpath
function yaml_conf_exist_xpath(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 xpath="${2}"
 res=$(yq r ${yaml_file} ${xpath})
 if [ "$res" != "null" ]
 then
  echo "true"
 else
  echo "false"
 fi
}

#arg1: conf_file_name
#arg2: properties_name
function yaml_conf_get_env_global_properties(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 key="${2}"
 yq r ${yaml_file} ${key}
}

#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
function yaml_conf_get_xml_node_nb_global_properties(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 yq r ${yaml_file} ${nodetype}.envs.*.0 | wc -l
}


#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index env
function yaml_conf_get_xml_node_env_global_properties_key(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index="${3}"
 yq r ${yaml_file} ${nodetype}.envs.${index}.0
}

#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index env
function yaml_conf_get_xml_node_env_global_properties_val(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index="${3}"
 yq r ${yaml_file} ${nodetype}.envs.${index}.1
}

#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
function yaml_conf_get_xml_node_nb_files(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 yq r ${yaml_file} ${nodetype}.files.*.file.name | wc -l
}

#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index file
function yaml_conf_get_xml_node_file_name(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index_file="${3}"
 yq r ${yaml_file} ${nodetype}.files.${index_file}.file.name
}

#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index file
function yaml_conf_get_xml_node_nb_properties(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index_file="${3}"
 yq r ${yaml_file} ${nodetype}.files.${index_file}.file.properties.*.0 | wc -l
}
#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index file
#arg4: index properties
function yaml_conf_get_xml_node_properties_key(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index_file="${3}"
 index_propertie="${4}"
 yq r ${yaml_file} ${nodetype}.files.${index_file}.file.properties.${index_propertie}.0
}
#arg1: conf_file_name
#arg2: node type NAMENODE|NAMENODE_S1|DATANODE|RESOURCEMANAGER
#arg3: index file
#arg4: index properties
function yaml_conf_get_xml_node_properties_val(){
 yaml_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/${1}"
 nodetype="${2}"
 index_file="${3}"
 index_propertie="${4}"
 yq r ${yaml_file} ${nodetype}.files.${index_file}.file.properties.${index_propertie}.1
}

#arg1: path xml file
#arg2: properties_key
#arg3: properties_val
function add_hadoop_xml_properties(){
 xml_file="${1}"
 properties_key="${2}"
 properties_val="${3}"
 if [ ! -f "${xml_file}" ]; then
  log "[ADD_HADOOP_XML_PROPERTIES][WARNING] File ${xml_file} don't exist. It will be created!"
  echo -e '<?xml version="1.0" encoding="UTF-8"?>
<configuration>
</configuration>' |  xmlstarlet fo > ${xml_file}
 fi
 log "[ADD_HADOOP_XML_PROPERTIES][INFO] Add [${properties_key} : ${properties_val}] on file ${xml_file}"

 tmp_xml_file=$(dirname ${xml_file})"/~"$(basename ${xml_file})"_"$(date +"%Y_%m_%d_%H_%M_%S")
 #log "[ADD_HADOOP_XML_PROPERTIES][INFO] cp -f ${xml_file} ${tmp_xml_file}"
 cp -f ${xml_file} ${tmp_xml_file}

 xmlstarlet ed -d "/configuration/property/name[text()='${properties_key}']/../value" \
              -d "/configuration/property/name[text()='${properties_key}']" \
			  -d "/configuration/property[count(./name)=0]" \
			  -s "/configuration" -t elem -n property  \
			  -s "/configuration/property[count(./name)=0]" -t elem -n name -v "${properties_key}" \
			  -s "/configuration/property[count(./value)=0]" -t elem -n value -v "${properties_val}" \
			  ${tmp_xml_file} |  xmlstarlet fo > ${xml_file}

 rm -f ${tmp_xml_file}
}

#arg1: NODETYPE
function is_slave_node(){
  nodetype=${1}
  res="false"
  case "${nodetype}" in
  DATANODE) res="true";;
  NODEMANAGER) res="true";;
 esac
 echo ${res}
}

#arg1: path slave file
#arg2: hostname
function hostname_is_on_slave_file(){
 slave="${1}"
 hostname="${2}"
 res="false"

 if [ -f "${slave}" ]; then
  grep -Fxq "${hostname}" "${slave}" 2>&1 >/dev/null
  if [ "$?" = "0" ]
  then
   res="true"
  fi
 fi

 echo ${res}
}

function synchronize_all_conf_files(){
 log "[SYNCHRONIZE_ALL_CONF_FILES][INFO] Synchronize hosts file."
 cp -f ${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/etc/hosts /etc/hosts
 log "[SYNCHRONIZE_ALL_CONF_FILES][INFO] Synchronize hadoop files."
 cp -f ${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/* /etc/hadoop
 chmod -R 664 /etc/hadoop/* 2>&1 >/dev/null
 chmod -R 774 /etc/hadoop/*.sh 2>&1 >/dev/null

 case "${NODETYPE}" in
  HIVE)
   if [ -f "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/hive-site.xml" ]; then
    cp -f ${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/hadoop/hive-site.xml ${HIVE_HOME}/conf
   fi
  ;;
  SPARK)
   if [ -f "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/spark/spark-defaults.conf" ]; then
    cp -f ${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/spark/spark-defaults.conf ${SPARK_HOME}/conf
   fi
  ;;
 esac
}

function conf_get_cluster_name(){
res="my_cluster"
if [ $(find "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}" -maxdepth 1 -type f -name "*.yaml" | wc -l) -lt 1 ]
then
 log "[CONF_GET_CLUSTER_NAME][WARNING] No yaml configuration file found!"
else
 file_config=$(find "${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}" -maxdepth 1 -type f -name "*.yaml" | head -1)
 file_config_name=$(basename ${file_config})

 if [ "$(yaml_conf_exist_xpath ${file_config_name} cluster_name)" == "false" ]
 then
  log "[CONF_GET_CLUSTER_NAME][WARNING] No properties [cluster_name] found on file [${file_config}]!"
 else
  res="$(yaml_conf_get_env_global_properties ${file_config_name} "cluster_name")"
 fi
fi
echo ${res}
}

function synchronize_configs_process(){
 current_container_id="$1"
 synchronize_pipe="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/etc/synchronize_pipe"
 log "[SYNCHRONIZE_CONFIGS_PROCESS][INFO] Claim config resource.(${current_container_id})"
 echo "${current_container_id}" >> "${synchronize_pipe}"
 while true
 do
 	next_runner=$(head -n 1 ${synchronize_pipe})
 	if [ "${next_runner}" = "${current_container_id}" ]
 	then
 	 log "[SYNCHRONIZE_CONFIGS_PROCESS][INFO] Get config resource. ${current_container_id} = ${next_runner})"
 	 break
 	fi
 	sleep 1
 done
}

function release_configs_process(){
 current_container_id="$1"
 synchronize_pipe="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/etc/synchronize_pipe"
 log "[RELEASE_CONFIGS_PROCESS][INFO] ${current_container_id}"
 sed -i "/${current_container_id}/d" ${synchronize_pipe}
}

#signature path, user, perms, group
create_hdfs_path()
{
   local path="${1}"
   local user="${2}"
   local perms="${3}"
   local group="${4:-hadoop}"

   log "[CREATE_HDFS_PATH][INFO] ${path}|${user}|${perms}"
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -mkdir -p '${path}'" hdfs
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -chown '${user}:${group}' '${path}'" hdfs
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -chmod '${perms}' '${path}'" hdfs
}

add_hdfs_user()
{
   log "[ADD_HDFS_USER][INFO] /user/${1}" hdfs
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -mkdir -p '/tmp/hadoop-${1}'" hdfs
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -chown '${1}:hadoop' '/tmp/hadoop-${1}'" hdfs

   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -mkdir -p '/user/${1}'" hdfs
   su -c "/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs dfs -chown '${1}:hadoop' '/user/${1}'" hdfs
}
