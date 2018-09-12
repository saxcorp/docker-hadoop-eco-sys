#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

function exit_user(){
 id -u "$1" > /dev/null 2>&1; echo $?
}

function create_local_user_hadoop(){
 if [ $(exit_user "hadoop") = "0" ]; then
  log "[CREATE_LOCAL_USER_HADOOP][WARNING] User hadoop already exist!"
  exit 1
 else
  useradd -d /home/hadoop -m hadoop

  chown -R hadoop:hadoop /usr/local/hadoop-${HADOOP_VERSION}

  mkdir -p /var/log/hadoop
  chown hadoop:hadoop /var/log/hadoop
  chmod g+w /var/log/hadoop
 fi
}

function create_local_user_hdfs(){
 if [ $(exit_user "hdfs") = "0" ]; then
  log "[CREATE_LOCAL_USER_HDFS][WARNING] User hdfs already exist!"
  exit 1
 else
  useradd -d /home/hdfs -m -G hadoop hdfs
  mkdir -p /hadoop/dfs/name /hadoop/dfs/sname1
  chown -R hdfs:hdfs /hadoop/dfs
 fi
}

function create_local_user_mapred(){
 if [ $(exit_user "mapred") = "0" ]; then
  log "[CREATE_LOCAL_USER_MAPRED][WARNING] User mapred already exist!"
  exit 1
 else
  useradd -d /home/mapred -m -G hadoop mapred
 fi
 mkdir -p "/tmp/hadoop-mapred"
 chown  mapred:hadoop "/tmp/hadoop-mapred"
 chmod 1750 "/tmp/hadoop-mapred"
}

function create_local_user_yarn(){
 if [ $(exit_user "yarn") = "0" ]; then
  log "[CREATE_LOCAL_USER_YARN][WARNING] User yarn already exist!"
  exit 1
 else
  useradd -d /home/yarn -m -G hadoop yarn

  mkdir -p /hadoop/yarn/nm-local /hadoop/yarn/staging
  chown -R yarn:hadoop /hadoop/yarn

  mkdir -p /tmp/hadoop-yarn/nm-local-dir
  chown -R yarn:hadoop /tmp/hadoop-yarn
  chmod -R 1775 /tmp/hadoop-yarn

  mkdir -p "/tmp/logs"
  chown yarn:hadoop "/tmp/logs"
  chmod 1755 "/tmp/logs"
 fi
}

function create_local_user_hive(){
 if [ $(exit_user "hive") = "0" ]; then
  log "[CREATE_LOCAL_USER_HIVE][WARNING] User hive already exist!"
  exit 1
 else
  useradd -d /home/hive -m -G hadoop hive

  mkdir -p /var/log/hive
  chown hive:hadoop /var/log/hive
  chmod g+w /var/log/hive
 fi
}

function create_local_user_spark(){
 if [ $(exit_user "spark") = "0" ]; then
  log "[CREATE_LOCAL_USER_SPARK][WARNING] User spark already exist!"
  exit 1
 else
  useradd -d /home/spark -m -G hadoop spark

  mkdir -p /var/log/spark
  chown spark:hadoop /var/log/spark
  chmod g+w /var/log/spark

 fi
}

case "$1" in
 hadoop) create_local_user_hadoop ;;
 hdfs)   create_local_user_hdfs ;;
 mapred) create_local_user_mapred ;;
 yarn)   create_local_user_yarn ;;
 hive)   create_local_user_hive;;
 spark)  create_local_user_spark;;
esac
