#!/bin/bash

CONTAINER=$(docker run -d shivdrgn/chef-server)
CONTAINERIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})
CONTAINERHOSTNAME=$(docker inspect --format '{{ .Config.Hostname }}' ${CONTAINER})
echo "Container ID is $CONTAINER"
echo "Container IP is $CONTAINERIP"
echo

if egrep -q "^[^\n]+$CONTAINERHOSTNAME" /etc/hosts; then
	sed  -ri "s/^[^\n]+$CONTAINERHOSTNAME/$CONTAINERIP\t$CONTAINERHOSTNAME/" /etc/hosts
else
	echo "$CONTAINERIP  $CONTAINERHOSTNAME" >> /etc/hosts
fi

echo "/etc/hosts updated with $CONTAINERIP  $CONTAINERHOSTNAME"
echo
echo "Sleeping 5 minutes to wait for container to spin up."
echo
sleep 5m

echo "Copying pem files from container and placing in knife directory"
echo
cp /var/lib/docker/btrfs/subvolumes/$CONTAINER/etc/chef/*.pem /home/tim/.chef/


echo "Fetching SSL certificate from chef server using knife."
echo

knife ssl fetch
echo

echo "Checking SSL certicate with knife."
echo

knife ssl check
echo

echo "Script complete."
exit;
