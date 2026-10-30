# ernest-httpd

*The Importance of Being Ernest, a Trivial Comedy for Serious People*

ernest-httpd serves one site, ernest-lang.org: static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell on the server. It implements what that needs of HTTP/1.1 and nothing more, and is written in Ernest against an installed Ernest. Its design is [`docs/proposals/basic/proposal.md`](docs/proposals/basic/proposal.md) until `docs/design.md` states it; what it asks of Ernest is Ernest's own proposal, https://github.com/joagre/ernest/blob/main/docs/proposals/httpd/proposal.md. This repository was begun from [`ernest-template`](https://github.com/joagre/ernest-template).

## Building

It needs [Ernest](https://github.com/joagre/ernest) on your `PATH`, the floor the Makefile names, `ern 0.6`; `make` says so where another is found. `ERN=path/to/ern make` names another `ern`. This repository builds against Ernest installed from its release archive, as a user installs it, and never against Ernest's source tree: `make release` in an Ernest checkout writes `ern-VERSION.tar.gz`, which unpacks and installs with `make install PREFIX=<prefix>` into a directory of your own, and `ERN=<prefix>/bin/ern make` builds against it. What the installation's documents leave opaque or unsaid is a line of `language_feedback.md`, carried to Ernest, and never looked up in its source.

```
make            builds: lib/ filled, each dependency and then the program compiled
make test       the layout, every module's tests, the documents and the design's citations,
                listing without failing any paragraph past about a hundred words,
                test/ and examples/ where they exist
make run        runs the program through its launcher, bin/ernest_httpd
make release    the archive, build/ernest_httpd-VERSION.tar.gz
make man        a library's manual pages into docs/man/, committed with its release
```

`make lib` fills `lib/` with each dependency `DEPS` names by the URL of its release archive, fetched and unpacked once, and each Erlang application `ERL_DEPS` names, a git submodule under `erl/` built by its own `make` and linked.

Everything the program loads beyond the standard library and Ernest's own libraries stands under `lib/`: a dependency's `build`, on the load path by `--load-path`, and an Erlang application's `ebin`, on it by `--libs-dir lib`. A repository with an `erl/` is cloned with `--recursive`. `make doc` writes each module's documentation under `build/`, `make format` lays the modules out, and `make clean` removes what the build and `make lib` wrote.

## Running

`bin/<name> [--config-dir dir] [argument]...` runs the program from the checkout and from an unpacked release alike, with everything under `lib/` on the load path. `--config-dir dir` makes the run a node, as *Running Ernest*, the deployment guide of the installation, says; everything else goes to the program.

## The documents

- [`docs/design.md`](docs/design.md): how the program is arranged, the normative document of this repository, and the glossary of its names.
- [`docs/plan.md`](docs/plan.md): where the program stands and what comes next.
- [`docs/log.md`](docs/log.md): the dated rationale, never normative.
- [`docs/release.md`](docs/release.md): what a release runs to be ready.
- `docs/proposals/`: what is designed, a directory for each proposal, from the first one on.
- `language_feedback.md`, from its first line: what writing Ernest felt against the principles, carried to Ernest by copy.
- [`CLAUDE.md`](CLAUDE.md): the working rules.

The tests live in the modules they test, which `make test` runs; `test/`, where it exists, holds a program run end to end, and `tools/` the checker of the documents, `make test` runs them too.

## License

ernest-httpd is released under the Zero-Clause BSD license, 0BSD, the terms in [`LICENSE`](LICENSE). Third-party code, where there is any, is listed with its licenses in `THIRD_PARTY_LICENSES`.
