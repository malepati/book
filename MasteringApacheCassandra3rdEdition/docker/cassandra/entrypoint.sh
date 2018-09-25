#!/usr/bin/env bash
__start_cassandra(){
  su -m cassandra -c "cassandra -f"
}

__stop_cassandra(){
  echo 'Disabling Gossip > Draining node > Stopping cassandra'
  nodetool disablegossip
  nodetool drain
  kill -9 `ps -ef | grep $CASSANDRA_HOME | grep -v grep | awk '{ print $1 }'`
}

# Traping signal from pod
trap '__stop_cassandra; exit' TERM SIGTERM QUIT SIGQUIT INT SIGINT KILL SIGKILL

influxd >> /var/log/influxdb/influxdb.log 2>> /var/log/influxdb/influxdb.log &
service grafana-server start
service telegraf start
service jmxtrans start

curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE telegraf"
curl -X "POST" "http://localhost:3000/api/datasources" -H "Content-Type: application/json" --user admin:admin --data-binary @$GRAFANA_HOME/grafanaDataSource.json
curl -X "POST" -i "http://localhost:3000/api/dashboards/db" -H "Content-Type: application/json" --user admin:admin --data-binary @$GRAFANA_HOME/grafanaDashboard.json

chown -R cassandra:cassandra $CASSANDRA_HOME

__start_cassandra & wait ${!} || echo "======== Foreground processes returned code: '$?'"
