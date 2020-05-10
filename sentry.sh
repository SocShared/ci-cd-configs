#!/bin/bash
set -e

SERVICE_NAME=socshared_sentry
DOCKER_CMD=docker

TASK_ID=$(${DOCKER_CMD} service ps --filter 'desired-state=running' $SERVICE_NAME -q)
echo TASK_ID $TASK_ID
NODE_ID=$(${DOCKER_CMD} inspect --format '{{ .NodeID }}' $TASK_ID)
echo NODE_ID $NODE_ID
CONTAINER_ID=$(${DOCKER_CMD} inspect --format '{{ .Status.ContainerStatus.ContainerID }}' $TASK_ID)
echo CONTAINER_ID $CONTAINER_ID
TASK_NAME=swarm_exec_${RANDOM}
echo TASK_NAME $TASK_NAME

TASK_ID=$(${DOCKER_CMD} service create \
  --detach \
  --name=${TASK_NAME} \
  --restart-condition=none \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --constraint node.id==${NODE_ID} \
  docker:latest docker exec ${CONTAINER_ID} "sentry upgrade")

while : ; do
  STOPPED_TASK=$(${DOCKER_CMD} service ps --filter 'desired-state=shutdown' ${TASK_ID} -q)
  [[ ${STOPPED_TASK} != "" ]] && break
  sleep 1
done

${DOCKER_CMD} service logs --raw ${TASK_ID}
${DOCKER_CMD} service rm ${TASK_ID} > /dev/null