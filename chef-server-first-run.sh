#!/bin/bash

CONTAINER=$(docker run -d shivdrgn/chef-server)
CONTAINERIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})
echo "Container ID is $CONTAINER"
echo "Container IP is $CONTAINERIP"
echo

if egrep -q "^[^\n]+chef-server" /etc/hosts; then
	sed  -ri "s/^[^\n]+chef-server/$CONTAINERIP\tchef-server/" /etc/hosts
else
	echo "$CONTAINERIP  chef-server" >> /etc/hosts
fi

echo "/etc/hosts updated with $CONTAINERIP  chef-server"
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
