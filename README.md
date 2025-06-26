<div align="center">

📨 <br/>Self-signer
=====

Docker image for generating self-signed certificates.

Image: `ghcr.io/gocom/self-signer` | [Container Registry](https://github.com/gocom/self-signer/pkgs/container/self-signer)

<hr/>

</div>

Docker image that generates a self-signed root and matching server certificate. This can be used for local development
environments to easily provide self-signed certificates for your web server. The root certificate can be imported
to OS' or browser's trusted certificates to allow HTTPS testing.

The generated server certificate is granted against the generated root certificate, which then can be loaded in
a web server or other server client. The server certificate is a wildcard certificate that is valid for the domain set
with `DOMAIN` environment variable, and it's subdomains.

Setup
-----

The **self-signer** image generates certificates to `/certificates` directory within the container, when the service
is started. New certificates are only generated, if the directory does not already contain the certificate files. The
directory can be mounted to the host system and from there to any other containers that would need the certificates. The
generated certificates can be configured with environment variables passed down to the container.

### With Docker Compose

Docker Compose is a common way to orchestrate containers in local development environments. When using Docker Compose,
the **self-signer** service and the generated certificates can be configured from your project's `compose.yml`
configuration file. For example:

```yml
services:
  self-signer:
    image: ghcr.io/gocom/self-signer:0.1.0
    volumes:
      - ./certificates:/certificates
    environment:
      - DOMAIN=example.test
```

In the above replace `1.0.0` with the version tag you want to use. It is recommended that you reference specific
version or hash. The image follows [Semantic Versioning](https://semver.org/).

When the project's services are started with Docker Compose, the **self-signer** service creates certificate files
to the mounted `certificates` directory, located in the project's root directory. The server certificate will be valid
for `example.test` domain, and it's subdomains.

If other services depend on the self-signer's certificates, try to add `depends_on`
declaration to the other dependant service. The `service_completed_successfully` condition can be used here, as by
default, the self-signer container only runs once, creating the certificates and then shutting down.

```yml
services:
  # ...
  nginx:
    # ...
    volumes:
      # ...
      - ./certificates:/certificates
    depends_on:
      # ...
      self-signer:
        condition: service_completed_successfully
```

Alternative, one could run the `self-signer` manually before starting other services:

```shell
$ docker compose run --rm self-signer
```

### Excluding files from version control

It is recommended that you exclude the root certificate key and pem from version control, so that unwanted parties can
not grant fraudulent signed certificates using it. For instance, if you are using git as the version control system, you
could add the following to your repository's root `.gitignore` file:

```gitignore
/certificates/*
!/certificates/root-ca.crt
!/certificates/certificate.crt
!/certificates/certificate.key
!/certificates/certificate.pem
```

The above will ignore all files under `certificates` directory, except the actual root certificate file,
and all server certificate files including the key. You can also ignore the root certificate and all server certificate
files, but the actual root certificate, the server certificate, and it's key are theoretically safe to commit to the
repository as long as you do not add the server certificate to your trusted certificates, but do trusting only using the
root certificate. Generally, no one will be able to generate new certificates validated by the root certificate as long
as they do not have the root certificate's key.

Environment variables
-----

The following environment variables can be used to customize the generated certificates.

| Variable                   | Default Value                   | Description                                                                                                                          |
|----------------------------|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `DOMAIN`                   | _empty_                         | Defines which domains the certificate is generated for. The generated certificate is valid for the given domain and it's subdomains. |
| `CERTIFICATE_DAYS`         | `3650`                          | How many days the generated root and server certificates are valid for.                                                              |
| `CERTIFICATE_COUNTRY`      | `US`                            | Certificate country code.                                                                                                            |
| `CERTIFICATE_STATE`        | `CA`                            | Certificate state code.                                                                                                              |
| `CERTIFICATE_ORGANIZATION` | `Self-signed Local Certificate` | Certificate organization.                                                                                                            |

Generated files
-----

The image will generate the following files into the `/certificates` directory inside the container, from where they can
be mounted to the host system:

| Filename          | Description                                                                                                                                                                                                                                                            |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `certificate.crt` | Generated server certificate. If neither `certificate.crt` and `certificate.key` exist, they are generated on the container startup, if the start up command is not overridden.                                                                                        |
| `certificate.key` | Generated unencrypted key for the server certificate. The key is not encrypted to allow easier use in local development environment's server clients.                                                                                                                  |
| `certificate.pem` | Generated server certificate in PEM format, containing both the key and the certificate.                                                                                                                                                                               |
| `root-ca.crt`     | Generated root certificate, that could be imported to host OS' trusted certificates.                                                                                                                                                                                   |
| `root-ca.key`     | Generated unencrypted key for the root certificate. Please avoid sharing or committing the root certificate key to your source repository. If both the `root-ca.crt` and `root-ca.key` exist, new server certificate is generated using the existing root certificate. |
| `root-ca.pem`     | Generated server certificate in PEM format, containing both the key and the certificate. Please avoid sharing or committing the PEM file to your source repository.                                                                                                    |

Advanced usage
-----

### Manually conditionally generating certificate, if it does not exist

If you need to manually invoke certificate generation, it can be performed by running the included `create-certificate`
utility. It will create new certificate, if one does not already exist:

```shell
docker run --rm --volume ./certificates:/certificates create-certificate
```

### Manually generating new certificates

If you need to manually generate new certificates, overwriting any existing ones, it can be performed by running
the included `create-root-certificate` and `create-server-certificate` utilities:

```shell
docker run --rm --volume ./certificates:/certificates create-root-certificate
docker run --rm --volume ./certificates:/certificates create-server-certificate
```

Please note that the above will overwrite any existing certificate files.

### Health check

The image also contains `health-check` utility, which can be used in cases where you need a long-running service,
or if you want to build conditional restarting based on whether the certificates still exist. An illustrative example
using Docker Compose:

```yml
services:
  # ...
  self-signer:
    image: ghcr.io/gocom/self-signer:0.1.0
    volumes:
      - ./certificates:/certificates
    environment:
      - DOMAIN=example.test
    command: /bin/sh -c 'create-certificate && tail -f /dev/null'
    healthcheck:
      test: ["CMD-SHELL", "health-check"]
      interval: 10s
      retries: 5
      start_period: 30s
      timeout: 10s
```

The `tail -f /dev/null` start up command override will make so that the service keeps running, allowing other service to
check the healthcheck status of the self-signer service.

Development
-----

See [CONTRIBUTING.md](https://raw.github.com/gocom/self-signer/master/CONTRIBUTING.md)
