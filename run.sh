#!/bin/sh

if [ "$1" == "" ]; then
    echo "first parameter: hostname, i.e. zero4"
    exit 1
fi

if [[ $1 == zero21 || $1 == zero22 || $1 == zero23 ]]; then
    base_board=raspios-lite-arm64.json
elif [[ $1 == zero* ]]; then
    HCL=boards/raspios-lite-arm.pkr.hcl
else
    # FIXME
    HCL=boards/raspios-lite-arm64.pkr.hcl
fi

varsfile=packer.pkr.hcl
cat $HCL > $varsfile
cat <<DELIMITER >> $varsfile 
variable "hostname" {
type = string
default = "$1"
}
DELIMITER

docker compose build
docker compose run --rm builder build $varsfile

# cleanup
rm $varsfile


# without docker compose:
# docker build --tag rpi .
# sudo docker run --rm --privileged -v /dev:/dev -v .:/build rpi build packer.json
