# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.10 and builds against `ern 0.10.0+14a7c50c`, installed from its archive by 2026-11-06. Milestone 2 is under way: every step waits on a release of Ernest's, its MVP 4.15 or its MVP 4.4, or on what the access log shows.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built. Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; and the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*.

### On Ernest's MVP 4.15

**Item 9, a reset under load (2026-11-07).** With twelve clients connecting at once, about one HTTPS connection to https://ernest-lang.org in twenty to forty is reset during the TLS handshake, curl saying `Recv failure: Connection reset by peer`. The cause is the listener's backlog, the host's 5, which no option changes (Ernest's report, Appendix E.18): a SYN past it is answered by a syncookie, and a ClientHello of two segments, as a post-quantum key share makes it, is reset where its first segment finds the accept queue full. Ernest took `language_feedback.md`'s line 27 as its 248, its MVP 4.15 item 48: a listener takes the largest backlog the host takes, 4096 on Linux by default. Nothing here goes around it (the log's *Milestone 2, item 9: the reset under load*).

The probe that closes it, run on the archive that carries 248: the server in a user network namespace, `unshare -rn`, its loopback at MTU 1500 with 20 ms each way by `tc netem`, pinned to two processors, and 20 rounds of `seq 12 | xargs -P 12` curls over TLS, which on `0.10.0+14a7c50c` reset 5 to 14 of 240. It closes when none is reset, and line 27 goes then, before item 5's switch, since a launch brings such bursts.

**The four lines in the test run.** The four lines the design has the program say stay in the run until Ernest's test runner can capture a case's standard error, Ernest's 225; with the archive that carries it they leave the run (the log's *Milestone 2, item 2: quiet tests*).

**A refused value on one line (2026-11-03).** A configuration's refusal quotes a long array or object over the lines `Json.format` lays it on. With the archive that carries Ernest's one-line writer, `Json.encode`, Ernest's 224, `Config.reason` writes the value on one line, in the release that follows.

**The server's signal in the tests (2026-11-04).** `Smoke.launch` learns the server's process number through `sh -c 'echo $$; exec ...'` and `Smoke.terminate` runs the host's `kill`, since `Os` sends a program it started no signal but the terminal's hangup. Ernest's 233, its MVP 4.15 item 9, decides whether `Os` sends the termination signal, and the two follow it in the archive that carries it (the log's *The twelfth sweep: the signal and the descriptors*).

**Item 8, the listener's retry (2026-11-04).** The test is written and steady, 20 runs in 20: the server run as a child under `ulimit -n 64`, connections held until an accept fails, the line `cannot accept: Io.Other("too many open files")` read, the held ones closed and the unserved one answered at the next retry. It holds only where the runtime has met its error path once, since the runtime loads its own modules on first use and cannot when the descriptors are spent, Ernest's 234, its MVP 4.15 item 20. It is built with the archive that carries 234, `Smoke.launch` taking the limit as an `Optional(Int)` and the test in `src/listener.ern` (the log's *The listener's retry*).

**The caps after Ernest's collection at a wait (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). Ernest's MVP 4.15 moves the host's collection to the wait; with the archive that carries it, that entry's measurement, a file of 1 MiB and a hundred connections that read nothing, is run again and the caps sized again by the rule, in the release that follows.

**Item 5, the rehearsal.** On Ernest's MVP 4.15 release, 0.10.0, as soon as it is out, the switch is rehearsed on the machine under a second unit on scratch ports, with the site Ernest's `make site` generates, the shell's member and the two-node image, the smoke test passing against it, while the live unit serves the one page on 0.1.0.

The rehearsal's site comes as Ernest's session hands it over at its MVP 4.15's close: `make site TAG=` that release's tag and `CONFIG=` the configuration this session names, which holds the shell's member, since the shell page states its limits from it. It writes the site to Ernest's `build/site/`, copied out as an archive is, every page's footer naming the release.

### On Ernest's MVP 4.4 release

**Item 5, the release and the switch.** When the reviews of Ernest's MVP 4.4 begin, the floor rises to the minor of its release, 0.11 or 0.12 as Ernest says, on the archive of the commit its readers read. Once that release is tagged, the same week and after `ernest-template`'s release and `ernest-epx`'s, it is installed, and a release of this program is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag.

That release is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper (the log's *The wrapper and the smoke test's configuration*). The site, generated the same way from the tag of the MVP 4.4 release, is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (decided 2026-11-04, its release and its floor 2026-11-05, the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

Ernest's plan holds its side as its MVP 4.4's item 6, beside that release.

### When the access log shows visitors turned away

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
