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

**A refused value over lines (2026-11-03).** A configuration's refusal quotes a long array or object over the lines `Json.format` lays it on, until Ernest's one-line writer, `Json.encode`, Ernest's 224, planned in its MVP 4.15; `Config.reason` then writes the value on one line, in the release that follows.

**The listener's retry, a gap (2026-11-02).** §7's retry after an accept that fails otherwise than by `Closed` or its time has no test since item 2, which ended the acceptor at `Closed`; a test needs a host error an accept can be made to answer, `emfile` with the process's descriptors used up the nearest, and is written when one is found cheap, with the test that then cites the sentence.

**The shell after MVP 4.2 (2026-11-02, the site's place 2026-11-03).** The site publishes one page and no shell until Ernest's MVP 4.2 runs; then `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 installs the image and the wrapper (the log's *The wrapper and the smoke test's configuration*). The site itself is generated in Ernest's repository, `make site` there, the shell page one of its pages and the shell panel every page's, and is copied to the host as step 5 copies `site/` today; the `ernest-lang.org` repository holds the one page until the generated site goes live, and then goes (the log's *From the site's design*).

**Two nodes in the visitor's container (2026-11-03), waiting on Ernest (2026-11-04).** The homepage lets a visitor start a process on another node, so the container runs two: the image carries two configuration directories made by `ern config`, `a` and `foo`, `foo` listening on the loopback and each listing the other, each `ernest.conf` holding `"limits": {"processes": 65536, "ports": 4096}`, and the image's start copies both into the home, since the container is read-only and a node writes `ernest.pid` there, starts `foo`, waits for its `listening on` line, and runs `ern shell --config-dir a`.

Built and run on the server's machine on 2026-11-04, it answers the homepage's example, but a node there sizes its schedulers by the 32 processors the machine reports possible and not the 2 online, so the container needs about 167 threads and 145 MiB, past its caps; decided with the user, it waits for Ernest's answer to `language_feedback.md` line 24 and is built then, §13 stating the image, the start and the limits (the log's *Milestone 2, items 3 and 4*).

**A CPU cap per container (2026-11-03), with the two nodes.** The shell's command takes a CPU cap beside `--memory` and `--pids-limit`, so that a visitor's loop that never waits takes no core from the other visitors; on the server on 2026-11-04 the two-node start took 8.9 s to its first answer at `--cpus 0.5`, 4.3 s at 1 and 3.4 s uncapped, the one-node image 2.1 s at half a core, against the smoke test's 5 s. The cap is sized when the two nodes are built, with the threads line 24 decides. The move to four cores and 4 GB, `most-at-once` about 25, comes the first time the access log shows visitors turned away.

**The caps after Ernest's collection at a wait (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). Ernest's MVP 4.15 moves the host's collection to the wait; when an archive carries it, the measurement of the log's *Item 6: the deployment*, a file of 1 MiB and a hundred connections that read nothing, is run again and the caps sized again by the rule, in the release that follows.
