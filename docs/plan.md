# Plan

The roadmap: what remains to be built, in what order, and the milestones done. Why anything is the way it is belongs to [`log/`](log/README.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the milestone under way, its steps by what each waits on, then what stands outside the milestones; the table of the milestones done comes last. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Release 0.1.0 serves the one page of https://ernest-lang.org on its machine. The repository stands on floor 0.11 and builds against Ernest's release `ern 0.11.0`, installed on 2026-11-26. Milestone 2 is under way: item 18, on this repository's turn with Ernest, then item 5, on Ernest's 0.12.0. Lines 35, 36, 37, 45, 50, 57 and 61 of the language feedback wait on Ernest, each with its answer beneath it, and line 59 on item 18; the four cores wait on what the access log shows. Meanwhile the rehearsal's unit serves the shell client at https://ernest-lang.org:8443/, from a build of `75faac8` with item 15's container, with Ernest's side built and walked against it, which waits only on the launch's switch.

## Milestone 2: after the first release

What the first release's readers found and the milestone's own items, each a step with its log entry when built.

Done: items 1 to 4, 6 to 17 and 19, item 5's rehearsal, the full review at `f6bf173` in its three legs, and the steps between them; the log has each.

### On Ernest's answers

Each is an answer of `ern 0.11.0+ab68ef61` that lets the program give up code that filled a gap (the log's *Ernest's answers to lines 35 to 60*).

**Item 18, the path.** `Static` places a target's path under the root by `Http.filePath`, design §5's own rules run over its segments. It waits on a decision of this repository's turn with Ernest, open since 2026-11-28: a segment `.`, which `filePath` refuses and §5 drops, is answered 400 by §5 or is an ask of Ernest's (line 59).

### On Ernest's 0.12.0, its MVP 4.18

**Item 5, the release and the switch.** Ernest's 0.11.0, the floor, is tagged; `ernest-template` and `ernest-epx` release, and then Ernest's MVP 4.18, whose 0.12.0 is the launch and takes what the full review found of Ernest's security. It is a new minor, so the floor rises to 0.12 on the candidate Ernest's session names, `0.12.0+` its commit, and from the rise `main` builds on that archive alone and is pushed only once 0.12.0 is tagged (the log's *The launch on 0.12.0*).

Once 0.12.0 is tagged it is installed, and a release of this program, that milestone's item 3, is made by `docs/release.md`, its readers among it, which `make release` refuses before the tag. Its note names the `ern` it was built with whole, `ern 0.12.0` (finding D33), and the rules that refuse a `shell` written for 0.1.0, `shell.per-address` required and `shell.warning` at most half the lifetime, and the switch makes true the README's sentences on the deployed shell, which its check reads (D3).

That release, with item 11's client, is installed in one switch on the path the rehearsal walked: `deploy/config.json` takes the member `shell` that design §13 gives, and `deploy/README.md`'s step 7 builds the image and installs the wrapper and the slice (the log's *The wrapper and the smoke test's configuration*). The unit is installed again from the release, for its stop time of 130 seconds and its `ExecStopPost` (the log's *The stop time at 85 seconds* and *The silent peer on 0.11*). The rehearsal's unit goes with it, with `/home/httpd/rehearsal/` and the shell's image of 0.9.0. Until then, design §11's messages stay as Ernest's site speaks them, and a change to them is told to Ernest's session before it is built.

The server's node and the operator's directory lose the node's own `public-key` from their `ernest.conf`, which a node of 0.11 or later refuses as an unknown field, and the rehearsal's loses it before Ernest's MVP 4.18 starts a node of 0.12's form there, on the candidate's archive, since two nodes connect only on one floor (report §8.7).

Ernest's side goes live in the same switch, the one day both repositories change: the site's script calling the client, its generator taking no configuration, the shell page's numbers from the client's limits and a stub client in its browser test. It is built, in Ernest's MVP 4.6, and its going live is Ernest's MVP 4.18's item 4, on a day the user sets when it opens (the log's *Ernest's side built*).

The site, which Ernest's `make site TAG=` writes from 0.12.0's tag into Ernest's `build/site/`, comes out as an archive does and is copied last, as step 5 copies `site/` today, so that every project it lists builds on the release it names (the log's *The release before the site*, *The site on Ernest's next minor* and *The floor at the reviews*). Before it is copied, its largest file is held against the size §13's rule allows the caps, and the caps are sized again where it is larger (the log's *The caps on 0.10.0*). The `ernest-lang.org` repository, which holds the one page until then, goes (the log's *From the site's design*).

## Outside the milestones

What comes when its condition does, in no milestone.

**Line 35.** The close at a write past its deadline, which waits so that the caps count what the host holds, is opened again with Ernest's answer to line 35, its 270, planned after the launch (the log's *The closes decided*).

**Four cores.** The machine moves to four cores and 4 GB, `shell.most-at-once` about 25, the first time the access log shows visitors turned away (the log's *The machine* and *The archive's tree and the four cores*).

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| 1 | the server serving the site: the configuration and the static site, the listener, the connection and the access log, TLS, the redirect listener and the hosts, the WebSocket, the shell and the sessions, the example site, the deployment on its machine, and release 0.1.0 | 2026-11-02 | the log's *Item 1: the configuration and the static site*, *Item 2: the listener, the connection and the access log*, *Item 3: TLS, the redirect listener and the hosts*, *Item 4: the WebSocket, the shell and the sessions*, *The example site*, *Item 5: the example site*, *Item 6: the deployment*, *The machine*, *The wrapper and the smoke test's configuration* and *The cold reader*, with the seven sweeps between them |
