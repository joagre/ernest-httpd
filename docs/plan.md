# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-30. Ernest 0.9.0 was installed from its release archive on 2026-11-02, under a prefix of the user's, and milestone 1's items 1 to 6 were built against it the same day, the design's §2 and §4 to §13: the site served over plain HTTP and TLS, with the redirect listener and the hosts, the live shell over a WebSocket, the example site `make run` serves, and the deployment's files under `deploy/` with the smoke test, not yet run on the machine; archives that answered the feedback lines were installed that day as they came, each saying its commit, `ern 0.9.0+877fb5a6` the last.

The server's design is `docs/proposals/basic/proposal.md`, decided in Ernest's repository through 2026-10-30 and split here; what it asks of Ernest, TLS in `Tcp`, a pseudo-terminal in `Os` and four libraries, is Ernest's MVP 4.1, the WebSocket's frames a module of this program's since 2026-11-01 (the proposal's *WebSocket*, *The module*), whose first four items come before this milestone's build, and this repository builds against Ernest installed from a release archive.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the server serving the site

The proposal's order of work, each item a step of it, once Ernest's half is installed: Ernest's MVP 4.1 items 1 to 3 in an archive of `make release`, the milestone written once its item 1's sentences stand and built once items 2 and 3 do, and this milestone whole is that plan's item 4, what it finds of Ernest's going back there as CLAUDE.md says, before Ernest's items 5 and 6 close over it. Each item writes its sections of `docs/design.md` first, the proposal's text stated as rules and each section cited by a test, and then its code, so that the design is whole when the milestone closes.

1. **`Config` and `Static`**: done 2026-11-02, the log's *Item 1: the configuration and the static site*.
2. **`Listener`, `Connection` and `AccessLog`**, with the entry point: done 2026-11-02, the log's *Item 2: the listener, the connection and the access log*.
3. **TLS, the redirect listener and the hosts**: done 2026-11-02, the log's *Item 3: TLS, the redirect listener and the hosts*.
4. **`WebSocket`, `Shell`, `Sessions` and `Session`**: done 2026-11-02, the log's *Item 4: the WebSocket, the shell and the sessions*.
5. **The example site**: done 2026-11-02, the log's *Item 5: the example site*.
6. **The deployment**: done 2026-11-02, the log's *Item 6: the deployment* and *The seventh sweep: four lines from the deployment*.
7. **The release**, 0.1.0, by `docs/release.md`, when the server first serves the site.

**The caps after Ernest's collection at a wait (2026-11-02).** `deploy/config.json`'s connection caps are sized by §13's rule with a factor of five, what an idle connection holds after a response (the log's *Item 6: the deployment*). Ernest's MVP 4.15 moves the host's collection to the wait; when an archive carries it, the measurement under `docs/proposals/basic/measure/` is run again and the caps sized again by the rule, in the release that follows.
