# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on, then what stands outside the milestones; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.10 and builds against `ern 0.10.0`, Ernest's MVP 4.15 release, installed from its archive on 2026-11-10. Milestone 2 is under way: its steps wait on Ernest's MVP 4.4 release, 0.11.0, whose archive of `f8e17816`, made on 2026-11-21 and not installed, holds Ernest's answers to lines 28 to 34 and a `Tcp.close` that waits for its bytes; line 35 is Ernest's 270, planned after the launch; the four cores wait on what the access log shows. Meanwhile the rehearsal's unit serves the shell client at https://ernest-lang.org:8443/, from a build of `75faac8`, with Ernest's side built and walked against it, which waits only on the launch's switch.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; item 8, the log's *Milestone 2, item 8: the listener's retry*; item 9, the log's *Milestone 2, item 9: the reset under load*; item 10, the log's *Milestone 2, item 10: the library's own*; item 11, the log's *The shell client*, *The shell client's design* and *Milestone 2, item 11: the shell client's build*; and item 5's rehearsal, the log's *Milestone 2, item 5: the rehearsal*.

Done too, the steps between them: the designed lines out of the test run, the log's *The lines in the test run*; the refused value on one line, the log's *A refused value on one line*; the server's signal in the tests, the log's *The server's signal in the tests*; the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*; the caps on 0.10.0, which stand, the log's *The caps on 0.10.0*; the listener's one closer, the log's *The listener's one closer*; the shell client's proposal read and swept, the log's *The shell client's proposal goes*; and the archive's tree, the log's *The archive's tree and the four cores*.

Done after them, from a reading of the design from outside: the shell's reader asked, with what else the reading found, the log's *The shell's reader asked*; the session's helpers, the log's *The session's helpers*; and the rehearsal's build, the log's *The rehearsal's build*.

Done from the reviews from outside: the hostile inputs' tests, the log's *Three points from outside* and *The hostile inputs' tests*; and the stop time, 130 seconds against a silent peer's 85, the log's *The stop time at 85 seconds*.

### On Ernest's MVP 4.4 release

**The floor's rise.** When the reviews of Ernest's MVP 4.4 begin, the floor rises to 0.11, the minor of its release, on the archive of the commit its readers read, which Ernest's session names to the three repositories on the user's word (the log's *The floor at the reviews* and *The launch's minor*). The archive is installed, and each of Ernest's verdicts is checked against it by a probe: line 28 is its 249, line 29 its 250, line 30 its 252, line 31 its 262, line 32 its 263, line 33 its 266 and line 34 its 267, and each line goes, the log citing the number.

