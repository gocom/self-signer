FROM debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/gocom/self-signer
LABEL org.opencontainers.image.description="Self-signed certificate generator"
LABEL org.opencontainers.image.licenses=MIT

ENV DOMAIN ""
ENV CERTIFICATE_DAYS 3650
ENV CERTIFICATE_COUNTRY US
ENV CERTIFICATE_STATE CA
ENV CERTIFICATE_ORGANIZATION "Self-signed Local Certificate"
ENV CERTIFICATES_DIRECTORY /certificates

ENV HOST_UID 1000
ENV HOST_GID 1000

ENV CERTIFICATE_UID 9000
ENV CERTIFICATE_GID 9000
ENV CERTIFICATE_USER cert
ENV CERTIFICATE_GROUP cert

COPY ./bin /usr/local/bin

RUN apt-get update && apt-get install -y \
    gosu \
    openssl \
    && groupadd -g "$CERTIFICATE_GID" "$CERTIFICATE_GROUP" \
    && useradd -m -u "$CERTIFICATE_UID" -g "$CERTIFICATE_GROUP" "$CERTIFICATE_USER" \
    && mkdir -p "$CERTIFICATES_DIRECTORY" \
    && chmod 777 "$CERTIFICATES_DIRECTORY" \
    && chown "$CERTIFICATE_USER:$CERTIFICATE_GROUP" "$CERTIFICATES_DIRECTORY" \
    && chmod +x /usr/local/bin/*

WORKDIR "$CERTIFICATES_DIRECTORY"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
