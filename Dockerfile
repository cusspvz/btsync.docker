FROM ubuntu:15.10
MAINTAINER José Moreira <jose.moreira@findhit.com>

ENV DEBIAN_FRONTEND noninteractive

########## BTSYNC ##########

RUN \
    apt-get update -y; \
#    apt-get upgrade -y; \
    apt-get install -y \
        wget nodejs nodejs-legacy npm \
    ; \
    npm i -g babel; \
	rm -rf /var/lib/apt/lists/*

RUN \
    wget -O - http://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz \
    | tar -xvz -C /usr/bin;

ADD . /app
RUN \
    cd /app; \
    npm install; \
    ln -s /usr/local/bin/ctl /app/bin/ctl; \
    ln -s /usr/local/bin/entrypoint /app/bin/entrypoint;
    chmod ugo+x /app/bin/*

EXPOSE 55555

WORKDIR /app

# Arguments: DIR SECRET
ENTRYPOINT [ "/app/bin/entrypoint" ]
