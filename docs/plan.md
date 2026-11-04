# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-30. Ernest 0.9.0 was installed from its release archive on 2026-11-02, under a prefix of the user's, and milestone 1's items 1 to 6 were built against it the same day, the design's §2 and §4 to §13: the site served over plain HTTP and TLS, with the redirect listener and the hosts, the live shell over a WebSocket, the example site `make run` serves, and the deployment's files under `deploy/` with the smoke test, which the server passed on its machine on 2026-11-02, serving https://ernest-lang.org, and release 0.1.0 made that day by `docs/release.md`; archives that answered the feedback lines were installed that day as they came, each saying its commit, the archive from Ernest's `3497c257` the last, `ern 0.10.0+3497c257`, installed 2026-11-03, the floor moved to 0.10 with it.

The server's design is `docs/design.md`, argued in the log from a proposal decided in Ernest's repository through 2026-10-30, split here and folded into the two on 2026-11-02 with the first release; what it asks of Ernest, TLS in `Tcp`, a pseudo-terminal in `Os` and four libraries, is Ernest's MVP 4.1, the WebSocket's frames a module of this program's since 2026-11-01 (the log's *WebSocket is the server's*), whose first four items come before this milestone's build, and this repository builds against Ernest installed from a release archive.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

1. **The refusal's form**: done 2026-11-02, the log's *Milestone 2, item 1: the refusal's form*.
2. **Quiet tests**: done 2026-11-02, the log's *Milestone 2, item 2: quiet tests*; the four lines the design has the program say stay in the run until Ernest's test runner can capture a case's standard error, Ernest's 225, planned in its MVP 4.15.
3. **The attach's word**: done 2026-11-04, the log's *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*.
4. **A restart at the cap**: done 2026-11-04, the same entry.
5. **The rehearsal and the release on Ernest 1.0**: on the archive of Ernest's MVP 4.15 release, as soon as it is out, the switch is rehearsed on the machine under a second unit on scratch ports, with the site Ernest's `make site` generates, the shell's member and the two-node image, the smoke test passing against it, while the live unit serves the one page on 0.1.0; once Ernest 1.0.0 is released, the floor rises to 1.0, a release of this program is made by `docs/release.md`, its readers among it, and it is installed in one switch on the path the rehearsal walked, `deploy/config.json` taking the shell's member and step 7 building the image (decided 2026-11-04, the log's *The release before the site*).

   Ernest's plan holds its side as its MVP 4.4's item 6, beside its 1.0.0 release. The site comes as Ernest's session hands it over at its MVP 4.15's close: `make site TAG=` that release's tag and `CONFIG=` the configuration this session names, which holds the shell's member, since the shell page states its limits from it; it writes the site to Ernest's `build/site/`, copied out as an archive is, every page's footer naming the release.

6. **Three cleanups**: done 2026-11-04, the log's *Three cleanups*.
7. **The code reader**: done 2026-11-04, the log's *The code reader's findings*.
8. **The listener's retry**: §7's retry after an accept that fails otherwise than by `Closed` or its time, untested since item 2, tested by the server run as a child process under a low limit of open files, `ulimit -n`, so that an accept fails with too many open files; dropped to a gap again if it cannot be made steady (the same entry).

**A refused value over lines (2026-11-03).** A configuration's refusal quotes a long array or object over the lines `Json.format` lays it on, until Ernest's one-line writer, `Json.encode`, Ernest's 224, planned in its MVP 4.15; `Config.reason` then writes the value on one line, in the release that follows.

**The shell after Ernest 1.0 (2026-11-02, the site's place 2026-11-03, its time 2026-11-04).** The site publishes one page and no shell until item 5 installs the release on Ernest 1.0; then `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 installs the image and the wrapper (the log's *The wrapper and the smoke test's configuration*). The site itself is generated in Ernest's repository, `make site` there, the shell page one of its pages and the shell panel every page's, and is copied to the host as step 5 copies `site/` today; the `ernest-lang.org` repository holds the one page until the generated site goes live, and then goes (the log's *From the site's design*).

**Two nodes in the visitor's container and a CPU cap**: built 2026-11-04, the log's *Two nodes and a core*; on the site with the shell's member, at item 5. The move to four cores and 4 GB, `most-at-once` about 25, comes the first time the access log shows visitors turned away.

**The caps after Ernest's collection at a wait (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). Ernest's MVP 4.15 moves the host's collection to the wait; when an archive carries it, the measurement of the log's *Item 6: the deployment*, a file of 1 MiB and a hundred connections that read nothing, is run again and the caps sized again by the rule, in the release that follows.
