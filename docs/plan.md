# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on, then what stands outside the milestones; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.10 and builds against `ern 0.10.0`, Ernest's MVP 4.15 release, installed from its archive on 2026-11-10. Milestone 2 is under way: its steps wait on Ernest's MVP 4.4 release, 0.11.0, whose archive of `271a0ba5` answers lines 28 to 30; the four cores wait on what the access log shows. Meanwhile the rehearsal's unit serves the shell client at https://ernest-lang.org:8443/, from a build of `75faac8`, for Ernest's side to be built against.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; item 8, the log's *Milestone 2, item 8: the listener's retry*; item 9, the log's *Milestone 2, item 9: the reset under load*; item 10, the log's *Milestone 2, item 10: the library's own*; item 11, the log's *The shell client*, *The shell client's design* and *Milestone 2, item 11: the shell client's build*; and item 5's rehearsal, the log's *Milestone 2, item 5: the rehearsal*.

Done too, the steps between them: the designed lines out of the test run, the log's *The lines in the test run*; the refused value on one line, the log's *A refused value on one line*; the server's signal in the tests, the log's *The server's signal in the tests*; the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*; the caps on 0.10.0, which stand, the log's *The caps on 0.10.0*; the listener's one closer, the log's *The listener's one closer*; the shell client's proposal read and swept, the log's *The shell client's proposal goes*; and the archive's tree, the log's *The archive's tree and the four cores*.

Done after them, from a reading of the design from outside: the shell's reader asked, with what else the reading found, the log's *The shell's reader asked*; the session's helpers, the log's *The session's helpers*; and the rehearsal's build, the log's *The rehearsal's build*.

### On Ernest's MVP 4.4 release

**The floor's rise.** When the reviews of Ernest's MVP 4.4 begin, the floor rises to 0.11, the minor of its release, on the archive of the commit its readers read, which Ernest's session names to the three repositories on the user's word (the log's *The floor at the reviews* and *The launch's minor*). The archive is installed, and each of Ernest's verdicts is checked against it by a probe: line 28 is its 249, line 29 its 250 and line 30 its 252, and each line goes, the log citing the number.

Two changes come with the rise. `Process.Calling` takes named fields, so the session's tests ask a helper's activity by a pattern and not by equality. `Http.target` reads a target a browser sends raw, percent-encoding `[`, `]`, `{`, `}` and the rest of G.11's set, so the server serves `GET /?a[]=1` and `GET /a[b]`: design §5's *The path* changes first where its rule moves, and the test that refuses a bad path with 400 holds what it now answers. Nothing of the program waits on line 28 or line 30 (the log's *Milestone 2, item 8: the listener's retry* and *The shell's reader asked*).

**Item 5, the release and the switch.** Once Ernest's release is tagged, the same week and after `ernest-template`'s release and `ernest-epx`'s, it is installed, and a release of this program is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag.

That release, with item 11's client, is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper (the log's *The wrapper and the smoke test's configuration*). The rehearsal's unit goes with it, with `/home/httpd/rehearsal/` and the shell's image of 0.9.0. Until then, design §11's messages stay as Ernest's site speaks them, and a change to them is told to Ernest's session before it is built.

Ernest's side goes live in the same switch, the one day both repositories change: the site's script calling the client, its generator taking no configuration, the shell page's numbers from the client's limits and a stub client in its browser test. Ernest's plan holds it as its MVP 4.4's item 6, beside that release (its MVP 4.6, and its log's *MVP 4.6 Before the Launch*).

The site, which Ernest's `make site TAG=` writes from the tag of the MVP 4.4 release into Ernest's `build/site/`, comes out as an archive does and is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). Before it is copied, its largest file is held against the 0.32 MiB the caps allow by §13's rule, and the caps are sized again where it is larger (the log's *The caps on 0.10.0*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

## Outside the milestones

What comes when its condition does, in no milestone.

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine* and *The archive's tree and the four cores*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
