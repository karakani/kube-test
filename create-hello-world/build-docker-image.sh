#!/bin/bash

set -e
DIR=$(dirname $0)
source $DIR/config.env


docker build \
    --tag $IMG_HELLO_WORLD \
    --tag $MY_ADDRESS:5000/$REPO_NAME/$IMG_HELLO_WORLD:latest \
    --rm \
    "$DIR/hello-world"

docker push $MY_ADDRESS:5000/$REPO_NAME/$IMG_HELLO_WORLD:latest
