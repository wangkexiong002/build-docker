FROM alpine:3.15 as BASE

ARG AMC_VERSION=5.0.0
RUN wget https://github.com/aerospike-community/amc/releases/download/${AMC_VERSION}/aerospike-amc-enterprise-${AMC_VERSION}-linux.tar.gz \
    && cd /home \
    && tar xzvf /aerospike-amc-enterprise-*.tar.gz \
    && sed -i 's/errorlog = ".*"/errorlog = "\/dev\/stdout"/g' etc/amc/amc.conf

## AMC 4.0 has been rewritten in Go.
#
FROM scratch

COPY --from=BASE /home /

EXPOSE 8081

ENTRYPOINT ["/opt/amc/amc"]

