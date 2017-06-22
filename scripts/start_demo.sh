scripts/stop_demo.sh

source /home/geetha/telco-cdr-monitoring/scripts/ambari_util.sh

echo '*** Starting Storm....'
startWait STORM

echo '*** Starting HBase....'
startWait HBASE

echo '*** Starting Kafka....'
startWait KAFKA

echo '*** Starting Solr....'
sudo -u solr /opt/lucidworks-hdpsearch/solr/bin/solr start -c -z lake1.field.hortonworks.com:2181,lake2.field.hortonworks.com:2181,lake3.field.hortonworks.com:2181

echo '*** Starting Demo Flume....'
/home/geetha/telco-cdr-monitoring/scripts/start_flume.sh > /root/telco-cdr-monitoring/logs/flume.log 2>&1 &
echo "check logs at /root/telco-cdr-monitoring/logs/flume.log"

echo '*** Starting Demo Topology....'
/home/geetha/telco-cdr-monitoring/scripts/start_storm.sh > /root/telco-cdr-monitoring/logs/storm.log 2>&1 &
echo "check logs at /root/telco-cdr-monitoring/logs/storm.log"

echo '*** Starting Demo Producer....'
/home/geetha/telco-cdr-monitoring/scripts/start_cdr_producer.sh > /root/telco-cdr-monitoring/logs/producer.log 2>&1 &
echo "check logs at /root/telco-cdr-monitoring/logs/producer.log"