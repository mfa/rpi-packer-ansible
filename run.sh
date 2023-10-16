#!/bin/sh

if [ "$1" == "" ]; then
    echo "first parameter: hostname, i.e. zero4"
    exit 1
fi

if [[ $1 == zero* ]]; then
     base_board=raspios-lite-arm.json
fi

jq -s '.[0] * .[1]' boards/${base_board} boards/$1.json > packer.json

docker compose build
docker compose run --rm builder build packer.json

# docker build --tag rpi .
# sudo docker run --rm --privileged -v /dev:/dev -v .:/build rpi build packer.json
