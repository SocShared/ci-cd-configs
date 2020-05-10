#!/bin/bash
set -e

SERVICE_NAME=socshared_sentry

TASK_ID=$(sudo docker service ps --filter 'desired-state=running' $SERVICE_NAME -q)
NODE_ID=$(sudo docker inspect --format '{{ .NodeID }}' $TASK_ID)
CONTAINER_ID=$(sudo docker inspect --format '{{ .Status.ContainerStatus.ContainerID }}' $TASK_ID)
NODE_HOST=$(sudo docker node inspect --format '{{ .Description.Hostname }}' $NODE_ID)
export DOCKER_HOST="tcp://$NODE_HOST:2376"
sudo docker exec -it $CONTAINER_ID "sentry upgrade"
sudo docker exec -it $CONTAINER_ID "sentry createuser --email vladovchinnikov950@gmail.com --password admin --superuser --no-input"