Two changes come with the rise. `Process.Calling` takes named fields, so the session's tests ask a helper's activity by a pattern and not by equality. `Http.target` reads a target a browser sends raw, percent-encoding `[`, `]`, `{`, `}` and the rest of G.11's set, so the server serves `GET /?a[]=1` and `GET /a[b]`: design §5's *The path* changes first where its rule moves, and the test that refuses a bad path with 400 holds what it now answers. Nothing of the program waits on line 28 or line 30 (the log's *Milestone 2, item 8: the listener's retry* and *The shell's reader asked*).

`Bytes.toHex` writes lower case with the rise, so the access log's `\x` escape takes `String.toAsciiUpper`, which design §8 keeps upper case, the cookie of `src/shell.ern` drops its `String.toLower`, and the frames of `src/web_socket.ern`'s doc examples take lower-case letters (the log's *A digest in lower case*).

Ernest's style guide gives no value with the rise to a case the value's shape rules out, so four sites that answer one fault instead, with a cause that says why the case cannot come, each shown by reading first not to come: `Smoke.masked`'s `<<>>` for a key of four bytes, `shownEntry`'s `"Flush"` of `src/connection.ern`, the `AcceptorEnded` alternative of `ended` in `src/listener.ern`, and `BySite` in the test's `sized` of `src/hosts.ern` (the log's *A case that cannot come*).

Two measurements come with it, on the same archive (the log's *Line 33 answered*). The first is of the server's stop. Line 33's answer has the job halt without the host's flush, so the bytes a socket still holds at the program's end are dropped. A probe stops the server while a slow client is mid-response, on the site's largest file, and tells what the client receives. Design §2's *The end* then gains the sentence that says it.

**Decision: the closes that wait.** With the rise `Tcp.close` answers only once the socket's bytes and, over TLS, the record that ends the connection are with the kernel, or the bytes are dropped, within E.18's bound. It answers at once where the handshake over TLS has not ended, and a process that must not wait kills the socket (the log's *A close that waits* and *The close as E.18 has it*). Each close of the program is decided, to wait or to kill: the listener's three of a socket untouched, which design §7 has never wait and E.18 has answer at once; a connection's after a response, after a write past its deadline and where its client went away; and a shell's.

The close after a write past its deadline fits neither. Line 35 of the language feedback asks Ernest for a close that drops what the host holds, which is Ernest's 270 and comes after the launch. So at the rise that close is decided between the two, and it is opened again with Ernest's answer (the log's *Line 35: a close that drops what the host holds*).

A probe on the archive times each close, over TCP and over TLS, against a client that takes nothing, one that never answers the closing record and one whose handshake over TLS 1.3 is paused after the server's hello, and counts the node's descriptors against a client past its cap, 37 at most on 0.10.0 (the log's *A refused socket leaves nothing*). It is brought to the user with those times, and design §2's sentence on who closes a socket, §6, §7 and §11 change first.

**Decision: the end and a response's last bytes.** Whether the end waits until a response's bytes are with the kernel, and for how long, is brought to the user with the probe's numbers. It follows the decision above, which gives it its mechanism: a connection that closes after a response has told `ResponseWritten`, so the end ends it in its close.

The second is of §13's 85 seconds, the loss of a silent peer, with output waiting for it and without. It follows the two decisions above, since a close that waits and an end that waits each add their wait to §13's sum. The unit's `TimeoutStopSec` and the smoke test's check take what §13's rule then gives (the log's *The stop time at 85 seconds*).

**ASCII case.** The program compares protocol text by Unicode's case and trims it of Unicode's white space, where RFC 9110 has ASCII case and spaces and tabs. With the rise, whose library has `String.toAsciiLower`, design §6's and §11's sentences say so first, and the six sites of `String.toLower` over protocol text take it. A request reaches two of them, the `lists` of `Connection` and of `Shell`, which line 34 names. Each becomes `Http.elements`, Ernest's answer to the line, and a comparison by `String.toAsciiLower`, and the program writes no trim of its own; a test holds each against the line's three headers (the log's *ASCII case and a head in pieces* and *Line 34 answered*).

**What the hostile inputs' tests leave out.** It follows *The floor's rise*, whose archive holds Ernest's answers to lines 31 and 32, and its decision on the closes, which says how a connection closes at a write past its deadline. Over TCP the close follows the last byte, so the tests of a write past its deadline, `Connection`'s and `Shell`'s, hold what the client reads after the responses told written, and the close. A write that fails loses what had arrived, so the test of a head that trickles holds the 408's bytes with a client that reads before it writes again (the log's *The hostile inputs' tests* and *Lines 31 and 32 answered*).

**Item 5, the release and the switch.** Once Ernest's release is tagged, the same week and after `ernest-template`'s release and `ernest-epx`'s, it is installed, and a release of this program is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag.

That release, with item 11's client, is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper (the log's *The wrapper and the smoke test's configuration*). The unit is installed again from the release, for its stop time, 130 seconds today and what *The floor's rise* leaves it (the log's *The stop time at 85 seconds* and *The rise's items read against the items left*). The rehearsal's unit goes with it, with `/home/httpd/rehearsal/` and the shell's image of 0.9.0. Until then, design §11's messages stay as Ernest's site speaks them, and a change to them is told to Ernest's session before it is built.

Ernest's side goes live in the same switch, the one day both repositories change: the site's script calling the client, its generator taking no configuration, the shell page's numbers from the client's limits and a stub client in its browser test. It is built, in Ernest's MVP 4.6, and its going live is Ernest's MVP 4.4's item 6, beside that release (the log's *Ernest's side built*).

The site, which Ernest's `make site TAG=` writes from the tag of the MVP 4.4 release into Ernest's `build/site/`, comes out as an archive does and is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). Before it is copied, its largest file is held against the 0.32 MiB the caps allow by §13's rule, and the caps are sized again where it is larger (the log's *The caps on 0.10.0*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

## Outside the milestones

What comes when its condition does, in no milestone.

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine* and *The archive's tree and the four cores*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
