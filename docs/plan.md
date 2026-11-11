# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.10 and builds against `ern 0.10.0`, Ernest's MVP 4.15 release, installed from its archive on 2026-11-10. Milestone 2 is under way: item 11, the shell client Ernest asked for, is built and served, item 5's rehearsal serves it at https://ernest-lang.org:8443/ for Ernest's side to be built against, and the rest waits on Ernest's MVP 4.4 release or on what the access log shows.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; item 8, the log's *Milestone 2, item 8: the listener's retry*; item 9, the log's *Milestone 2, item 9: the reset under load*; item 10, the log's *Milestone 2, item 10: the library's own*.

Done too, the steps between them: the designed lines out of the test run, the log's *The lines in the test run*; the refused value on one line, the log's *A refused value on one line*; the server's signal in the tests, the log's *The server's signal in the tests*; the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*; and the caps on 0.10.0, which stand, the log's *The caps on 0.10.0*.

### Now, on Ernest's 0.10.0

**Item 5, the rehearsal.** Walked on 2026-11-10, once, with item 11's client (the log's *Milestone 2, item 5: the rehearsal*). Its second unit serves https://ernest-lang.org:8443/ for Ernest's side to be built against, and goes at the launch's switch, with `/home/httpd/rehearsal/` and the shell's image of 0.9.0.

Ernest's session handed the site over on 2026-11-10: `make site TAG=v0.10.0` and `CONFIG=` the configuration this session names, which holds the shell's member, since the shell page states its limits from it. It writes the site to Ernest's `build/site/`, copied out as an archive is, every page's footer naming the release.

**Item 11, the shell client (2026-11-10).** Ernest asked, on the user's word, that the server own both ends of its socket. Ernest's site knows the server today in three places, the messages its script speaks, the configuration its generator reads and the stub socket its browser test speaks, each a fact of the server's standing a second time in Ernest, and each goes for a client the server ships. The design runs in a design session beside the item sessions. The four asks:

- **A client.** A script the server ships and serves on the site's own host, at the path the site names for it, `/shell/client.js`, which the operator writes into the server's configuration. It holds no element of a page and no terminal; it opens the socket and speaks the messages. It offers a session by what it means: a start with a size, keys, a resize, an extension and a stop. It tells the output, the session attached and whether this browser joined it, the warning with its seconds, and each end by its name: expired, taken over, unavailable, stopped, or lost, which is every other close. A stop asked for before the session is attached is the client's to order.
- **The limits.** The client answers the limits the server enforces, without a session: the lifetime without a key, the warning before the end, the most sessions at once, and the starts an address may make and their window.
- **Never stale.** A page loaded whole runs the client of the server it talks to, never one a browser kept from the server before.
- **Its own test.** The client against a server the test starts itself, on the machine it runs on, in this repository.

The client's interface is stated in this design and cited from Ernest's site design note by its address.

The design is taken (2026-11-10): §14 states the client, its response, its module, its interface and its test, and §1, §4, §6, §13 and the glossary what each owns of it, from the proposal under `docs/proposals/shell-client/`, agreed with Ernest's session, whose site note cites §14 (the log's *The shell client's design*). Ernest's session was told the same day. The proposal stays as the record of its design until its reading and sweep, an item before this milestone's release, below.

The build is done (the log's *Milestone 2, item 11: the shell client's build*).

The server serves the client and answers the limits while it still speaks today's messages to the site as it stands, since this part adds and takes nothing away. Ernest's session was told so on 2026-11-10, and the rehearsal walked the switch with the client, item 5. Until the launch's switch, design §11's messages stay as Ernest's site speaks them, and a change to them is told to Ernest's session before it is built.

Ernest's side is built against that rehearsal's server: the site's script calling the client, its generator taking no configuration, the shell page's numbers from the client's limits and a stub client in its browser test. Both go live in item 5's switch, the one day both repositories change, the client in the release made for it (Ernest's plan, its MVP 4.6 and its MVP 4.4's item 6; its log's *MVP 4.6 Before the Launch*).

### On Ernest's MVP 4.4 release

**Item 5, the release and the switch.** When the reviews of Ernest's MVP 4.4 begin, the floor rises to the minor of its release, 0.11 or 0.12 as Ernest says, on the archive of the commit its readers read. Once that release is tagged, the same week and after `ernest-template`'s release and `ernest-epx`'s, it is installed, and a release of this program is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag.

**The proposal's reading and sweep.** Before that release, `docs/proposals/shell-client/` is read with the user for what it holds that no owner has yet, which goes to the design or the log, and the directory goes, its milestone's row naming the log entries that argue it, so that the release ships the owner and not the proposal. The six findings of the cold reading of §14's sentences are decided (the log's *The cold reading's six*).

That release, with item 11's client, is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper (the log's *The wrapper and the smoke test's configuration*).

The site, generated the same way from the tag of the MVP 4.4 release, is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (decided 2026-11-04, its release and its floor 2026-11-05, the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). Before it is copied, its largest file is held against the 0.32 MiB the caps allow by §13's rule, and the caps are sized again where it is larger (the log's *The caps on 0.10.0*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

Ernest's plan holds its side as its MVP 4.4's item 6, beside that release.

### When the access log shows visitors turned away

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
