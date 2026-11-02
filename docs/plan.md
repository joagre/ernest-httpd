# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-30. Ernest 0.9.0 was installed from its release archive on 2026-11-02, under a prefix of the user's, and milestone 1's items 1 to 6 were built against it the same day, the design's §2 and §4 to §13: the site served over plain HTTP and TLS, with the redirect listener and the hosts, the live shell over a WebSocket, the example site `make run` serves, and the deployment's files under `deploy/` with the smoke test, which the server passed on its machine on 2026-11-02, serving https://ernest-lang.org, and release 0.1.0 made that day by `docs/release.md`; archives that answered the feedback lines were installed that day as they came, each saying its commit, `ern 0.9.0+181641e2` the last.

The server's design is `docs/design.md`, argued in the log from a proposal decided in Ernest's repository through 2026-10-30, split here and folded into the two on 2026-11-02 with the first release; what it asks of Ernest, TLS in `Tcp`, a pseudo-terminal in `Os` and four libraries, is Ernest's MVP 4.1, the WebSocket's frames a module of this program's since 2026-11-01 (the log's *WebSocket is the server's*), whose first four items come before this milestone's build, and this repository builds against Ernest installed from a release archive.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

1. **The refusal's form**: done 2026-11-02, the log's *Milestone 2, item 1: the refusal's form*.
2. **Quiet tests**: `make test` prints no fault's trace and no `cannot accept: Closed` among its passes; each test ends what it started in the design's order, and a message the end prints is decided in §2 or goes (the cold reader's finding 10, 2026-11-02).

**The shell after MVP 4.2 (2026-11-02).** The site publishes one page and no shell until Ernest's MVP 4.2 runs; then `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 installs the image and the wrapper (the log's *The wrapper and the smoke test's configuration*).

**The caps after Ernest's collection at a wait (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). Ernest's MVP 4.15 moves the host's collection to the wait; when an archive carries it, the measurement of the log's *Item 6: the deployment*, a file of 1 MiB and a hundred connections that read nothing, is run again and the caps sized again by the rule, in the release that follows.
