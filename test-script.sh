#!/bin/bash
export ROOT_PATH=$(pwd)
echo "*********************************ROOT PATH IS: $ROOT_PATH"
export AMBARI_HOST=$(hostname -f)
echo "*********************************AMABRI HOST IS: $AMBARI_HOST"
export CLUSTER_NAME=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/clusters |grep cluster_name|grep -Po ': "(.+)'|grep -Po '[a-zA-Z0-9\-_!?.]+')
# Configure Kafka

/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --zookeeper $AMBARI_HOST:2181 --replication-factor 1 --partitions 1 --topic cdr
