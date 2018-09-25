FROM centos:7

ENV INFLUXDB_HOME=/etc/influxdb
ENV GRAFANA_HOME=/etc/grafana
ENV TELEGRAF_HOME=/etc/telegraf
ENV JMXTRANS_HOME=/etc/jmxtrans
ENV CASSANDRA_VERSION=3.11.2
ENV CASSANDRA_HOME=/usr/lib/cassandra
ENV CASSANDRA_CONF=/usr/lib/cassandra/conf
ENV PATH=$PATH:$CASSANDRA_HOME/bin:$CASSANDRA_HOME/tools/bin

# Download Cassandra binary, create cassandra user & group
RUN yum -y install java initscripts sudo urw-fonts && yum clean all \
    && rpm -ivh https://dl.influxdata.com/influxdb/releases/influxdb-1.6.2.x86_64.rpm \
    && rpm -ivh https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.2.4-1.x86_64.rpm \
    && rpm -ivh https://dl.influxdata.com/telegraf/releases/telegraf-1.7.4-1.x86_64.rpm \
    && rpm -ivh http://central.maven.org/maven2/org/jmxtrans/jmxtrans/270/jmxtrans-270.rpm \
    && curl -# http://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-3.11.2-bin.tar.gz | tar zx -C /usr/lib --transform=s/apache-cassandra-3.11.2/cassandra/ \
    && groupadd cassandra \
    && useradd -g cassandra cassandra

COPY files_to_copy/grafana* $GRAFANA_HOME/
COPY files_to_copy/telegraf* $TELEGRAF_HOME/
COPY files_to_copy/jmxtrans* /var/lib/jmxtrans/
COPY files_to_copy/cassandra* $CASSANDRA_HOME/conf/

# Attaching data volume
VOLUME $CASSANDRA_HOME/data

# Exposing required ports 3000(grafana) 7000(nossl) 7199(jmx) 8086(influxdb) 9042(client)
EXPOSE 3000 7000 7199 8086 9042

# Entrypoint
COPY entrypoint.sh /tmp/entrypoint.sh
ENTRYPOINT /tmp/entrypoint.sh
