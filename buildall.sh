#!/bin/sh

for i in hadoop namenode datanode resourcemanager nodemanager historyserver hive hue spark ambari; do
    echo Building $i
    ( cd $i && ./build.sh)
done
