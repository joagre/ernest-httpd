# ernest-httpd

*The Importance of Being Ernest, a Trivial Comedy for Serious People*

ernest-httpd serves one site, ernest-lang.org: static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell on the server. It implements what that needs of HTTP/1.1 and nothing more, and is written in Ernest against an installed Ernest. Its design is [`docs/design.md`](docs/design.md). This repository was begun from [`ernest-template`](https://github.com/joagre/ernest-template).

## Building

It needs [Ernest](https://ernest-lang.org) on your `PATH`, the floor the Makefile names, `ern 0.10`; `make` says so where another is found. `ERN=path/to/ern make` names another `ern`, which every target then runs, the tests and the example's shell among them. An Ernest installed under a prefix of your own, `make install PREFIX=<prefix>` in its unpacked archive, builds it with `ERN=<prefix>/bin/ern make`.

```
make            builds: lib/ filled, each dependency and then the program compiled
make test       the layout, every module's tests, test/ where it exists, each Ernest
                program of examples/, then the documents and the design's citations,
                failing any paragraph past 150 words and any comment or text a
                user reads that names the project's history
make run        runs the example site through the launcher, bin/ernest_httpd, on
                examples/site/config.json; CONFIG=path make run serves another configuration
make smoke      the smoke test against the deployed site whose canonical host HOST
                names, make smoke HOST=ernest-lang.org, the checks its configuration,
                deploy/config.json, takes
make xterm      fetches xterm.js and its fit addon into the example site, once
make release    the archive, build/ernest_httpd-VERSION.tar.gz, and its checksum beside it
make install    installs what stands built under PREFIX, /usr/local by default, from a
                checkout or an unpacked archive: make install PREFIX=/home/httpd/opt/local
make uninstall  removes from PREFIX what make install put there, then share/doc, share,
                lib and bin under it, each where it is empty, and nothing else
make man        each module's page into docs/man/, committed with each release
```

`make lib` fills `lib/` with each dependency `DEPS` names by the URL of its release archive, fetched and unpacked once, and each Erlang application `ERL_DEPS` names, a git submodule under `erl/` built by its own `make` and linked.

Everything the program loads beyond the standard library and Ernest's own libraries stands under `lib/`: a dependency's `build`, on the load path by `--load-path`, and an Erlang application's `ebin`, on it by `--libs-dir lib`. A repository with an `erl/` is cloned with `--recursive`. `make doc` writes each module's documentation under `build/`, `make format` lays the modules out, and `make clean` removes what the build, `make lib` and `make xterm` wrote.

## Running

The launcher runs the server on a configuration, from the checkout and from an unpacked release alike:

```
bin/ernest_httpd [--config-dir dir] config.json
```

Once `make install` has put it under a prefix, the installed `ernest_httpd` runs the same way, each with everything under its own `lib/` on the load path. `--config-dir dir` makes the run a node, as *Running Ernest*, the deployment guide of the installation, says.

The configuration is one JSON file, whose relative paths name files under the working directory. Every field of it but `shell` is required, an empty one written empty, `"content-types": {}`; the design's §4, [`docs/design.md`](docs/design.md), describes each field with its rule, and `examples/site/config.json` is one that `make run` serves, its access log's directory made first.

`make run` serves the example site under `examples/site/`, its pages and its shell, on localhost; [`examples/README.md`](examples/README.md) says what it shows and how to try it.

The server runs on its machine as [`deploy/README.md`](deploy/README.md) says, step by step, from the machine to `make smoke HOST=ernest-lang.org` passing, with the files of `deploy/` it installs; the smoke test reads `deploy/config.json` and checks the shell where it has one.

## The documents

[`docs/README.md`](docs/README.md) says what each document is.

The tests live in the modules they test, which `make test` runs; `test/`, where it exists, holds a program run end to end, and `tools/` the checker of the documents, `make test` runs them too.

## License

ernest-httpd is released under the Zero-Clause BSD license, 0BSD, the terms in [`LICENSE`](LICENSE). Third-party code, where there is any, is listed with its licenses in `THIRD_PARTY_LICENSES`.
