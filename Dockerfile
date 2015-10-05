FROM cusspvz/node:0.12.7
MAINTAINER José Moreira <jose.moreira@findhit.com>

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
    NFS_PORT=2049

RUN mkdir /data && \
    apk --update add \
        bash s6 \
        wget ca-certificates \
        nfs-utils \
    && \
    mkdir -p /tmp/glibc && cd /tmp/glibc && \
    wget --no-check-certificate \
        "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
        "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    cd / && \
    rm -fR /tmp/glibc && \
    rm -fR /var/cache/apk/* && \
    echo "ALL:ALL" > /etc/hosts.allow && \
    echo "" > /etc/hosts.deny && \
    for bin in $(ls /app/bin/*); do \
        chmod +x $bin && \
        ln -s $bin /sbin/$(basename $bin); \
    done; \
    chmod +x /app/s6/*/*;

# NFS
EXPOSE 111/tcp $NFS_PORT/tcp $NFS_PORT/udp

# BTSync - comm + webui ports
EXPOSE 55555/tcp 8888/tcp

VOLUME [ $DATA_PATH ]
ENTRYPOINT [ "/sbin/entrypoint" ]
CMD [ "" ]
