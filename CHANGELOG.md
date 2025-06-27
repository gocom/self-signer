# Changelog

## 0.2.0

* Add `HOST_UID` and `HOST_GID` mapping support using environment variables. If the container is started as root,
  maps the default start up command's running user and group to the specified UID and GID. This will make so that the
  user created files are owned by the `HOST_UID` and `HOST_GID`.

## 0.1.0

* Initial release.
