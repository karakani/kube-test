#!/bin/bash

set -e
source ./config.env

DATA_DIR=$DATA_ROOT/docker-registry

docker pull registry

if [ ! -d "$DATA_DIR" ]; then
    sudo mkdir -p $DATA_DIR
fi

docker run -d \
      -p 5000:5000 \
      -v $DATA_DIR:/var/lib/registry \
      registry 

