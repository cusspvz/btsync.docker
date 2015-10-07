FROM cusspvz/node:4.1.2
MAINTAINER José Moreira <jose.moreira@findhit.com>

ADD apks /tmp/apks

RUN apk --update add s6 nfs-utils && \
    apk add --allow-untrusted \
        /tmp/apks/glibc-2.21-r2.apk \
        /tmp/apks/glibc-bin-2.21-r2.apk \
        && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -fR /tmp/apks && \
    rm -fR /var/cache/apk/* && \
    echo "ALL:ALL" > /etc/hosts.allow && \
    echo "" > /etc/hosts.deny

ENV DEBUG="" \
    DATA_PATH=/data \
    HOST_DATA_PATH=/mnt/resources \
    BTSYNC_PID_PATH=/var/run/btsync.pid \
    BTSYNC_CONFIG_PATH=/data/btsync.conf \
    BTSYNC_CONFIG_INTERVAL_CHECK=10 \
    BTSYNC_USER=btysnc \
    BTSYNC_UID=1000 \
    BTSYNC_GROUP=btysnc \
    BTSYNC_GID=1000 \
    BTSYNC_HOME=/home/btsync \
    NFS=1 \
    NFS_NUM_SERVERS=8 \
    NFS_PORT=2049 \
    NODE_ENV=production

ADD bin /app/bin/
ADD s6 /app/s6/

ADD package.json /app/package.json
RUN npm install --production

RUN mkdir /data && \
    for bin in $(ls /app/bin/*); do \
        chmod +x $bin && \
        ln -s $bin /sbin/$(basename $bin); \
    done; \
    chmod +x /app/s6/*/*;

# NFS
EXPOSE 111/tcp $NFS_PORT/tcp $NFS_PORT/udp

# BTSync - comm + webui ports
EXPOSE 55555/tcp 8888/tcp

VOLUME $DATA_PATH
ENTRYPOINT [ "/sbin/entrypoint" ]
CMD [ "" ]
