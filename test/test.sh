#!/bin/bash

spaced_short () {
    echo; echo;
}
spaced_large () {
    spaced_short
    spaced_short
}
title () {
    spaced_short
    echo "---"
    echo "# $1"
}
subtitle () {
    echo
    echo "## $1"
}
debug () {
    echo "   $1"
}
final_return () {
    spaced_short
    echo "$2"
    spaced_large
    sleep 4
    exit $1;
}
throw () {
    echo "################################################"
    final_return "$1" "$2"
}

title "Test suite for BTSync image";
debug "NAMESPACE=$NAMESPACE";
debug "SECRET=$SECRET";

debug "test suite was initialized, waiting 10sec before harassing containers";
sleep 10;

###
subtitle "Trying to detect CONTAINERs";

CONTAINERS="";
for i in $(cat /etc/hosts | grep btsync- | grep -v bridge | cut -d"-" -f2); do
    debug "detected btsync-$i"
    CONTAINERS+=" btsync-$i";
done

[ -z "$CONTAINERS" ] && throw 1 "No containers were found."

###
subtitle "Checking if containers are alive";

for CONTAINER in $CONTAINERS; do
    ping -c 1 -w 5 "$CONTAINER" &>/dev/null && {
        debug "Container $CONTAINER is alive and pinging"
    } || {
        throw 2 "Error while pinging container $CONTAINER..."
    }
done


###
subtitle "Testing nfs mounting"

for CONTAINER in $CONTAINERS; do
    debug "making new dir on /tmp/nfs/$CONTAINER"
    mkdir -p /tmp/nfs/$CONTAINER;
    [ $? -ne 0 ] && throw 3 "Error creating a new folder on /tmp/nfs/$CONTAINER"

    debug "mounting nfs4:/$NAMESPACE into /tmp/nfs/$CONTAINER"
    mount -t nfs4 -o nolock,async $CONTAINER:/$NAMESPACE /tmp/nfs/$CONTAINER;
    [ $? -ne 0 ] && throw 4 "Error mounting nfs from container $CONTAINER"
done;

debug "waiting some 10 seconds for the nfs unblock"; sleep 10;

###
subtitle "Testing syncing consistency"

debug "$CONTAINER was last container..."
debug "I'm gonna write a 1MB file on NFS share. (/tmp/nfs/$CONTAINER/test_1MB)"
dd if=/dev/urandom of=/tmp/nfs/$CONTAINER/test_1MB bs=1M count=1 &> /dev/null
[ $? -ne 0 ] && throw 5 "Error creating test file on $CONTAINER over nfs"

debug "Sleeping 20 seconds to give time to the file to spread out"; sleep 20;
debug ""
debug "Time to test consistency..."
for CONTAINER in $CONTAINERS; do
    debug "Checking if container $CONTAINER has file in it..."
    [ ! -f "/tmp/nfs/$CONTAINER/test_1MB" ] && throw 6 "File not present on $CONTAINER" || \
    debug "OK"
done


final_return 0 "Tests exited successfully"
