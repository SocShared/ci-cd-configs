#!/bin/bash
set -e

SERVICE_NAME=socshared_sentry
DOCKER_CMD=docker

TASK_ID=$(${DOCKER_CMD} service ps --filter 'desired-state=running' $SERVICE_NAME -q)
NODE_ID=$(${DOCKER_CMD} inspect --format '{{ .NodeID }}' $TASK_ID)
CONTAINER_ID=$(${DOCKER_CMD} inspect --format '{{ .Status.ContainerStatus.ContainerID }}' $TASK_ID)
TASK_NAME=swarm_exec_${RANDOM}