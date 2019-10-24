FROM google/cloud-sdk:alpine

RUN apk --update add bash git ca-certificates openssl

COPY delete_by_timestamp.sh /usr/local/bin/delete_by_timestamp.sh

RUN chmod 0755 /usr/local/bin/delete_by_timestamp.sh