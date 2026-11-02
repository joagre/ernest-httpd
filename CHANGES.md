# Changes

Each release's note, newest first, from the first release on; the release step writes a release's section before its tag and copies it to the release on GitHub, so that the note is written once (`docs/release.md`). A section says what the release is and lists each change on one line naming where it is read, the design's section or the log's entry that owns it, and restates nothing.

## 0.1.0, 2026-11-02

The first release: the HTTP/1.1 server of ernest-lang.org, an Ernest program on `ern 0.9`, serving a static site over plain HTTP and TLS with a redirect listener and its hosts, a live shell over a WebSocket, an example site, and its deployment under systemd, installed on its machine on 2026-11-02 and serving https://ernest-lang.org. There is no previous release, so nothing changes for anyone.

- The configuration, one JSON file, each field with its rule and its error: design §4.
- The static site, its files and types, the conditional request, the directory's slash and the 404 page: §5.
- The connection, HTTP/1.1 with its deadlines and limits, one write a response: §6.
- The listener, its acceptor and its caps on connections: §7.
- The access log, one process appending by path: §8.
- The hosts, the canonical host's 301 and 421, and the redirect listener on 80 with the challenge directory: §9.
- The WebSocket's frames, client and server side: §10.
- The shell page's protocol over the WebSocket, and the sessions behind it with their program, lifetime and caps: §11, §12.
- The deployment, `deploy/` as installed, `make install`, `make uninstall`, `make smoke` and the operator's steps: §13 and `deploy/README.md`.
- The example site `make run` serves, with its shell page: `examples/README.md`.

The design is `docs/design.md` whole, there being no earlier tag to diff against, and the log's entries are all of `docs/log.md`, *Begun from the template* through *The wrapper and the smoke test's configuration*.
