FROM progrium/busybox:latest
MAINTAINER José Moreira <jose.moreira@findhit.com>

########## GLOBAL ##########
ENV ARCH=x64
RUN opkg-install \
    wget tar gzip bash \
    shadow-groupadd shadow-useradd sudo \
    base-files libstdcpp;

# Remove default user and group
RUN awk '!/default/' /etc/group > /etc/group.default; \
    mv /etc/group.default /etc/group; \
    awk '!/default/' /etc/shadow > /etc/shadow.default; \
    mv /etc/shadow.default /etc/shadow; \
    awk '!/default/' /etc/passwd > /etc/passwd.default; \
    mv /etc/passwd.default /etc/passwd;

########## NODE ##########
ENV NODE_VERSION=0.12.0
ENV NODE_TAR=http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.gz
RUN mkdir -p /usr/local; \
    wget -O - ${NODE_TAR} | gunzip | tar -x -C /usr/local --strip-components 1; \
    npm i -g babel;

########## BTSYNC ##########
ENV BTSYNC_TAR=http://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_${ARCH}.tar.gz
RUN mkdir -p /usr/bin; \
    wget -O - ${BTSYNC_TAR} | gunzip | tar -x -C /usr/bin;
EXPOSE 55555/tcp 8888/tcp

########## NFS ##########
RUN opkg-install --force-depends nfs-kernel-server;
EXPOSE 111/udp 2049/tcp

########## APP ##########
WORKDIR /app
ADD ./ /app
RUN cd /app; \
    npm install; \
    ln -s /app/bin/ctl /sbin/ctl; \
    ln -s /app/bin/entrypoint /sbin/entrypoint; \
    chmod ugo+x /app/bin/*

VOLUME [ "/data" ]
ENTRYPOINT [ "/sbin/entrypoint" ]
