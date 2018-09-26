#!/usr/bin/env bash
__stop_spark(){
  echo 'Stopping Spark'
  ps -ef | grep spark | grep -v grep | awk '{print $2}' |  xargs kill
}

# Traping signal from pod
trap '__stop_spark; exit' TERM SIGTERM QUIT SIGQUIT INT SIGINT KILL SIGKILL

EXTRA_PARAMETERS=""

[ -z $CS_CONSISTENCY ] && CS_CONSISTENCY=LOCAL_QUORUM

# Setting Authentication parameters if they exists
if [ ! -z $CS_HOST ] && [ ! -z $CS_DC ]; then
  if [ ! -z $CS_UNAME ]; then
    if [ ! -z $CS_PWD ]; then
      EXTRA_PARAMETERS+="--conf spark.cassandra.auth.username=$CS_UNAME --conf spark.cassandra.auth.password=$CS_PWD "
    else
      echo 'CS_UNAME and CS_PWD are mandatory for successful authentication, if authentication is not enabled on Cassandra then remove from env while running docker container else please set them'
      exit
    fi
  fi
  EXTRA_PARAMETERS+="--conf spark.cassandra.input.consistency.level=$CS_CONSISTENCY "
  if [ ! -z $TRUSTSTORE_PATH ]; then
    if [ ! -z $TRUSTSTORE_PWD ]; then
      EXTRA_PARAMETERS+="--conf spark.cassandra.connection.ssl.enabled=true --conf spark.cassandra.connection.ssl.trustStore.path=$TRUSTSTORE_PATH --conf spark.cassandra.connection.ssl.trustStore.password=$TRUSTSTORE_PWD"
    else
      echo 'TRUSTSTORE_PATH and TRUSTSTORE_PATH are mandatory, for successful ssl connection hence please set them'
      exit 1
    fi
  fi
else
  echo 'CS_HOST and CS_DC are mandatory, hence please set them'
  exit 1
fi

__start_spark(){
  pyspark --packages com.datastax.spark:spark-cassandra-connector_2.11:2.3.0 \
  --master spark://127.0.0.1:7077 \
  --conf spark.driver.host=127.0.0.1 \
  --conf spark.cassandra.connection.host=$CS_HOST \
  --conf spark.cassandra.connection.local_dc=$CS_DC \
  $EXTRA_PARAMETERS
}

echo 'Starting Master'
start-master.sh -h 127.0.0.1
echo 'Starting Woker'
start-slave.sh -h 127.0.0.1 spark://127.0.0.1:7077

__start_spark || echo "======== Foreground processes returned code: '$?'"
