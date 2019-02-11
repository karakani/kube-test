#!/bin/bash

set -e

source ../global.env
source config.env

YAML_DATA=$(cat <<END_OF_FILE
kind: Namespace
apiVersion: v1
metadata:
  name: jenkins


---
kind: StatefulSet
apiVersion: apps/v1
metadata:
  name: $DEPLOYMENT_NAME
  namespace: jenkins
spec:
  replicas: 1
  revisionHistoryLimit: 5
  serviceName: $SERVICE_NAME
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
      - name: jenkins
        image: $REPO_HOST/$REPO_NAME/$IMAGE
        ports:
        - containerPort: 8080
          protocol: TCP
        volumeMounts:
        - name: jenkins-home
          mountPath: /var/jenkins_home
        livenessProbe:
          httpGet:
            scheme: HTTP
            path: /static/994e1798/images/title.png
            port: 8080
          initialDelaySeconds: 5400
          timeoutSeconds: 180
      volumes:
      - name: jenkins-home
        hostPath:
          path: /opt/volumes/jenkins
          type: Directory
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule

---
kind: Service
apiVersion: v1
metadata:
  name: $SERVICE_NAME
  namespace: jenkins
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: $APP_NAME
  externalIPs:
  - $MY_EXTERNAL_ADDRESS


END_OF_FILE
)

echo "Following resources are to be created:"
echo "--------------------------------------"
echo "$YAML_DATA"
echo
echo "--------------------------------------"

kubectl apply -f <(echo "$YAML_DATA")

