source /home/geetha/telco-cdr-monitoring/scripts/ambari_util.sh

echo '*** Starting Storm....'
startWait STORM

echo '*** Starting HBase....'
startWait HBASE

echo '*** Starting Kafka....'
startWait KAFKA

KAFKA_HOME=/usr/hdp/current/kafka-broker
TOPICS=`$KAFKA_HOME/bin/kafka-topics.sh --zookeeper lake1.field.hortonworks.com:2181,lake2.field.hortonworks.com:2181,lake3.field.hortonworks.com:2181 --list | grep cdr | wc -l`
if [ $TOPICS == 0 ]
then
	echo "No Kafka topics found...creating..."
	$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper lake1.field.hortonworks.com:2181,lake2.field.hortonworks.com:2181,lake3.field.hortonworks.com:2181 --replication-factor 1 --partitions 1 --topic cdr	
fi

mkdir /home/geetha/telco-cdr-monitoring/logs/

echo '*** Setup Solr....'
 /home/geetha/telco-cdr-monitoring/scripts/setup_solr.sh

echo '*** Create Phoenix Tables....'
/usr/hdp/current/phoenix-client/bin/sqlline.py lake1.field.hortonworks.com:2181:/hbase-secure:hbase-lake@LAKE:/etc/security/keytabs/hbase.headless.keytab /home/geetha/telco-cdr-monitoring/phoenix/cdr.sql

echo '*** Setup Hive...'
mkdir /usr/hdp/current/hive-client/auxlib
cp /usr/hdp/current/phoenix-client/phoenix-server.jar /usr/hdp/current/hive-client/auxlib/
chmod 755 -R /usr/hdp/current/hive-client/auxlib/

echo '*** Create Hive Tables...'
chmod -R +x /home/geetha/
chmod -R +r /home/geetha/
sudo -u hive hive -f  /home/geetha/telco-cdr-monitoring/hive/cdr.sql