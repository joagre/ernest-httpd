# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on, then what stands outside the milestones; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.11 and builds against `ern 0.11.0+93a13b13`, the archive Ernest's MVP 4.4 readers read, installed on 2026-11-23; its commits stay unpushed until Ernest's 0.11.0 is released. Milestone 2 is under way: item 12, the full review's third leg and items 13 to 15, then item 5 on Ernest's release. Lines 35 to 37 of the language feedback wait on Ernest, line 35 its 270, planned after the launch; the four cores wait on what the access log shows. Meanwhile the rehearsal's unit serves the shell client at https://ernest-lang.org:8443/, from a build of `75faac8`, with Ernest's side built and walked against it, which waits only on the launch's switch.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

Done: items 1 to 4, 6 and 7, the log's *Milestone 2, item 1: the refusal's form*, *Milestone 2, item 2: quiet tests*, *Milestone 2, items 3 and 4: the attach's word and a restart at the cap*, *Three cleanups* and *The code reader's findings*; item 8, the log's *Milestone 2, item 8: the listener's retry*; item 9, the log's *Milestone 2, item 9: the reset under load*; item 10, the log's *Milestone 2, item 10: the library's own*; item 11, the log's *The shell client*, *The shell client's design* and *Milestone 2, item 11: the shell client's build*; and item 5's rehearsal, the log's *Milestone 2, item 5: the rehearsal*.

Done too, the steps between them: the designed lines out of the test run, the log's *The lines in the test run*; the refused value on one line, the log's *A refused value on one line*; the server's signal in the tests, the log's *The server's signal in the tests*; the two nodes in the visitor's container with a CPU cap, the log's *Two nodes and a core*; the caps on 0.10.0, which stand, the log's *The caps on 0.10.0*; the listener's one closer, the log's *The listener's one closer*; the shell client's proposal read and swept, the log's *The shell client's proposal goes*; and the archive's tree, the log's *The archive's tree and the four cores*.

Done after them, from a reading of the design from outside: the shell's reader asked, with what else the reading found, the log's *The shell's reader asked*; the session's helpers, the log's *The session's helpers*; and the rehearsal's build, the log's *The rehearsal's build*.

Done from the reviews from outside: the hostile inputs' tests, the log's *Three points from outside* and *The hostile inputs' tests*; and the stop time, 130 seconds against a silent peer's 85, the log's *The stop time at 85 seconds*.

Done on the archive of Ernest's MVP 4.4 reviews: the floor's rise, the log's *The floor at 0.11*, *Lines 28 to 32 answered* and *The closes decided*; the end, which waits for no response's last bytes, the log's *The end does not wait*; §13's 85 seconds, which stand, the log's *The silent peer on 0.11*; and the ASCII case, the log's *Protocol text in ASCII case*.

### On Ernest's MVP 4.4 release

**The full review.** The repository is reviewed whole as `docs/full_review.md` says, Ernest's MVP 4.4's item 4, in three legs, each ended by a commit and a stop for the user: the readers and their lists in `docs/findings.md`; the sort, each verdict and each fix's shape decided with the user; and the fixes and the close. The readers' lists stand in `docs/findings.md`, read at `f6bf173`, and the sort has given each line its verdict (the log's *The readers at f6bf173* and *The sort at f6bf173*). The shell's findings are items 12 to 15, before item 5, and the rest are fixed in the third leg, once item 12 is built. The four findings against the template's files wait there, with lines 38 to 57 of the language feedback, until the user lifts the hold on messages to other repositories.

**Item 12, the caps by address**, first, since the site meets S2 today. An IPv6 address counts by its first 64 bits in every count by address, through a parser of the program's that a line of the language feedback names. At `limits.connections` a listener ends the connection that has waited longest outside a request and takes the one that comes. `shell.per-address`, 2 in `deploy/config.json`, bounds the live sessions an address started (findings S1, S2, L3 and L4).

**Item 13, the shell and its session.** A shell keeps one resize outstanding, the latest size held, and sends it at the session's `Resized`. The messages a shell sends its session carry the shell, and a session drops those of a shell not attached. An attach waits at most the idle deadline, and the connection closes with 1011 after it. A restart waits for the ending session under its cookie to end and starts in its place (findings L1, L6, L11, L12 and C9).

**Item 14, the cookie**, `__Host-shell` with `Path=/`, the client's test in Chromium showing it kept on `localhost` (findings S4 and L8).

**Item 15, the container.** The wrapper ends `podman run`, waits for it, and removes the container and its id in a session of its own. The unit removes every container `httpd` has left once the server has stopped, `ExecStopPost`. The command takes `--log-driver=none`, `--memory-swap 128m` and `--userns=nomap`, and its containers one slice of one core, `--cgroup-parent`. Step 7 checks the log driver and step 11 the caps from inside a session, and the switch's rehearsal shows each on the machine, where podman stands (findings L2, L5, L7, L9, S6, S7 and S8).

**Item 5, the release and the switch.** Once items 12 to 15 are built and Ernest's release is tagged, the same week and after `ernest-template`'s release and `ernest-epx`'s, it is installed, and a release of this program is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag.

That release, with item 11's client, is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper (the log's *The wrapper and the smoke test's configuration*). The unit is installed again from the release, for its stop time, 130 seconds today and what *The floor's rise* leaves it (the log's *The stop time at 85 seconds* and *The rise's items read against the items left*). The rehearsal's unit goes with it, with `/home/httpd/rehearsal/` and the shell's image of 0.9.0. Until then, design §11's messages stay as Ernest's site speaks them, and a change to them is told to Ernest's session before it is built.

Ernest's side goes live in the same switch, the one day both repositories change: the site's script calling the client, its generator taking no configuration, the shell page's numbers from the client's limits and a stub client in its browser test. It is built, in Ernest's MVP 4.6, and its going live is Ernest's MVP 4.4's item 6, beside that release (the log's *Ernest's side built*).

The site, which Ernest's `make site TAG=` writes from the tag of the MVP 4.4 release into Ernest's `build/site/`, comes out as an archive does and is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). Before it is copied, its largest file is held against the 0.32 MiB the caps allow by §13's rule, and the caps are sized again where it is larger (the log's *The caps on 0.10.0*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

## Outside the milestones

What comes when its condition does, in no milestone.

**Line 35.** The close at a write past its deadline, which waits so that the caps count what the host holds, is opened again with Ernest's answer to line 35, its 270, planned after the launch (the log's *The closes decided*).

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine* and *The archive's tree and the four cores*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
