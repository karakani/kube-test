#!/bin/bash

# exit on error
set -e


# load configs

source ../global.env
source config.env


# pull docker files from github

if [ ! -d docker ]; then
  git clone git@github.com:jenkinsci/docker.git
fi

cd docker > /dev/null

git pull


# now, build image. build-arg specifies jenkins version to build.
# edit config.env to specify the version.
LAST_LINE=$(docker build --build-arg JENKINS_VERSION="$JENKINS_VERSION" --build-arg JENKINS_SHA="$JENKINS_SHA" --file Dockerfile-alpine . | tee /dev/stderr | tail -n 1)


# extract image hash from build output.
if echo "$LAST_LINE" | grep "^Successfully built " > /dev/null ; then
  IMAGE_HASH=$(echo "$LAST_LINE" | cut -d ' ' -f 3)
else
  echo failure: $LAST_LINE
  exit 1
fi

docker tag "$IMAGE_HASH" $REPO_HOST/$REPO_NAME/$IMAGE

echo "Image($IMAGE_HASH) has been made and tagged: $REPO_HOST/$REPO_NAME/$IMAGE"

