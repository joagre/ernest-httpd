# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-30. Ernest 0.9.0 was installed from its release archive on 2026-11-02, under a prefix of the user's, and milestone 1's item 1 was built against it the same day: the design's §4 and §5, `Config` and `Static`. The server's design is `docs/proposals/basic/proposal.md`, decided in Ernest's repository through 2026-10-30 and split here; what it asks of Ernest, TLS in `Tcp`, a pseudo-terminal in `Os` and four libraries, is Ernest's MVP 4.1, the WebSocket's frames a module of this program's since 2026-11-01 (the proposal's *WebSocket*, *The module*), whose first four items come before this milestone's build, and this repository builds against Ernest installed from a release archive.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the server serving the site

The proposal's order of work, each item a step of it, once Ernest's half is installed: Ernest's MVP 4.1 items 1 to 3 in an archive of `make release`, the milestone written once its item 1's sentences stand and built once items 2 and 3 do, and this milestone whole is that plan's item 4, what it finds of Ernest's going back there as CLAUDE.md says, before Ernest's items 5 and 6 close over it. Each item writes its sections of `docs/design.md` first, the proposal's text stated as rules and each section cited by a test, and then its code, so that the design is whole when the milestone closes.

1. **`Config` and `Static`**: done 2026-11-02, the log's *Item 1: the configuration and the static site*.
2. **`Listener`, `Connection` and `AccessLog`**, serving the site over plain HTTP: heads read through `Http.readHead` with the bytes carried over, the connection kept or closed, the two deadlines, and the Common Log Format lines appended in batches.
3. **TLS, the redirect listener and the hosts**: the canonical host and its redirects, port 80's ACME challenge, one certificate.
4. **`WebSocket`, `Shell` and `Sessions`**, last, since they stand on the rest: the frames and the accept value as the proposal's *The module* has them, the WebSocket, the session per cookie owning its command under `Os.startTerminal`, the lifetime, the takeover and the limits.
5. **The deployment**: the node's directory with the operator's shell listed, the systemd unit, certbot's certificate with the deploy hook, the podman image, and the smoke test against the deployed site, an attached shell's `:processes` at the server's node among it.
6. **The release**, 0.1.0, by `docs/release.md`, when the server first serves the site.

**A gap of Ernest's, 2026-11-02.** A path through a regular file, `/index.html/x`, a name longer than the host holds and a loop of links each make `Fs.stat` answer `Other` with the host's prose, so `Static` answers 500 where §5's 404 is due (`docs/language_feedback.md`, line 1). When a release of Ernest answers `NotFound` there, the item that installs it adds the three cases to `Static`'s tests and strikes this paragraph.
