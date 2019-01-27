#!/bin/bash

set -e
source config.env

YAML_DATA=$(cat <<END_OF_FILE
# reference: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $DEPLOYMENT_NAME
  labels:
    app: $APP_NAME
spec:
  replicas: 3
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
      - name: $APP_NAME
        image: $MY_ADDRESS:5000/$REPO_NAME/$IMG_HELLO_WORLD
        ports:
        - containerPort: 80
---
# reference: https://kubernetes.io/docs/concepts/services-networking/service/
kind: Service
apiVersion: v1
metadata:
  name: $SERVICE_NAME
spec:
  selector:
    app: $APP_NAME
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  externalIPs:
  - $MY_EXTERNAL_ADDRESS
END_OF_FILE
)

echo "Following resources are to be created:"
echo "--------------------------------------"
echo "$YAML_DATA"
echo
echo

kubectl apply -f <(echo "$YAML_DATA")

