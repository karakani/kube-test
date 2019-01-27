#!/bin/bash

set -xe
source config.env


kubectl delete service $SERVICE_NAME
kubectl delete deployment $DEPLOYMENT_NAME


