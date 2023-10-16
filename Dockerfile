FROM mkaczanowski/packer-builder-arm:latest

RUN apt-get update
RUN apt-get install --yes python3 python3-pip

RUN python3 -m pip install ansible
