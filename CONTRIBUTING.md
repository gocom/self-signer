Contributing
=====

License
-----

[MIT](https://raw.github.com/gocom/self-signer/master/LICENSE).

Versioning
----

[Semantic Versioning](https://semver.org/).

Development
-----

To list available commands, run:

```
$ make help
```

Building
-----

The image is built and published automatically by CI. To manually build the Docker image, run:

```
$ make build
```

Configure git
-----

For convenience your committer, git user, should be linked to your GitHub account:

```
$ git config --global user.name "John Doe"
$ git config --global user.email john.doe@example.com
```

Make sure to use an email address that is linked to your GitHub account. It can be a throwaway
address or you can use GitHub's email protection features. We don't want your emails, but this is to make sure
we know who did what. All commits nicely link to their author, instead of them coming from ``foobar@invalid.tld``.
