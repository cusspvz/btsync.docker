FROM alpine:edge
MAINTAINER José Moreira <jose.moreira@findhit.com>
RUN apk --update add bash nfs-utils && \
    rm -fR /var/cache/apk/*
ADD test.sh /bin/test-btsync
CMD [ "/bin/test-btsync" ]
