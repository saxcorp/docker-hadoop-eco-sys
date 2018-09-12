#!/usr/bin/env bash

docker build -t saxcorp/hadoop_2.7.3_hive-postgressql ./hive-postgresql/
docker build -t saxcorp/hadoop_2.7.3_hive-server ./hive-server/

