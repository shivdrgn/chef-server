#!/bin/bash

NODENAME=node$(cat /dev/urandom | tr -cd '0-9' | head -c 5)
CONTAINER=$(docker run -d -e ROOT_PASS="mypass" tutum/ubuntu:trusty)
CONTAINERIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})
echo "Container = $CONTAINER"
echo "ContainerIP = $CONTAINERIP"
knife bootstrap $CONTAINERIP -N $NODENAME -x root -P mypass --sudo 

