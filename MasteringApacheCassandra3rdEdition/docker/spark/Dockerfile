FROM openjdk:8-jre-alpine

ENV SPARK_VERSION=2.3.1
ENV SPARK_HOME=/spark-$SPARK_VERSION-bin-hadoop2.7
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Download Spark binary and install required packages
RUN apk add --no-cache curl bash python procps coreutils \
    && curl -# https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz | tar zx \
    && sed "s/log4j.rootCategory=.*/log4j.rootCategory=ERROR, console/g" $SPARK_HOME/conf/log4j.properties.template > $SPARK_HOME/conf/log4j.properties

# Exposing required ports 4040(application) 7077(job submission) 8080(master web) 8081(worker web)
EXPOSE 4040 7077 8080 8081

# Entrypoint
COPY entrypoint.sh /tmp/entrypoint.sh
ENTRYPOINT /tmp/entrypoint.sh
