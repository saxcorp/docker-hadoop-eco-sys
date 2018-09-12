#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh

log "[RUN][INFO]Create HDFS Spark directory."
add_hdfs_user spark
create_hdfs_path "/spark-logs" "spark" "1777"


case "${SPARK_SERVICE}" in
 MASTER)
  log "[RUN][INFO]Starting spark master. ${env}"
  su -c "${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master" spark
 ;;
 SLAVE)
  log "[RUN][INFO]Starting spark slave."
  su -c "${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker ${SPARK_MASTER}" spark
 ;;
 HISTORYSERVER)
  log "[RUN][INFO]Starting spark historyserver."
  su -c "${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.history.HistoryServer" spark
 ;;
 *) log "[RUN][ERROR] SPARK_SERVICE env is not define!";;
esac