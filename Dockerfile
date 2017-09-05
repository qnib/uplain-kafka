ARG DOCKER_REGISTRY=docker.io
FROM ${DOCKER_REGISTRY}/qnib/uplain-openjre8-prometheus

ARG KAFKA_VER=0.10.0.1
ARG API_VER=2.11
LABEL kafka.version=${API_VER}-${KAFKA_VER}
ENV KAFKA_PORT=9092 \
    ENTRYPOINTS_DIR=/opt/qnib/entry \
    PROMETHEUS_JMX_PROFILE=kafka \
    PROMETHEUS_JMX_ENABLE=false \
    ZK_SERVERS=zookeeper \
    ADVERTISED_LISTENERS=kafka_broker \
    INTER_BROKER_PROTOCOL_VERSION=0.10.0-IV1 \
    LOG_MESSAGE_FORMAT_VERSION=0.10.0-IV1
RUN apt-get update \
 && apt-get install -y curl netcat net-tools libsnappy-java \
 && curl -fLs http://apache.mirrors.pair.com/kafka/${KAFKA_VER}/kafka_${API_VER}-${KAFKA_VER}.tgz | tar xzf - -C /opt \
 && mv /opt/kafka_${API_VER}-${KAFKA_VER} /opt/kafka/
COPY opt/qnib/entry/20-kafka.sh /opt/qnib/entry/
COPY opt/qnib/kafka/bin/start.sh /opt/qnib/kafka/bin/
COPY opt/qnib/kafka/conf/server.properties /opt/qnib/kafka/conf/
COPY opt/prometheus/jmx/kafka.yml /opt/prometheus/jmx/
HEALTHCHECK --interval=2s --retries=15 --timeout=1s \
    CMD netstat -plnt |grep 9092
CMD ["/opt/qnib/kafka/bin/start.sh"]
