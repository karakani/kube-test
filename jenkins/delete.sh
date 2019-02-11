#!/bin/bash

set -x

source ./global.env
source config.env


kubectl delete --namespace jenkins service $SERVICE_NAME
kubectl delete --namespace jenkins statefulset $DEPLOYMENT_NAME
kubectl delete namespace jenkins

