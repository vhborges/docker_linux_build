#!/bin/bash

VERSION="Release"

CONTAINER_NAME="tdesktop-linux"
IMAGE_NAME="telegramdesktop/linux_build"

BIN_PATH="/TBuild/tdesktop/out/Release/Telegram"
DEST_PATH="."

docker run --name $CONTAINER_NAME $IMAGE_NAME 

docker cp ${CONTAINER_NAME}:${BIN_PATH} $DEST_PATH
