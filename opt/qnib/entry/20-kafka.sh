#!/bin/bash

echo "[II] KAFKA_BROKER_ID=${KAFKA_BROKER_ID}"
echo "[II] SWARM_TASK_ID=${SWARM_TASK_ID}"
if [[ "X${KAFKA_BROKER_ID}" == "X" ]] && [[ "X${SWARM_TASK_ID}" != "X" ]];then
    KAFKA_BROKER_ID=$(echo ${SWARM_TASK_ID}-1 | bc)
else
    KAFKA_BROKER_ID=0
fi


mkdir -p /opt/kafka/config
echo "[II] Write config using: KAFKA_PORT=${KAFKA_PORT}, ZK_SERVERS=${ZK_SERVERS}, KAFKA_BROKER_ID=${KAFKA_BROKER_ID}, INTER_BROKER_PROTOCOL_VERSION=${INTER_BROKER_PROTOCOL_VERSION}, LOG_MESSAGE_FORMAT_VERSION=${LOG_MESSAGE_FORMAT_VERSION}"
cat /opt/qnib/kafka/conf/server.properties \
   | sed -e "s/KAFKA_PORT/${KAFKA_PORT}/" \
         -e "s/ZK_SERVERS/${ZK_SERVERS}/" \
         -e "s/KAFKA_BROKER_ID/${KAFKA_BROKER_ID}/" \
         -e "s/INTER_BROKER_PROTOCOL_VERSION/${INTER_BROKER_PROTOCOL_VERSION}/" \
         -e "s/LOG_MESSAGE_FORMAT_VERSION/${LOG_MESSAGE_FORMAT_VERSION}/" \
> /opt/kafka/config/server.properties

if [[ "X${ADVERTISED_LISTENERS}" != "X" ]];then
    echo "[II] Set listeners=PLAINTEXT://${ADVERTISED_LISTENERS}:${KAFKA_PORT}"
    sed -i'' -e "s;\(#\)listeners=.*;listeners=PLAINTEXT://${ADVERTISED_LISTENERS}:${KAFKA_PORT};g" /opt/kafka/config/server.properties
fi
