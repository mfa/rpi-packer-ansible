FROM mkaczanowski/packer-builder-arm:1.0.8

RUN apt-get update
RUN apt-get install --yes python3 python3-pip

RUN python3 -m pip install ansible passlib
