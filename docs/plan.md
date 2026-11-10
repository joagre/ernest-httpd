# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.10 and builds against `ern 0.10.0`, Ernest's MVP 4.15 release, installed from its archive on 2026-11-10. Milestone 2 is under way: its steps on 0.10.0 are ready, and the rest waits on Ernest's MVP 4.4 release or on what the access log shows.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built. Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; item 9, the log's *Milestone 2, item 9: the reset under load*; and the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*.

### Now, on Ernest's 0.10.0

**Item 5, the rehearsal.** On Ernest's MVP 4.15 release, 0.10.0, as soon as it is out and before the steps below, the switch is rehearsed on the machine under a second unit on scratch ports, with the site Ernest's `make site` generates, the shell's member and the two-node image, the smoke test passing against it, while the live unit serves the one page on 0.1.0.

Ernest's session handed the site over on 2026-11-10: `make site TAG=v0.10.0` and `CONFIG=` the configuration this session names, which holds the shell's member, since the shell page states its limits from it. It writes the site to Ernest's `build/site/`, copied out as an archive is, every page's footer naming the release.

**Item 10, the library's own (2026-11-10).** 0.10.0's library holds what the program wrote for itself: `Http.target`, `Http.cookies` and `Http.cookie`, `Http.writeRequest`, `Http.http11` and `Http.defaultLimits` (Ernest's report, Appendix G.11), and `libs/uri`'s `Uri.parse`, `Uri.parseAuthority` and `Uri.decode` (G.12). `Static`, `Hosts`, `Config`, `Shell` and `Smoke` take them in place of their own, the design changing first where it states a rule the library now owns (the log's *Ernest 0.10.0*).

**The four lines in the test run.** The four lines the design has the program say leave the run, captured by `Test.capture`, Ernest's 225, which 0.10.0 carries (Appendix E.24; the log's *Milestone 2, item 2: quiet tests*).

**A refused value on one line (2026-11-03).** A configuration's refusal quotes a long array or object over the lines `Json.format` lays it on. With Ernest's one-line writer, `Json.encode`, its 224, which 0.10.0 carries (G.6), `Config.reason` writes the value on one line, in the release that follows.

**The server's signal in the tests (2026-11-04).** `Smoke.launch` learns the server's process number through `sh -c 'echo $$; exec ...'` and `Smoke.terminate` runs the host's `kill`, since `Os` sends a program it started no signal but the terminal's hangup. 0.10.0 carries Ernest's 233, `Os.signal` (E.23), and the two go: `Smoke.launch` keeps the program's address alone and `Smoke.terminate` sends it `Termination` (the log's *The twelfth sweep: the signal and the descriptors*).

**Item 8, the listener's retry (2026-11-04).** The test is written and steady, 20 runs in 20: the server run as a child under `ulimit -n 64`, connections held until an accept fails, the line `cannot accept: Io.Other("too many open files")` read, one more opened, which waits unaccepted, the held ones closed and that one answered at the next retry. It held only where the runtime had met its error path once, since the runtime loaded its own modules on first use and could not when the descriptors were spent; 0.10.0 carries Ernest's 234, a run loading them at its start (report §12). It is built now, `Smoke.launch` taking the limit as an `Optional(Int)` and the test in `src/listener.ern` (the log's *The listener's retry* and *Ernest 0.10.0*).

**The caps on 0.10.0 (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). No archive collects a process at its wait, and report §10 says a waiting process holds what it dropped until it runs again; that entry's measurement, a file of 1 MiB and a hundred connections that read nothing, is run once on 0.10.0, and the caps stand where it gives five again (the log's *Ernest 0.10.0*).

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
