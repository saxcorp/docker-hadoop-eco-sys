#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[RUN][INFO]Create HDFS Hive directory."
add_hdfs_user hive
create_hdfs_path "/user/hive/warehouse" "hive" "1777"
create_hdfs_path "/tmp/hive" "hive" "1777"

case "${HIVE_SERVICE}" in
 HIVESERVER2)
  log "[RUN][INFO]Starting hiveserver2."
  su -c "${HIVE_HOME}/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false" hive
 ;;
 METASTORE)
  log "[RUN][INFO]Starting hive metastore."
  su -c "${HIVE_HOME}/bin/hive --service metastore" hive
 ;;
 *) log "[RUN][ERROR] HIVE_SERVICE env is not define!";;
esac