#!/usr/bin/env bash

docker build -t saxcorp/ambari_postgresql ./ambari-postgresql/
docker build -t saxcorp/ambari_server ./ambari-server/