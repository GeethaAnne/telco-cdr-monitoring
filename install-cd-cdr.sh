#!/bin/bash
export ROOT_PATH=$(pwd)
echo "*********************************ROOT PATH IS: $ROOT_PATH"
# export INTVERSION=$(echo $VERSION*10 | bc | grep -Po '([0-9][0-9])')
# echo "*********************************HDP VERSION IS: $VERSION"

export VERSION=`hdp-select status hadoop-client | sed 's/hadoop-client - \([0-9]\.[0-9]\).*/\1/'`
export INTVERSION=$(echo $VERSION*10 | bc | grep -Po '([0-9][0-9])')
echo "*********************************HDP VERSION IS: $VERSION"

export AMBARI_HOST=$(hostname -f)
echo "*********************************AMABRI HOST IS: $AMBARI_HOST"

export CLUSTER_NAME=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/clusters |grep cluster_name|grep -Po ': "(.+)'|grep -Po '[a-zA-Z0-9\-_!?.]+')

ZK_HOST=$AMBARI_HOST
export ZK_HOST=$ZK_HOST
