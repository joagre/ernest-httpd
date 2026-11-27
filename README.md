# ernest-httpd

*The Importance of Being Ernest, a Trivial Comedy for Serious People*

ernest-httpd is the web server of [ernest-lang.org](https://ernest-lang.org), written in [Ernest](https://github.com/joagre/ernest). It does two things:

- It serves the site's pages over HTTP/1.1 and TLS, with what one site needs of the protocol and nothing more: `GET` and `HEAD`, no request body, no ranges, no compression.
- It gives each visitor a shell. The terminal in the page opens a WebSocket, and the server runs a program under a terminal for that visitor and carries the keys and the output between the two. A visitor who reloads the page comes back to the same session. On ernest-lang.org the program is `ern shell` in a container.

It serves the client as well, the JavaScript module a page imports to speak to its shell.

Every part of the server is a process that owns one thing: a listener the connections of its socket, a connection its socket, a session one visitor's program and its deadline. Each has a mailbox whose type names every message it takes, so the compiler has checked each send between them.

The access log is the smallest of them. Its mailbox's type and its loop:

```ernest
export type LogMsg =
    Entry(remote : String, time : Int, request : Optional(String), status : Int, size : Int)
  | Flush(Reply(Unit))

fn logging(path : Path, ms : Int) : Unit receiving LogMsg = {
    let messages = receive {
        message -> waiting([message])
    };
    match List.filterMap(messages, line) {
        [] -> Unit
      | lines -> appended(path, lines, ms)
    };
    List.forEach(messages, fn(message) = match message {
        Flush(reply) -> answer(reply, Unit)
      | _ -> Unit
    });
    logging(path, ms)
}

fn waiting(acc : List(LogMsg)) : List(LogMsg) receiving LogMsg =
    receive {
        message -> waiting(message :: acc)
      | after 0 -> List.reverse(acc)
    }
```

A connection sends it an `Entry` for each response it has written. The process takes one message and every other that waits, and appends their lines to the file in one write. So a busy server opens the file once for many lines, with no count and no timer to tune. `Flush` is the program's end, asking that every entry sent before it be written.

To see the server at work, open [ernest-lang.org](https://ernest-lang.org) and press Try it. To run it on your own machine, with the Ernest that *Building* names on your `PATH`:

```
git clone https://github.com/joagre/ernest-httpd.git
cd ernest-httpd
make run
```

It serves the example site at http://localhost:8080, whose shell page runs your own `ern shell`, fetching xterm.js, the page's terminal, from registry.npmjs.org by `curl` on its first run. [`examples/README.md`](examples/README.md) says what the site shows, with a `curl` line for each answer a browser hides.

[`docs/design.md`](docs/design.md) states the program as rules: each process and what it owns, each module's job, the configuration, and what the server leaves out of HTTP/1.1 and WebSocket. This repository was begun from [`ernest-template`](https://github.com/joagre/ernest-template).

## Building

It needs [Ernest](https://ernest-lang.org) on your `PATH`, the release `package.conf` names or a later one; an `ern` before 0.11 stops `make` at its first step, `ern: no job unpack`. Before Ernest's 1.0 a later release may refuse the program, and the program is then brought to that release. `ERN=path/to/ern make` names another `ern`: its directory stands first on `PATH` for everything the build starts, so whatever names `ern` by its name, a test or the example's shell, runs that one too. A file not called `ern` is not reached this way. An Ernest installed under a prefix of your own, `make install PREFIX=<prefix>` in its unpacked archive, builds it with `ERN=<prefix>/bin/ern make`. `make test` needs Chromium too, `chromium` on `PATH`, Debian's package of that name, since the client's test runs the client in it.

```
make            # builds the program
make test       # in a checkout: every module's tests, the client's in Chromium, then the documents' check;
                # its tests serve the shell of the example for seconds at a time, as you
make run        # runs the example site through the launcher, bin/ernest_httpd, on
                # examples/site/config.json; CONFIG=path make run serves another configuration
make smoke      # the smoke test against the deployed site whose canonical host HOST
                # names, make smoke HOST=ernest-lang.org, the checks its configuration,
                # deploy/config.json, takes
make release    # the archive, build/ernest_httpd-VERSION.tar.gz, and its checksum beside it,
                # built with a release's ern, whose version text has no + and no -dev,
                # from committed files alone
make install    # builds, then installs under PREFIX, /usr/local by default, from a
                # checkout or an unpacked archive: make install PREFIX=/home/httpd/opt/local
make uninstall  # removes from PREFIX what make install put there, as the design's §13 says
```

The program loads nothing beyond Ernest's standard library: `package.conf` names Ernest's release and no package. The Makefile's head lists every target with what it does, `make xterm`, `make doc`, `make format` and `make clean` among them.

## Running

The launcher runs the server on a configuration, from the checkout and from an unpacked release alike:

```
bin/ernest_httpd [--config-dir dir] config.json
```

Once `make install` has put it under a prefix, the installed `ernest_httpd` runs the same way, by its path or by a link to it. An installed program runs under the `ern` that built it, and once that `ern` changes, `make install` from the program's archive builds it again. `--config-dir dir` makes the run a node, as *Running Ernest*, the deployment guide of the installation, says.

The configuration is one JSON file, whose relative paths name files under the working directory. Every field of it but `shell` is required, an empty one written empty, `"content-types": {}`; the design's §4, [`docs/design.md`](docs/design.md), installed with this README under the prefix's share/doc, is its reference, each member as the file spells it with its rule, and `examples/site/config.json` is one that `make run` serves, its access log's directory made first.

`make run` serves the example site under `examples/site/`, its pages and its shell, on localhost; [`examples/README.md`](examples/README.md) says what it shows and how to try it.

The server runs on its machine as [`deploy/README.md`](deploy/README.md) says, step by step, from the machine to `make smoke HOST=ernest-lang.org` passing, with the files of `deploy/` it installs; the smoke test reads `deploy/config.json` and checks the shell where it has one.

## The documents

In the repository, `docs/README.md` says what each document is.

The tests live in the modules they test, and `tools/` holds the documents' check; `make test` runs both.

## License

ernest-httpd is released under the Zero-Clause BSD license, 0BSD, the terms in [`LICENSE`](LICENSE).
