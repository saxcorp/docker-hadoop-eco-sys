#!/usr/bin/env bash

wait_for_db() {
  while : ; do
    PGPASSWORD=ambari psql -d ambari -h ambari-postgresql -U ambari -c "select 1"
    [[ $? == 0 ]] && break
    sleep 5
  done
}

ambari-server setup --silent --java-home ${JAVA_HOME} \
                             --database postgres \
                             --databasehost ambari-postgresql \
                             --databaseport 5432 \
                             --databasename ambari \
                             --postgresschema ambari \
                             --databaseusername ambari \
                             --databasepassword ambari

wait_for_db

ambari-server start

tail -f -n 100 /var/log/ambari-server/ambari-server.log
