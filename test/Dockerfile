FROM alpine:edge
MAINTAINER José Moreira <jose.moreira@findhit.com>
ADD test /bin/test-btsync
RUN apk --update add nfs-utils && \
    rm -fR /var/cache/apk/*
CMD [ "/bin/test-btsync" ]
