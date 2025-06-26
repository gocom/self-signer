FROM debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/gocom/self-signer
LABEL org.opencontainers.image.description="Self-signed certificate generator"
LABEL org.opencontainers.image.licenses=MIT

ENV DOMAIN=""
ENV CERTIFICATE_DAYS=3650
ENV CERTIFICATE_COUNTRY=US
ENV CERTIFICATE_STATE=CA
ENV CERTIFICATE_ORGANIZATION="Self-signed Local Certificate"
ENV CERTIFICATES_DIRECTORY=/certificates

COPY ./bin /usr/local/bin

RUN apt-get update && apt-get install -y \
    openssl \
    && mkdir -p "$CERTIFICATES_DIRECTORY" \
    && chmod 777 "$CERTIFICATES_DIRECTORY" \
    && chmod +x /usr/local/bin/*

WORKDIR "$CERTIFICATES_DIRECTORY"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
