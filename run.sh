#!/bin/sh

if [ "$1" == "" ]; then
    echo "first parameter: hostname, i.e. zero4"
    exit 1
fi

if [[ $1 == zero21 || $1 == zero22 || $1 == zero23 ]]; then
    base_board=raspios-lite-arm64.json
elif [[ $1 == zero* ]]; then
    base_board=raspios-lite-arm.json
else
    base_board=raspios-lite-arm64.json
fi

# generate a file with hostname as variable
varsfile=$(mktemp --suffix ".json")
echo $1 | jq -R '{"variables": {"hostname": .}}' > $varsfile

jq -s '.[0] * .[1] * .[2]' $varsfile boards/${base_board} boards/ansible-provisioner.json > packer.json

docker compose build
docker compose run --rm builder build packer.json

# cleanup
rm $varsfile


# without docker compose:
# docker build --tag rpi .
# sudo docker run --rm --privileged -v /dev:/dev -v .:/build rpi build packer.json
