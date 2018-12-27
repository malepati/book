# DSS Cassandra Docker (3.11.2)

[![Build Status](https://drone6.target.com/api/badges/TDP/Cassandra-Docker-Repo/status.svg)](https://drone6.target.com/TDP/Cassandra-Docker-Repo) Common Cassandra Docker for **Data Store Services** built on [openjdk:8-jre-alpine](https://hub.docker.com/_/openjdk/)

### Creating Database locally:
```
git clone git@git.target.com:TDP/Cassandra-Docker-Repo.git
cd Cassandra-Docker-Repo
docker build -t docker.target.com/tdp/cassandra:latest --build-arg CASSANDRA_VERSION=apache-cassandra-3.11.2 .
docker run --name app1 --hostname 'csapp1-0' \
-p=9042:9042 -p=7199:7199 -p=8080:8080 \
-e 'databaseName=app1' \
docker.target.com/tdp/cassandra:latest
```
By default creates 3 users `nosqldba, <databaseName>mgr, <databaseName>read` and if dbaPassword, casPassword, mgrPassword and readPasswordcreates are not set then `changeit` would be default password for all users including cassandra user. Metrics can be viewed at [http://localhost:8080/metrics](http://localhost:8080/metrics)

Pre-requisite: Docker should be installed

### Paths:
```
# installation
/usr/lib/jvm/java-1.8-openjdk
/usr/lib/cassandra
# ENV(i.e. JAVA_HOME and CASSANDRA_HOME) is set through environment
/etc/environment
# conf/data/log
$CASSANDRA_HOME/{conf,data,logs}
```

### Reference Docs:
* [Docker at Target](https://wiki.target.com/tgtwiki/index.php/Docker)
* [Dockerfile](https://docs.docker.com/engine/reference/builder/#format)
* [Prometheus](https://github.com/prometheus/jmx_exporter)
* [Drone6 for Docker](http://readme.drone.io/usage/getting-started/)
* [Dockerfile](https://devhints.io/dockerfile)
* [Alpine Packages](https://pkgs.alpinelinux.org/packages)
