# Findings

The full review's findings, read at `f6bf173` on 2026-11-23 as `docs/full_review.md` has them, by the readers K, C, D, S and L, and the three the plan held for this file, P1 to P3. Each line stands until a commit does it, drops it or plans it, which the commit messages say, and the file goes when every line is decided.

What the readers found of Ernest's is lines 38 to 57 of `language_feedback.md`, and the lines here that name the template's file stay here until the user says where they go. A line that repeats another names it. The sort, on 2026-11-23, gave each line its verdict: fixed in the review's third leg, planned as an item of milestone 2, dropped with its reason, or held for the template. The readers' lists stand whole below the lines, each finding by its reader's letter, renumbered on where a reader lettered a part of its own.

## The lines

### The plan's

- **P1.** §12's deadline sets its alarm again for a warning time already passed where the warning is more than half the lifetime, which Ernest's panel run met. Fix in the third leg.
- **P2.** A write cut short at its deadline reaches its client whole on 0.11, though §6 tells it to neither the log nor the listener. Fix in the third leg: §6 says it holds no line, though its bytes may reach the client.
- **P3.** `shell.path` and `shell.client`, which §4 has begin with `/` alone, are compared with a path `Http.target` encodes. Fix in the third leg: §4's rule, `begin with / and hold only letters, digits and - . _ ~ ! $ & ' ( ) * + , ; = : @ /`.

### S, the security reader

- **S1.** Real exposure: one address starts every session `most-at-once` allows and keeps each by a reattach and an extend, and nothing caps one address's live sessions (§12, `src/sessions.ern` line 117). Planned: item 12, `shell.per-address`, 2 deployed.
- **S2.** Real exposure: the per-address caps count a whole address, so five IPv4 addresses or one IPv6 /64 fill a listener, the cap evicts no idle connection, and fresh addresses lift the starts window (§7, §12). Planned: item 12, an IPv6 address by its /64, and the connection longest outside a request ended at the cap.
- **S3.** Real exposure: the example's shell gives any local client that writes `Origin: http://localhost:8080` the developer's account and the server's whole environment, `SSH_AUTH_SOCK` among it, and so do the tests' servers (§11). Fix in the third leg: `examples/README.md`'s sentence and the README's line on `make test`.
- **S4.** Hardening: a cookie the client chooses names a new session and is never replaced, so a planted cookie is taken over later from any address (§11, *The cookie*). Planned: item 14, the cookie `__Host-shell` with `Path=/`.
- **S5.** Hardening: a path the file system refuses reaches standard error unescaped, control and bidirectional characters among it (§5, *The errors*). Fix in the third leg.
- **S6.** Hardening, not run: the hangup's kill of the wrapper can leave its container running outside every cap where `podman rm` outlasts `shell.hangup` (§12, `deploy/shell.sh`). Planned: item 15.
- **S7.** Hardening, not run: the one core is a container's, so two sessions take both of the machine's (§13). Planned: item 15, a slice of one core.
- **S8.** Hardening, not run: the container's root is `httpd` on the host, which owns the keys (§13). Planned: item 15, `--userns=nomap`.
- **S9.** `src/hosts.ern`'s module comment says "in any case" where §9 and the code say ASCII case. Fix in the third leg.

### C, the code reader

- **C1.** The configuration's `headers` may name `Cache-Control` and `Sec-WebSocket-Version`, which the server writes itself, so a response carries two of each, and a test expects it (§4; D2). Fix in the third leg.
- **C2.** The template's: `tools/docs.ern` checks no backticked path after the design's line 94, whose double-backtick span holds a backtick. Held for the template.
- **C3.** A control character in a configuration member's name reaches standard error raw, in `is no field of` and in a field's name (§4). Fix in the third leg.
- **C4.** A member named twice is taken silently, the last winning (§4 is silent; K8). Fix in the third leg: §4's rule as it stands, the last kept; the refusal waits on line 38.
- **C5.** A Close echoed as 1000 whatever its code passes every test (§11). Fix in the third leg.
- **C6.** The browser test cannot tell the warning's seconds from a constant (§14). Fix in the third leg.
- **C7.** No test reaches the smoke test's dimmed answer (§13). Fix in the third leg.
- **C8.** A warning that is no whole number of seconds tells the page the wrong milliseconds, 1500 as 1000 and 500 as 0 (§4, §14). Fix in the third leg: `shell.warning` must `be a multiple of 1000`.
- **C9.** A shell attaching has no deadline and watches nothing, so an end of the sessions process leaves it waiting in its place (§11, §12). Planned: item 13, the attach bounded by the idle deadline.
- **C10.** The connection writes by `Tcp.write` over `Http.renderResponse`, against E.0's shape rule 11, as §6 says. Fix in the third leg: §6 names `Http.writeResponse`, and the code calls it.
- **C11.** §6's "a 101 carries its own `Connection: Upgrade` and none of these" reads two ways (D22). Fix in the third leg.
- **C12.** `deploy/shell-start.sh` reads foo's output with `2>&1` where §13 says its standard error. Fix in the third leg: §13 says both streams.
- **C13.** Eight cases that cannot come answer a value where the style guide has them fault. Fix in the third leg: each faults.
- **C14.** Three tests that launch the server take port 0 where the count of ports is wrong, and two others answer `Left`. Fix in the third leg.
- **C15.** Forms written more than once: `header` four times, `headed`, `isControl`, the test's certificate, and `next` three times and twice. Dropped: `header`, the certificate and `next` wait on lines 49 and 50, and sharing the rest would export a private helper.
- **C16.** `src/hosts.ern` builds the site and reads every configured host on each request, where once would do. Fix in the third leg.
- **C17.** Prefixes cut by hand where `String.stripPrefix` would do. Fix in the third leg.
- **C18.** `src/shell.ern` line 130 takes `""` for no `Origin` or two. Fix in the third leg.
- **C19.** Names: `Waiting` for a cap reached, locals `object` that hide `Config.object`, and a wait's beginning named `start` and `key` where the guide has `since`. Fix in the third leg, each word searched first.
- **C20.** `responded` compares `version.minor == 0` where the module compares whole versions. Fix in the third leg.

### K, the cold reader

- **K1.** The README's `make release` names no need of a release's `ern`, and the refusal comes after the tests. Fix in the third leg: the README's line names a release's `ern`, and the Makefile checks it first.
- **K2.** The smoke test cannot pass against a canonical host with a port: its 301 checks expect `https://` and the host, and it dials the port twice. Fix in the third leg.
- **K3.** `shell.origins` takes what is no origin, a path, `*`, a bare host or an empty list, and every upgrade is then a 403 with no word (§4). Fix in the third leg: each `be an origin`, and the list `not be empty`.
- **K4.** A 431 has no phrase, `HTTP/1.1 431 ` and a body of `431 ` (K20). Fix in the third leg: the phrase in the program, line 41 naming it.
- **K5.** The installed launcher does not run through a symbolic link, taking its root from the link's place. Fix in the third leg.
- **K6.** The launcher's command line: `--config-dir` alone is the shell's `can't shift`, `--help` is read as a path, the usage line lacks `--config-dir`, and an `ern` not found is `exec: ern: not found`. Fix in the third leg.
- **K7.** `make run` without npm's reach fails in curl's, gzip's and tar's words, and the README's first step names no fetch. Fix in the third leg.
- **K8.** An `access-log` that names a directory passes the start, and every response then loses its line; the member named twice is C4. Fix in the third leg: `access-log` must `name no directory`.
- **K9.** A directory's 301 drops the query, where the host's 301 keeps it (§5). Fix in the third leg: §5's `Location` keeps the query.
- **K10.** `deploy/README.md` step 10 quotes `unknown user 'httpd'` where logrotate 3.22 says `unknown group 'httpd'`. Fix in the third leg.
- **K11.** D5. With D5.
- **K12.** D4. With D4.
- **K13.** The tree is 0.1.0 by `VERSION` and 0.11 by `package.conf`, and `CHANGES.md`'s 0.1.0 names `ern 0.9` (D1, D33). With D1 and D33.
- **K14.** The configuration's members stand in no page a user of the program reads but the design. Fix in the third leg: the README names §4 as the configuration's reference.
- **K15.** D24. With D24.
- **K16.** A configuration that is not JSON is said as `Json.UnexpectedByte(byte = 111, ...)`. Fix in the third leg: the error said in words.
- **K17.** The shell page's `unavailable` says neither which cap nor when to come back. Dropped: the deployed page is Ernest's site, and the example's is a look at one's own machine.
- **K18.** The installed example cannot show its shell: no `xterm/`, and its access log's directory is a checkout's. Fix in the third leg.
- **K19.** The example site has no icon, so a first visit's `/favicon.ico` is a 404 in the log and the console. Fix in the third leg.

### D, the documents reader

- **D1.** `deploy/README.md` names the archive `ernest_httpd-0.1.0` in ten lines, whose `deploy/` lacks `shell-start.sh` and holds the older unit and wrapper. Fix in the third leg: `ernest_httpd-VERSION`.
- **D2.** C1. With C1.
- **D3.** `README.md` says the deployed site has the shell, *Try it*, which the plan and §13 bring at item 5's switch. Planned: item 5, whose switch makes the two sentences true and whose check reads them.
- **D4.** `deploy/README.md` step 12 names a session's reader and not its writer (K12). Fix in the third leg.
- **D5.** `deploy/README.md` step 4 has a release's `ern --version` print a `+` and a commit (K11). Fix in the third leg.
- **D6.** The glossary's `listener` is "the process that accepts", which §2 and §7 give the acceptor, and says "Not `acceptor`". Fix in the third leg.
- **D7.** §6's "the two paragraphs above" no longer names the paragraphs it means. Fix in the third leg.
- **D8.** §2's "every socket the program ends it so closes" is not true at the stop, where §7 kills a connection that waits. Fix in the third leg.
- **D9.** The design's line 3 cites `CLAUDE.md`'s *Before code*, which is *Who decides*. Fix in the third leg.
- **D10.** The template's: `full_review.md` has a reader write its list to a file, and `agents.md` says an agent cannot. Held for the template.
- **D11.** `docs/plan.md` line 31 points at what *The floor's rise* leaves the stop time, which is done. Fix in the third leg.
- **D12.** `language_feedback.md` line 36 says the plain-text client's test fails on it, and it passes, its client closing first. Fix in the third leg.
- **D13.** The template's: `tools/docs.ern` cites `CLAUDE.md`'s *Writing* for the 150 words and the history, which *Writing* does not hold. Held for the template.
- **D14.** `docs/README.md` leaves out `SECURITY.md` and `assets/README.md`. Fix in the third leg.
- **D15.** The shell's member stands in the design, twice in `deploy/README.md`, and in a test. Dropped: the JSON is what the operator pastes.
- **D16.** The make targets stand in the README and in the Makefile's head, and differ. Fix in the third leg.
- **D17.** What each document is stands in `CLAUDE.md` and in `docs/README.md`, in different words. Dropped: the one says who owns a fact, the other is a reader's index.
- **D18.** `CHANGES.md` restates `release.md`'s rule for a release's note, less one part. Fix in the third leg.
- **D19.** What `make uninstall` removes stands four times. Fix in the third leg.
- **D20.** `language_feedback.md`'s header restates `CLAUDE.md`'s *The work*, and lines 35 to 37 name no program's file. Fix in the third leg, the header citing *The work*; its second half dropped, each line's probe being described to be run again.
- **D21.** `docs/plan.md` holds five paragraphs of what is done. Fix in the third leg.
- **D22.** C11. With C11.
- **D23.** The glossary's `server` has one meaning, and the design uses it with two. Fix in the third leg.
- **D24.** `README.md` describes `ERL_DEPS`, `erl/`, `test/` and `THIRD_PARTY_LICENSES`, which this program has none of (K15). Fix in the third leg.
- **D25.** §13 quotes the rule `must not be empty`, which §4 writes `not be empty`. Fix in the third leg.
- **D26.** `deploy/README.md`'s "under 256 MiB" is 256 exactly, and no document owns the 0.32 MiB. Fix in the third leg.
- **D27.** The OTP release stands in `deploy/README.md` and in the Containerfile, held together by no test, and the README restates the floor. Fix in the third leg.
- **D28.** `deploy/README.md` step 7 does not say which file takes the member `shell`. Fix in the third leg.
- **D29.** §12 says twice that a start drops the starts older than the window. Fix in the third leg.
- **D30.** §13 and the Makefile count `assets/` among the documents' pictures, which no document shows. Fix in the third leg.
- **D31.** The rehearsal's unit, directory and port stand only in the plan. Dropped: the facts go at the switch.
- **D32.** The template's: `agents.md` and `full_review.md` count differently what a reader keeps of `CLAUDE.md`. Held for the template.
- **D33.** `CHANGES.md`'s 0.1.0 names `ern 0.9`, a minor and no archive's version (K13). Planned: item 5, whose release's note names `ern 0.11.0` whole.

### L, the live shell reader

- **L1.** Real exposure: one visitor's resizes grow the server's memory without bound, about 60 MiB a second, since nothing paces a shell against its session and each `Os.resize` waits behind the backlog; the session then outlives its lifetime and the server its stop (§11, §12; line 54). Planned: item 13, one resize outstanding, the latest held.
- **L2.** Real exposure: a visitor's container outlives its session wherever the wrapper's trap does not finish, at the session's kill after `hangup`, the runtime's death or systemd's, since conmon stands outside the group (§13, `deploy/shell.sh`; S6). Planned: item 15, the removal in a session of its own and `ExecStopPost`.
- **L3.** S1. With S1.
- **L4.** Real exposure: the caps by address bound nothing for a visitor with an IPv6 prefix (S2). With S2.
- **L5.** Real exposure, not run: the container's command names no log driver, so conmon logs every byte a visitor's program writes, outside every cap (§13). Planned: item 15, `--log-driver=none`.
- **L6.** Hardening: a restart passes `most-at-once`, the ending session's program counted by nothing, twelve programs shown against a cap of six (§12). Planned: item 13, a restart waiting for its ending session.
- **L7.** Hardening: no check shows that the container's caps hold, and its swap is not capped (`deploy/README.md` steps 7 and 11). Planned: item 15, step 11's check and `--memory-swap 128m`.
- **L8.** S4, by a cookie a sibling host sets. With S4.
- **L9.** S8. With S8.
- **L10.** Hardening: the image is pinned by its tag and not its digest (`deploy/Containerfile`). Dropped: the full tag takes the base system's security fixes, which a digest would freeze.
- **L11.** C9, and an attach to a session that died before the sessions took its `Down`. Planned: item 13, with C9.
- **L12.** A displaced shell's last read, a stop among it, still reaches the session the new shell holds (§12). Planned: item 13, the messages carrying the shell.

### Ernest's

What the readers found of Ernest's is lines of `language_feedback.md`:
- line 38: C4, C21 and K8;
- line 39: S10, after S3;
- line 40: S11 and L14, after S6 and L2;
- line 41: K20, after K4;
- line 42: K21 and D34;
- lines 43 to 45: K22, K23 and K24;
- lines 46 to 48: C22, C23 and C24, after C13;
- line 49: C25 and S13, after C15;
- line 50: C26, after C15;
- line 51: C27 and L18;
- line 52: S14;
- line 53: S16;
- lines 54 to 57: L13, L15, L16 and L17, line 54 after L1.

S12, that no function reads an IP address's text into its bytes, becomes line 58 with item 12, whose parser it names. S15, that `Crypto` has no HMAC, is no line, since the cookie's fix needs none.

## The readers' lists

Each list as its reader handed it, a part it lettered of its own renumbered on in its letter: K's E1 to E5 are K20 to K24, S's H1 to H5 are S4 to S8, its D1 is S9 and its E1 to E7 are S10 to S16, and D's E1 is D34.

## S, the security reader


Every input went to a server of my own on 127.0.0.1, ports 18401 to 18403 (plain, redirect, TLS) and 18411 (a second server whose shell ran `ern shell`). The clone was built with `ERN=/home/jocke/opt/local/bin/ern make`. Configurations, tools and output are under `S-scratch/`. Both servers were ended by their process numbers, and no session program was left.

What holds, tried and seen:
- **Paths.** `..`, `%2e%2e`, `%2F`, NUL, a control byte and non-UTF-8 each answer 400. A dot segment answers 404.
- **Redirects.** A directory's 301 writes its leading `/`s as one. The redirect 301 always names the canonical host. No input turned either into an open redirect: `//evil.com`, `/\evil.com`, `/.//x`, absolute form and userinfo all tried.
- **Host checks.** Two `Host` headers, a `Host` naming userinfo, a 1.1 request with no `Host`, 505, 413 for any body, folds and bare LF all answer as §6 says.
- **ACME challenge.** It is confined to its directory.
- **Access log.** Every byte outside U+0020 to U+007E is escaped.
- **WebSocket decoder.** Each of these is refused with its code: unmasked frames, RSV bits, fragmented or oversized control frames, non-shortest lengths, 2^63, a length past the limit before its payload, bad close codes, bad UTF-8, a continuation out of place, a text frame inside a text message, non-object JSON, two members, a resize out of range, a float or a bignum.
- **Deep JSON.** 32,000 nested arrays close with 1008 in about 10 ms.
- **TLS.** Plain HTTP on the TLS port closes without a response. The host takes one client renegotiation on TLS 1.2 and then refuses the next.

### Real exposures

#### S1. One remote address holds every session, indefinitely

**Place.** `src/sessions.ern:117-118`; design §12 *An attach* (line 310); `src/session.ern:270-271`.

**Quote.**
- `if Map.size(held.live) + Map.size(others) < held.shell.mostAtOnce && List.size(made) < held.shell.starts.count then`
- `Extend -> serving(started, Serving(..state, last = Clock.monotonic()))`

**What is wrong.**
- `most-at-once` is global, and nothing caps the live sessions of one address. `starts.count` counts starts only.
- Reattaching to a live session counts no start, and an `Extend` or a key moves its deadline without bound.
- On the deployed numbers (§13 *The shell's member*), `most-at-once` is 6 and `starts` is 10 within an hour. One address starts all six sessions and keeps them by one reattach and one extend each per five minutes. Every other visitor then gets 4003.
- This sharpens the log's 2026-10-27 decision, "no total cap, since a session kept alive holds one of the shells the cap allows and no more". That holds per session, but not per visitor.
- The holder can also run a busy loop in each container, `--cpus 1` six times on the two-core machine (see S7).

**Input.** `S-scratch/` config, `most-at-once` 3. From 127.0.0.1: three handshakes, `{"resize":[24,80]}` on each, then disconnect. A visitor from 127.0.0.2 then got `close 4003`. A reattach with each cookie got `{"attached": "joined"}`, then `{"extend": true}` (output kept in this transcript; client in `S-scratch/tools/ws.py`).

**Fix.** Cap live sessions per remote address, for example one or two, beside the global cap.

#### S2. The per-address caps key on the whole address: five IPv4 addresses, or one IPv6 /64, fill a listener and lift the starts window

**Place.**
- `src/listener.ern:140`: `if Map.size(connections) < listening.server.config.limits.connections`
- `src/listener.ern:155`: `if count(connections, endpoint.host) < cap then`
- `src/sessions.ern:112`: `Map.get(held.starts, remote)`
- Design §7 *Accepting*, §12 *An attach*.

**What is wrong.**
- The deployed caps are 80 by listener and 16 by address (`deploy/config.json`). ceil(80/16) = 5 addresses take a whole listener. Each connection is held by one `HEAD` per 15 s, the idle deadline.
- At the cap the listener accepts nothing ("at the cap it asks for none until one ends"). Everyone else waits in the backlog, and no idle connection is evicted.
- `starts.count` is per full address. An IPv6 /64 (2^64 addresses) or a few IPv4 addresses start sessions without limit. Each start is a `podman run` on the deployed machine.
- The `::` listeners have no AAAA record yet (log, 2026-11-02). Any client can still reach the machine's IPv6 address directly with `Host: ernest-lang.org`, and the sessions are shared across listeners.

**Input.**
- `python3 -I S-scratch/tools/hold.py 18401 5 16`: 16 connections each from 127.0.0.10 to 127.0.0.14. It printed `held connections answering: 80 of 80`, then `victim: no answer within 8 s` from 127.0.0.99, and `HTTP/1.1 200` the moment they closed.
- Starts: 10 start/stop cycles from 127.0.0.30 gave `text` ten times, and the 11th `close`. Then 11 fresh addresses each got `text`.

**Fix.** Count IPv6 remotes by /64 for both caps. At the connection cap, end the longest-idle `AwaitingRequest` connection to admit a new one instead of accepting none.

#### S3. The example's shell gives any local user or process the developer's account, with the server's environment

**Place.**
- `examples/site/config.json:25`: `"command": ["ern", "shell"]`, on 127.0.0.1:8080, which `make run` serves.
- `src/shell.ern:130`: `else if !List.contains(shell.origins, Optional.withDefault(origin(headers), "")) then`
- `src/session.ern:143`: `Os.startTerminal(Os.command(name, arguments), size)`
- Design §11 *The handshake*.

**What is wrong.**
- `Origin` is the only guard. It stops a browser on another site (and DNS rebinding meets the 421), but any non-browser client on the machine writes `Origin: http://localhost:8080`; `examples/README.md`'s own curl line does.
- E.23 has the program inherit the server's whole environment.
- `examples/README.md` says "for a look at one's own machine over localhost". On a shared machine, or for any local unprivileged process, that is a shell as the user who ran `make run`.
- The same holds for `make test` while it runs: `Client`'s test serves `sh`, and the end-to-end test serves the example site.

**Input.** A second server on 18411 with `"command": ["ern", "shell"]`. A Python client with `Origin: http://localhost:18411` typed `Os.run(Os.command("id", ["-un"]), 5000)` and got `stdout = <<106, 111, 99, 107, 101, 10>>`, which is "jocke". A test of variable names alone showed `["SSH_AUTH_SOCK", "HOME", "XDG_RUNTIME_DIR"]` reach the session, so the developer's ssh agent is usable from it.

**Fix.** Run the example's command in the deployment's container, or make the default command run nothing as the user. Make `ern shell` opt-in, and have `examples/README.md` say that every local user reaches it.

### Hardening

#### S4. A cookie the client chooses names a session, and is never replaced

**Place.** `src/shell.ern:136-138` (`Some(cookie) -> #(cookie, [])`); design §11 *The cookie*.

**What is wrong.**
- Any 32 lower-case hex digits start a session under that name, with no `Set-Cookie`. Whoever presents them later, from any address, takes the session over with 4002 and is written the held piece of output.
- This is session fixation. It needs a way to plant the cookie, for example a man in the middle on `http://` port 80, since HSTS has no preload. The impact is a visitor's sandboxed REPL.

**Input.** The victim connected with `Cookie: shell=0123456789abcdef0123456789abcdef`: `Set-Cookie` absent, attached `new`. The attacker connected from 127.0.0.5 with the same cookie and got `{"attached": "joined"}`; the victim got `close 4002`.

**Fix.** When the carried cookie names no live session, draw and set a fresh one. Name it `__Secure-shell` so that plain HTTP cannot plant it.

#### S5. Client-chosen text reaches standard error unescaped

**Place.** `src/static.ern:212`: `Io.printlnError(Path.toString(path) <> ": " <> Io.show(cause));`. Design §5 *The errors*.

**What is wrong.**
- The decoded segments refuse C0 and DEL only. C1 controls (U+009B CSI), bidi overrides (U+202E) and U+2028 reach the journal, one line per request.
- This happens wherever the file system refuses a path under the root, such as a directory the server cannot search.

**Input.** With `root/locked` at mode 000, `GET /locked/%C2%9B31m%S11%80%AEtxt.exe%S11%80%A8forged:%20line` answered 500, and `server.err` holds `.../locked/M-BM-^[31mM-bM-^@M-.txt.exeM-bM-^@M-(forged: line: Io.Denied`.

**Fix.** Escape the path as `AccessLog.escaped` escapes a request before writing it.

#### S6. The hangup's kill can leave a container outside every cap (not run: no podman here)

**Place.** `src/session.ern:519` (`if exited then Unit else kill(Process.fromAddress(started.program))`); `deploy/shell.sh` (`trap 'end; exit 129' HUP`, `end` running `podman rm -f -t 0`); design §12 *The end*, §13 *The shell's wrapper*.

**What is wrong.**
- Where `podman rm` outlasts `shell.hangup` (5000 ms), the session kills the wrapper. E.23 says the processes still in its process group are killed with it, `podman rm` among them.
- conmon is not in that group, so the container runs on, counted by nothing. Six sessions ending together at `Sessions.Stop`, or two cores busy, make that likelier.

**Fix.** Bound the container itself, with `podman run --timeout` or a reaper of `ernest-shell` containers no session holds. Alternatively run `end`'s `podman rm` under `setsid`.

#### S7. Two sessions take both cores (not run: no podman here)

**Place.** Design §13 *The shell's command* (line 364): "one of the machine's cores, so that a loop that never waits takes no more than one core from the server and the other visitors". Log, 2026-11-02: "two cores".

**What is wrong.** The bound is per container. Two busy loops take the whole two-core machine, and S1 gives one address six.

**Fix.** Put every container under one parent cgroup whose quota is below the machine's cores (`--cgroup-parent` with a slice of `CPUQuota=100%`), or lower `--cpus`.

#### S8. Container root maps to `httpd` (not run: no podman here)

**Place.** Design §13 *The shell's command*: no `--userns`.

**What is wrong.** Rootless podman maps container uid 0 to the invoking user, `httpd`, which owns `node/privkey.pem` and the node's keys. The `shell` user maps to a subordinate uid, so this matters only after an escalation inside the container.

**Fix.** Add `--userns=auto`, or a `--uidmap` that puts container root in the subordinate range.

### Defects that are no exposure

#### S9. A module doc still says "in any case" after f6bf173 moved to ASCII case

**Place.** `src/hosts.ern:14-15`: "compared with the hosts of the configuration's, read as its own is, `Config.host`, in any case".

**What is wrong.** Design §9 and the code (`String.toAsciiLower`) say ASCII case. The line also runs past the module's width.

**Fix.** Write "in ASCII case" and rewrap.

### Ernest's

#### S10. `Os.Command` cannot clear or unset the inherited environment (a function the library lacks)

E.23 says "It inherits the program's whole environment, with each variable of `environment` set over it … no variable is unset". The session's program therefore gets everything the server has, `SSH_AUTH_SOCK` among it (S3). The only route is a workaround, `env -i` as the command's first word.

#### S11. E.23 is silent on the signal `kill` sends a running program

It is also silent on what the program's process group receives ("The processes the program started that are still in its process group are killed with it"). Whether the wrapper's cleanup can run at all (S6) depends on it.

#### S12. No function reads an IP address's text into its bytes or prefix (a function the library lacks)

E.18's `Endpoint.host` and G.12's `Authority.host` are `String`. Capping by IPv6 /64, S2's fix, means writing an address parser in the program.

#### S13. A named constructor is no function value, so one wrapper repeats at four sites

Language §5: "A named constructor is neither; it appears only in construction syntax". So four modules each define `fn header(name : String, value : String) : Http.Header = Http.Header(=name, =value)`:
- `src/connection.ern:353`
- `src/hosts.ern:312`
- `src/static.ern:353`
- `src/shell.ern:199`

#### S14. `Http` lacks a test for whether a list header's elements hold a token, in ASCII case

Two sites write it by hand: `src/connection.ern:338` and `src/shell.ern:164`, each `List.any(Http.elements(...), fn(element) = String.toAsciiLower(element) == token)`. RFC 9110's tokens compare so, and the design states the rule four times (§4, §6, §9, §11).

#### S15. `Crypto` has no HMAC (G.9)

A stateless check that a cookie was drawn by the server, one of S4's fixes, would be HMAC written in the program over `Crypto.sha256`.

#### S16. E.18 is silent on TLS renegotiation

It says "There are no options", and names only versions and ciphers as the host's. The host took one client-initiated renegotiation on TLS 1.2 and refused the next. That is no exposure, but the program cannot choose it, and the page does not say it.

### What I could not run, and why

- **The container path (S6, S7, S8).** podman is not installed on this machine. The deployment's wrapper, image and cgroups are read, not run.
- **An IPv6 /64.** Only `::1` exists locally. S2 is shown with loopback IPv4 addresses, which the code treats the same way, since it keys on `Endpoint.host`'s text.
- **The deployed site and its machine.** Out of bounds by the brief, so the IPv6 reachability S2 assumes is read from the log, not probed.
- **TLS 1.0 and 1.1 refusal.** This OpenSSL client refuses them itself, so the server's answer was not seen. E.18 says TLS 1.2 and 1.3.
- **CPU timing of a trickled WebSocket frame.** A 65,000-byte frame sent a byte at a time cost the server about 4.9 s of CPU, linear in size (32,000 bytes took 2.5 s). A trickled HTTP head cost the same per byte, about 75 µs, so this is the per-piece cost of any read, not the decoder's, and no finding. The BEAM's busy-waiting schedulers make its CPU time read close to wall time, so these figures are an upper bound.

## L, the live shell reader


Scripts and outputs are under `review/L-scratch/` (the full path is in *What I could not run*). Every run used `ern 0.11.0+93a13b13`, a plain listener on 127.0.0.1 (ports 18501 to 18504) and the deployment's shell numbers unless a finding says otherwise: `most-at-once` 6, `starts` 10 an hour, `message-limit` 65536, `hangup` 5000, `idle` 15000 and `write` 30000.

### Real exposures

**L1. One visitor's resizes grow the server's memory without bound, and keep the session alive past its lifetime and the server past its stop.**
- Place: `src/session.ern:266-267`, `src/shell.ern:440`; design §11 *The messages*, §12 *The messages* ("so that the session's mailbox never waits on the program").
- Quote: `| Resize(size) -> { let _ = Os.resize(started.program, size);`
- What is wrong:
  - The reader paces the client against the shell, but nothing paces the shell against the session. Every `{"resize": [r, c]}` becomes a `Resize` in the session's mailbox.
  - The session answers each with `Os.resize`, which is a call, and a call scans its caller's whole mailbox (L13). So the session falls behind at once, and each resize costs more as the backlog grows.
  - The deadline's `Alarm`, the stop's `End(1001)` and the shell's `Detach` all queue behind the backlog.
  - The CPU it burns is the server's own, outside `--cpus 1`.
- What shows it:
  - `flood.py 18501 <pid> resize 14`: one visitor writes resizes for 14 s, 128 MiB in all. The server's RSS went from 101 to 973 MiB, about 60 MiB a second (7 bytes of memory for each byte sent), and did not come down.
  - That session had a 6-second lifetime. It and its `cat` were still alive 408 s later. The server used 100% of a core, while the helper behind `Os.resize` used 20 ms of CPU every 20 s.
  - A termination did not end the server within 50 s; it took a `kill -9`.
  - `quad.py`: N resizes then a stop, timed to the 4004. N = 5k, 10k, 20k, 40k and 80k took 0.15, 0.48, 1.55, 5.64 and 21.4 s, which is quadratic. The 80k run repeated at 21.1 s.
  - The control: the same bursts made of `extend`, which makes no call, took 0.06, 0.22 and 0.70 s for 20k, 80k and 320k.
- On the 1.9 GB machine, a visitor sending a few MB/s runs it out of memory within minutes. Or the visitor holds `systemctl stop` and `restart` (the certbot hook's restart among them) until `TimeoutStopSec=130` kills the unit, which leads to L2.
- Fix: pace the shell to the session as the session paces output. The shell holds the latest size while one resize is under way and sends it when the session answers, or, generally, the shell sends only against a credit.

**L2. A visitor's container outlives the session wherever the wrapper's trap does not finish.**
- Place: `deploy/shell.sh:11-16`; `src/session.ern:510-511` and `519`; report Appendix E.23 ("The processes the program started that are still in its process group are killed with it"); design §13 *The shell's wrapper*.
- Quote: `end() { podman rm -f -t 0 --cidfile "$dir/cid" > /dev/null 2>&1; rm -rf "$dir"; }`
- What is wrong:
  - Only the wrapper's trap removes the container. These all kill the wrapper's process group, its `podman rm` with it:
    - the session, `hangup` (5 s) after the hangup;
    - the session, at once, when its reader or writer ends;
    - the runtime's own death (an OOM kill, `kill -9`, or L1's blocked stop under systemd);
    - systemd, which under `KillMode=mixed` kills what is left once the main process has exited.
  - The container runs under conmon in a session of its own. It survives the group kill and runs on with no deadline, uncounted by `most-at-once`.
  - `rm -rf "$dir"` drops the id even where `rm` failed.
  - The trap neither ends nor waits for `podman run`, so a hangup that comes before podman has written the id finds nothing to remove.
- What shows it: the real wrapper, its temporary directory moved into scratch, run under a stand-in `podman` (`L-scratch/fakebin/podman`) whose container is a process of its own session, as conmon's is.
  - With `rm` taking 6 s: the visitor's stop was answered 4004 at 0.31 s, and the session killed the wrapper's group at 5.2 s. The container (`sleep 600`) and the id directory remained.
  - With `rm` taking 0.2 s: nothing remained (the control).
  - With the server killed by `kill -9` while a session ran: within 2 s the wrapper, the helper and podman were gone without the trap having run. The id directory remained and the container ran on.
- Not run: real `podman rm` times under load, and whether `ExecStartPre=podman system migrate` (which, as I recall podman's man page, stops running containers) sweeps them at the next start.
- Fix: give the container a deadline conmon holds, `--timeout` in `shell.command`. Name it, `--name`, so that the trap (after ending and waiting for `podman run`) and the unit's start both remove it by that name.

**L3. One remote address holds every session for as long as it likes.**
- Place: `src/sessions.ern:117-118`; design §12 *An attach* and *The deadline*.
- Quote: `if Map.size(held.live) + Map.size(others) < held.shell.mostAtOnce && List.size(made) < held.shell.starts.count`
- What is wrong: the cap per address counts starts, not live sessions. Six starts, under the 10 an hour, take all six places. A re-attach under a live cookie counts no start, and `{"extend": true}` moves the deadline without limit. So one visitor keeps every other at 4003 by sending an extend every four minutes.
- What shows it: `mono.py`, with a 6-second lifetime. Six sessions from 127.0.0.1, each re-attached and extended every 2.3 s, all answered `joined` for 23 s, four lifetimes. A visitor from 127.0.0.2 was refused 4003 at each of 11 tries.
- Fix: cap a remote address's live sessions, at one or two, as its starts are capped.

**L4. The caps by address do not hold for a visitor with IPv6.**
- Place: `src/sessions.ern:130` (starts keyed by `remote`), `src/listener.ern` (`count` by `open.remote`); `deploy/config.json` listens on `::`; design §7 and §12.
- Quote: `starts = Map.put(pruned(held.starts, window), remote, now :: made)`
- What is wrong: the key is the address's exact text. A visitor with a /64 has 2^64 of them, so `starts.count` and `connections-per-address` bound nothing. Every session can be taken (L3), containers started as fast as sessions end, and all 80 connections of each listener held.
- What shows it: reading. On localhost, 127.0.0.1 and 127.0.0.2 were counted apart (`mono.py`, `restarts.py`).
- Not run: IPv6 with a prefix. Whether the machine serves IPv6 is not stated in what I read: `deploy/README.md` §1 says "each family it serves".
- Fix: count an IPv6 remote address by its /64 for both caps.

**L5. conmon logs every byte the visitor's program writes, outside every cap (not run).**
- Place: design §13 *The shell's command*; the command in `deploy/README.md` step 7.
- Quote: `-it --rm --network none --read-only ... --mount type=tmpfs,destination=/home/shell,tmpfs-size=64m,U=true ernest-shell`
- What is wrong: the command names no log driver. Under podman's default, journald or k8s-file as containers.conf has it, conmon logs the container's output. conmon runs outside the container's cgroup and outside the session's pacing, so whatever `yes` writes reaches the host:
  - with k8s-file, a file with no size limit until `--rm` removes it, past the 64m tmpfs;
  - with journald, writes until `SystemMaxUse` is full, evicting the machine's older logs.
- What shows it: reading only. podman is not installed, and step 7 checks no log.
- Fix: add `--log-driver=none` to `shell.command`, and have step 7 check `podman inspect --format '{{.HostConfig.LogConfig.Type}}'`.

### Hardening

**L6. A restart passes `most-at-once`.**
- Place: `src/sessions.ern:114-129`; design §12 ("a restart ... never meets the cap") against §13 ("`most-at-once` 6, sized to the machine's 1.9 GB of memory").
- Quote: `replaced = Set.union(held.replaced, Set.fromList(Map.keys(ours)))`
- What is wrong: an ending session under the restarting cookie is counted by nothing, yet its program runs until it exits or `hangup` passes. One address's 10 starts add 10 programs on top of the six, which the memory sizing does not count.
- What shows it: `restarts.py`, with the stand-in's `rm` taking 2 s. Five sessions from 127.0.0.2, then one cookie stopped and restarted ten times from 127.0.0.1: 12 containers ran at once against a cap of 6, and a visitor from 127.0.0.3 was refused 4003 meanwhile. How long real podman takes to kill a container is not measured.
- Fix: count an ending session against `most-at-once` until its program has exited, the restart waiting at most `hangup`.

**L7. No check shows the container's caps hold.**
- Place: `deploy/README.md` step 7 and step 11; design §13 ("so that a program that writes without end ends its own session").
- Quote: "`podman ps` then lists no container, nor does it after a terminal closed before `:quit`, within a second"
- What is wrong:
  - Step 7 runs the command at the operator's terminal, not from the unit.
  - Nothing checks that a container the server starts holds `--memory`, `--pids-limit` and `--cpus`. That needs the user manager's delegation, which the README names only through an error message.
  - Nothing checks that a writer without end ends its own session; the smoke test types `1 + 2`.
  - Swap is not capped either: without `--memory-swap`, a host with swap gives each container 128m more of it.
- Fix: a step 11 check from inside a visitor's session. In Ernest, `Os.run` of `cat /sys/fs/cgroup/memory.max /sys/fs/cgroup/pids.max /sys/fs/cgroup/cpu.max` answers `134217728`, `128` and `100000 100000`. And add `--memory-swap 128m`.

**L8. The client chooses its own cookie.**
- Place: `src/shell.ern:189-197`; design §11 *The cookie*.
- Quote: "The request's cookie is the first value of 32 lower-case hexadecimal digits among the cookies `shell`"
- What is wrong: the server takes any value of the cookie's form, not only one it drew, and the name has no `__Host-` prefix. Suppose a sibling host of `ernest-lang.org` is not this server's and an attacker controls it. A page there can set `shell=<known>; Domain=ernest-lang.org; Path=/shell/session` in a visitor's browser, then attach under that value and take over the visitor's session, output and keys, with 4002.
- What shows it: reading; the test `acceptsUpgrades` keeps a carried cookie. Whether such a host exists is not known to me.
- Fix: take only a cookie the server drew: its 16 random bytes and a MAC of them under a key drawn at the start.

**L9. The container's root is the server's own user.**
- Place: design §13; `deploy/README.md` step 2 ("whose home ... holds ... podman's storage").
- What is wrong: rootless podman maps the container's uid 0 to the invoking user, `httpd`, which owns `privkey.pem`, the node's keys and the access log. `--cap-drop=ALL` and `no-new-privileges` close the ordinary ways to root inside the container, so this is defense in depth.
- Fix: add `--userns=nomap` to `shell.command`, or run podman as a user of its own.

**L10. The image is pinned by tag.**
- Place: `deploy/Containerfile:70`; design §13 ("pinned to its full tag").
- Quote: `FROM docker.io/library/erlang:29.1.2.0-slim`
- What is wrong: the registry can move a tag.
- Fix: pin by digest, `erlang:29.1.2.0-slim@sha256:...`.

### Defects that are no exposure

**L11. A shell waits for its attach's answer with no deadline and no read.**
- Place: `src/shell.ern:303-304`; `src/sessions.ern:103-107`; design §11 *The reader*.
- Quote: `Some(Attaching(_) as attaching) -> serving(connected, attaching, reader)`
- What is wrong: while an attach is under way no `Read` is outstanding, so neither `Idle` nor the client's close reaches the shell. The sessions pass an `Attach` to any session their map still holds. A session that died before the sessions took its `Down`, and that ended without its `Ending` answered (that call has a deadline, `hangup`, or the session was killed), drops the attach. The shell then holds its connection and its place in the caps until the program ends. Under L1, an attach under a backlogged session's cookie waits behind the backlog.
- Fix: bound the wait by the idle deadline, and close with 1011 when it passes.

**L12. A displaced shell's last read still reaches the session.**
- Place: `src/session.ern:260-275`.
- Quote: `| Keys(bytes) ->`
- What is wrong: `Keys`, `Resize`, `Extend` and `Stop` carry no shell. After a takeover the old shell keeps the session's address until it takes `Ended(4002)`, and what one `Received` of its holds, a stop among it, reaches the session the new shell holds. Only the cookie's holder is reached.
- Fix: carry the shell's address in those four and drop them from a shell not attached, as `Written` and `Detach` are dropped.

### Ernest's

**L13. A call scans its caller's whole mailbox for its answer, and the report does not say so.**
- The program that shows it: `L-scratch/probe/call_cost.ern` makes 1000 `Address.call`s to an echo process with 0, 10k, 20k, 40k and 80k messages waiting. They took 2, 65, 128, 250 and 513 ms.
- Report §6.6 states no cost. A reader who knows Erlang predicts a wait for the reply that skips what was waiting before the call (principles 1 and 3).
- Every library function over a call carries the cost: `Os.resize`, `Os.closeInput`, `Tcp.read` and `Tcp.write`. It is the engine of L1.
- The ask: a call's wait that passes over the messages queued before its request, or the cost stated in §6.6.

**L14. Appendix E.23 names no signal for a kill.**
- It does not name the signal sent to a program, or to its process group, when the program is killed, nor what the program is sent when the runtime itself is killed.
- Observed: the wrapper's `HUP` and `TERM` traps did not run, neither at the session's kill after `hangup` nor at the runtime's `kill -9` (L2). A program that must clean up cannot learn from the page whether it will get the chance.
- The ask: name the signal, and offer a kill that sends the termination first and waits a bound.

**L15. No way to bound a mailbox or pace a send.**
- The program paces by hand, with one request for each answer, at four sites: the listener's acceptor (`Accept`), the shell's reader (`Read`), the session's reader (`Read`, with the shell's `Written`) and the session's writer (`Write` and `Wrote`).
- The one channel without such pacing, the shell's to the session, is L1. A mailbox's growth is invisible at the `send` that causes it (principle 3).
- The ask: a bound on what a mailbox holds, or a form the report states for pacing.

**L16. A helper ends with its owner only by monitoring it, at three sites.** They are the shell's reader and the session's reader and writer. Each is marked "since a process the program spawns ends with no other (report §6.9)", and each carries a `...Ended(Down)` constructor and a clause for it. The ask: a spawn whose process ends with the process that spawned it.

**L17. The library has no WebSocket.** `src/web_socket.ern` holds RFC 6455's framing and accept value in 550 lines before its tests, "written as a library of Ernest's is" (design §10): a published specification in the program. Appendix G.11, `Http`, offers no upgrade. The ask: a `WebSocket` library beside `Http`.

**L18. `Bytes` has no map and no XOR.** Masking is a loop of one byte a call, the key's bytes turned each step (`src/web_socket.ern:537`, `maskedFrom`). The ask: `Bytes.map`, or a XOR of two `Bytes`.

### What I could not run

- podman is not installed, so I built no image and ran no container. The container's caps, conmon's log (L5, L7), real `podman rm` times and the sweep by `podman system migrate` (L2) are read, not run. The wrapper ran under a stand-in `podman`, its temporary directory moved from `/run/user/<uid>` into scratch and its text otherwise verbatim.
- systemd: the unit was not run. `KillMode=mixed`, `TimeoutStopSec` and the user manager's delegation are read; L1's blocked stop is shown with a plain termination.
- Not run either: IPv6 with a prefix (L4), TLS (every run was plain HTTP on 127.0.0.1), and the client in Chromium (`src/client.ern` was read; it takes no visitor input into its head).
- Nothing of the deployed site or its machine was touched.
- Scratch: `/tmp/claude-1000/-home-jocke-src-ernest-httpd/4404feb7-00fb-43d8-b004-4450d500f02c/scratchpad/review/L-scratch/`. Every process I started was stopped by its number; the server L1 held needed `kill -9`.

## C, the code reader


I read every file whole:

- `src/`, all 13 modules
- `tools/docs.ern`
- `examples/`: the README, `site/config.json`, `site/root/shell.js` and `shell.html`
- the eight files of `deploy/`
- the `Makefile` and `bin/ernest_httpd`

I read them against `docs/design.md`, report §0, E.0's shape rules and the installed `guide/style.md`. My clone is `scratchpad/review/C`, and everything else I wrote went under `scratchpad/review/C-scratch/`.

On the restored clone, `make test ERN=/home/jocke/opt/local/bin/ern` exits 0. The repository has no `foreign fn`: `grep -rn foreign src tools examples` finds nothing.

### Defects

**C1. The configuration's headers may repeat two headers the server writes itself, with conflicting values.**

- **Place:** design §4, line 94, and the refused names in `src/config.ern`.
- **Quote:** "`be none of Allow, Connection, Content-Length, Content-Type, Date, Last-Modified, Location, Sec-WebSocket-Accept, Set-Cookie, Transfer-Encoding and Upgrade` … which the server writes itself".
- **What is wrong:** the server also writes `Cache-Control`, on the client's response (§14), and `Sec-WebSocket-Version`, on the 426 (§11). Neither is on the list.
- **A test pins it:** `connection.ern`'s `first` configures `Cache-Control: no-store`, and `servesTheClient` expects that header twice on the client's response.
- **Shown:** `C-scratch/headers.json` sets `"headers": {"Cache-Control": "max-age=3600", "Sec-WebSocket-Version": "8"}`, served on 18200.
  - `curl -i http://localhost:18200/shell/client.js` answers `Cache-Control: max-age=3600` and then `Cache-Control: no-store`.
  - An upgrade with `Sec-WebSocket-Version: 7` answers 426 with `Sec-WebSocket-Version: 8` and then `Sec-WebSocket-Version: 13`. RFC 6455 §4.4 reads that as "8 and 13 are supported".
  - The 101 carries `Sec-WebSocket-Version: 8` as well.
- **Fix:** add `Cache-Control` and `Sec-WebSocket-Version` to §4's list and to Config's, and drop `Cache-Control` from the test's `first`.

**C2. `tools/docs.ern` checks no backticked path after line 94 of `docs/design.md`.**

- **Place:** `tools/docs.ern`, `pathsIn`.
- **Quote:** ``let pieces = String.split(unfenced(text), "`")``.
- **What is wrong:** the check splits the whole text at every single backtick. Line 94 writes the token characters as a double-backtick span that holds a backtick: ``` ``!#$%&'*+-.^_`|~`` ```. That makes 11 backticks on the line, so prose and code swap from there to the end of the file.
  - Every path after line 94 goes unchecked: the rest of §4, §5 to §14 and the glossary.
  - Line 94 is the only line outside a fence in a tracked document with an odd count of backticks.
  - The file's header comment ("Every backticked path in a tracked document … names something that is there, or the program says which does not") no longer holds.
- **Shown, in the clone:**
  - ``printf '\nThe module `src/nothing.ern` is no file.\n' >> docs/design.md && ern run tools/build/docs.erc`` ends with status 0 and says nothing.
  - The same sentence inserted after line 5 says ``docs/design.md: `src/nothing.ern` names nothing`` and ends with status 1.
  - I restored the file by `git checkout`.
- **Fix:** read a code span by its run of backticks, as CommonMark does: a span opened by n backticks closes at the next run of n. The file is the template's, so the fix goes to ernest-template.

**C3. A control character in a member's name reaches standard error raw.**

- **Place:** `src/config.ern`, `members` (line 456), and every `Invalid(field = member(prefix, key), …)`.
- **The rule:** design §4, line 77: "A string of the file, a member's name among them, breaks `hold no control character`".
- **First wrong:** a member that is no field is refused as `is no field of` with its name as written. The name's control characters are never checked, so the rule is not kept for that name.
- **Second wrong:** where the rule is checked (`strings`, for headers and content-types), the refusal escapes the value but writes the field with the raw name. The intent at config.ern:470, "so that a control character refused is seen", holds for the value alone.
- **Shown:**
  - A top-level member `"\u001b[31mroot\u0007": 1` gives `../C-scratch/control.json: \033[31mroot\a is no field of the configuration` and status 1 (`od -c` of standard error).
  - `"headers": {"X\u001b[2J": "v"}` gives `headers.X\033[2J must hold no control character: "X\u001B[2J"`.
- **Design silent:** the design does not say how a field is written when its name holds a control character.
- **Fix:** check a name's control characters before `is no field of`, and write a name in `field` the way `invalid` writes a value. The design gains the sentence.

**C4. A member named twice is taken silently, and the last one wins.**

- **Place:** `Config.parse` over `Json.parse`. Design §4 is silent on it.
- **Shown:** a listener `{"kind": "plain", "address": "127.0.0.1", "port": 18203, "port": 18202}` started with the line `listening on 127.0.0.1:18202` and no warning. CLAUDE.md says "Input is never accepted silently".
- **Cause:** `Json.parse` keeps the last value and cannot tell (C21).
- **Fix:** §4 gains a sentence. Until Ernest answers C21, it is a line of `known_issues.md` and of `language_feedback.md`.

**C5. Echoing every client Close as 1000 passes every test.**

- **Place:** `src/shell.ern:394`, `let _ = write(connected, WebSocket.Close(=code, reason = ""));`.
- **The rule:** design §11: "a `Close` is answered with a `Close` of its code".
- **Broken:** I changed `=code` to `code = Some(1000)`. `ern test` passed every case of `build/shell.erc`, `build/connection.erc` and `build/listener.erc`.
- **Why it passes:** every client Close in the tests carries 1000 (shell.ern 961, 1165, 1267, 1333; connection.ern 1315). None carries another code, and none carries no code.
- **Fix:** `answersPingsAndCloses` also sends a close of 4000 and a close with no code, and expects each back.

**C6. The browser test cannot tell the warning's seconds from a constant.**

- **Place:** `src/client.ern:162`, `told.warning(message.warning * 1000);`.
- **The rule:** design §14: "`left` the seconds times 1000".
- **Broken:** I changed it to `told.warning(1000);`. `ern test build/client.erc` gave "runs a session in a browser: passed".
- **Why it passes:** the scenario's warning is 1000 ms, which is one second, so seconds times 1000 is 1000 either way.
- **Fix:** give the scenario a warning of 2000 under a lifetime above it, and expect `second warning 2000`.

**C7. No test reaches the smoke test's dimmed answer.**

- **Place:** `src/smoke.ern:319`, `List.any(["3" <> Ansi.styled(" : Int", Ansi.Dim), "3 : Int"], …)`.
- **The rule:** design §13: "its type dimmed as the shell writes it at a terminal, or plain where `NO_COLOR` is set".
- **Broken:** I changed the dimmed form's `" : Int"` to `" : Str"`. `ern test build/smoke.erc` passed all five cases.
- **Why it passes:** the stand-in command writes the plain `3 : Int`. No test reaches the form `ern shell` writes at a terminal, which is the one the deployed shell would write.
- **Fix:** the stand-in writes the dimmed bytes, and `holdsTheAnswer` gets a test of both forms.

**C8. The page is not told "the milliseconds before the end" when the warning is not a whole number of seconds.**

- **Places:**
  - `session.ern:442`, `Warning(shell.warning / 1000)`, and `client.ern:162`.
  - Design §12, line 322: `shell.warning / 1000`.
  - Design §14, line 402: `told.warning(left) // the milliseconds before the end`.
  - Design §4, line 103, which allows the warning to be any number of milliseconds.
- **What is wrong:** a warning of 1500 tells the page 1000, and a warning of 500 tells it 0. The tests pin `Warning(0)` (session.ern:1201) and `Json.Integer(0)` (shell.ern:1084), and the example page would then show the current time as the end.
- **Design silent:** on a warning that is not a whole number of seconds.
- **Fix:** add the rule "be a multiple of 1000" to §4, or have the message carry milliseconds.

**C9. A shell waiting on an attach has no deadline and watches nothing.**

- **Place:** `shell.ern`, `serving` in `Attaching`, which has no Read outstanding and no monitor, as design §11 has it. The sessions process is spawned unmonitored (`sessions.ern:66`, `spawn`).
- **What is wrong:** if that process ends, every shell that is attaching waits forever. Each holds a place in its listener's cap, and none notices its client leave. At the program's end, `Address.callForever` on the dead sessions process faults the entry process.
- **Not run:** this needs the sessions process to fault, so it is from reading only.
- **Fix:** the shell monitors the sessions' process while `Attaching`, or the entry process monitors it as it does a listener.

### The design not kept, and code no section states

**C10. The connection writes with `Tcp.write` over `Http.renderResponse`, against E.0 shape rule 11, and design §6 says the same.**

- **Places:** `connection.ern:245-246`, and the test helpers `client.ern:602` and `shell.ern:806`.
- **The rule:** shape rule 11: "a program over `Http` writes its response with it [`Http.writeResponse`] and not with `Tcp.write`".
- **The design:** §6 says "It is written with `Http.renderResponse` within the write deadline". The log has no entry on the choice.
- **Fix:** §6 names `Http.writeResponse`, and the connection calls it. The `Left(_)` clause stays as it is.

**C11. Design §6's "a 101 carries its own `Connection: Upgrade` and none of these" reads two ways.**

- **What the code does:** it reads "these" as the two `Connection` values. The 101 carries `Date` and the configuration's headers (shown in C1).
- **Fix:** "and neither `Connection` header above".

**C12. `deploy/shell-start.sh` reads foo's standard output and standard error together, `2>&1`, but §13 says otherwise.**

- **The design:** line 360 says "reading its standard error until its line `listening on`".
- **Fix:** §13 says "its output".

### Clarity

**C13. Cases that cannot come are given a value.** This is the kind eea919b swept. The style guide says such a clause faults and its cause says why the case cannot come. There are 8 sites:

- `session.ern:137-142`: `| [] -> #("", [])`. §4 refuses an empty command.
- `session.ern:282`: `Answered(Right(Os.Stderr(bytes)))` shares Stdout's clause. Its own comment says a terminal answers Stdout alone (E.23).
- `connection.ern:125`: `Left(Http.Protocol(_)) -> unread(connection, 400) // Malformed: a head's read answers no BodyTooLarge`.
- `static.ern`, `segment`: `Either.fromOptional(Uri.decode(written), 400)`. `Http.target` encodes every `%` that begins no encoding (G.11), so `decode` cannot answer None.
- `shell.ern:473`: `Unattached or AttachedTo(_) -> []`. `Attached` comes only while `Attaching`.
- `shell.ern`, `outputWritten`: `Unattached or Attaching(_) -> Unit`. `Output` follows `Attached` from the one sender.
- `shell.ern`, `serving`: `Idle` in `Attaching(_)` closes. No Read is outstanding while `Attaching`, so no `Idle` can come.
- `config.ern:216-227`: the second `match kindName` ends `| _ -> Right(Plain)`. The first match already refused every other kind.

Fix: each clause faults with its reason. `listener` can be one match.

**C14. The tests that launch the server answer a dummy port when the count is wrong.**

- **The three sites:**
  - `ernest_httpd.ern:534-537`: `| _ -> #(0, 0, 0)`.
  - `ernest_httpd.ern:646-649`: `| _ -> #(0, 0)`.
  - `smoke.ern:640-643`: `| _ -> #(0, 0)`.
- **What is wrong:** `Smoke.launch` reads until it has at least `count` lines, so more ports can come. These tests then connect to port 0 and fail far from the cause.
- **The other way:** `listener.ern:573` and `client.ern:500` answer `Left("… ports …")` instead. That is two ways for one thing across 5 sites.
- **Fix:** `launch` answers exactly `count` ports or `Other`, and every site matches as `listener.ern` does.

**C15. The same forms are written over and over.**

- `header(name, value)`, 4 times: `static.ern:353`, `hosts.ern:312`, `connection.ern:353`, `shell.ern:199`.
- `headed`, word for word, twice: `hosts.ern:193` and `connection.ern:324`.
- `isControl`, twice: `static.ern:307` and `config.ern:517`. Both are narrower than the library's `Char.isControl`, which is category Cc and adds U+0080 to U+009F.
- The test certificate and key, 27 lines, twice: `ernest_httpd.ern:246-264` and `connection.ern:479-497`.
- `next(socket)`, 3 times: `listener.ern:369`, `ernest_httpd.ern:389`, `connection.ern:583`.
- `next(name)`, twice: `sessions.ern:314` and `session.ern:685`.

Fix: `Static` exports `headed` beside `withoutBody`. `isControl` becomes `Char.isControl` with §4 and §5 widened to Cc, or one shared definition. For the rest, see C25 and C26.

**C16. `hosts.ern` does work on every request that it could do once.**

- `site(config)` (line 188) rebuilds `Static.site` with a `Map` for every 421 and 400. `Static.error` reads the site only for a 404, and the Server already holds the site.
- `named` (line 84) parses every configured host with `Config.host` on every request.

Fix: `decide` takes the server's site, and the hosts are parsed once.

**C17. Prefixes are cut by hand.**

- **The sites:**
  - `hosts.ern`, `challenged`, compares lists of `Char` with `List.take`, `List.drop` and `challengePath : List(Char)`, "By code point". A target is visible ASCII (G.11).
  - `smoke.ern`, `portSaid`, uses `String.replace` and then compares.
  - `smoke.ern`, `stopSeconds`, uses `startsWith` and then `replace`.
- **Fix:** `String.stripPrefix`, then `String.startsWith(rest, "/")` for the challenge.

**C18. `Shell.handshake` uses an empty string as a sentinel for the Origin.**

- **Place:** `shell.ern:130`, `!List.contains(shell.origins, Optional.withDefault(origin(headers), ""))`.
- **What is wrong:** `""` stands for "no Origin, or two". It holds only because §4 refuses an empty origin.
- **Fix:** match on `origin(headers)`.

**C19. Names that do not say what their value is.**

- **`listener.ern`, `type Asking = Asked | Retrying | Waiting`:** `Waiting` means "at the cap, asking for none". It stands beside the loop `waiting`, and the function `asked` stands beside the constructor `Asked`. Fix: name the state `AtCap`.
- **`config.ern`, the function `object`:** the locals `object` in every reader shadow it, so `objectField` writes `Config.object(member(prefix, name), value)` inside Config itself. Fix: `objectValue`, as `stringValue` is named.
- **The moment a wait began:** it is named `start` at 8 sites and `key` at a ninth.
  - `start`: `listener.ern:378`, `listener.ern:577`, `ernest_httpd.ern:542`, `shell.ern:1479`, `connection.ern:1135`, `session.ern:1025`, `session.ern:1140`, `session.ern:1233`.
  - `key`: `session.ern:1184`.
  - The style guide's glossary names it `since`.

**C20. `connection.ern`, `responded`, compares the version in a second way.**

- **Quote:** `when read.version.minor == 0`.
- **What is wrong:** `refusal` and `closes` compare whole versions (`version(1, 0)`, `Http.http11`).
- **Fix:** `read.version == version(1, 0)`.

### Ernest's own findings

**C21. `Json.parse` keeps the last of a member named twice and gives no way to tell.**

- **Where Ernest says so:** the report's library, line 1214: "where a text names a member twice the last is kept".
- **The program it costs:** C4, a configuration taken silently.
- **Principles:** 3 (nothing invisible) and 1 (least surprise).
- **Ask:** `Json.parse` refuses a member named twice, or a reader answers an object's members in order, duplicates kept.

**C22. A head's read answers `Http.Error`, whose `BodyTooLarge` it never answers.**

- **Where Ernest says so:** line 1330 of the report's library, G.11.
- **Cost:** a clause at `connection.ern:125` for a case the page rules out (C13).
- **Principle:** 3.
- **Ask:** the head readers answer an error without `BodyTooLarge`.

**C23. `Os.read` on a program under `startTerminal` answers `Stdout` alone, but its type keeps `Stderr`.**

- **Where Ernest says so:** line 878 of the report's library, E.23.
- **Cost:** `session.ern:282` (C13).
- **Principle:** 3.
- **Ask:** a terminal's read answers its own type.

**C24. A path from `Http.target` cannot hold a broken `%`, yet `Uri.decode` answers `Optional`.**

- **Where Ernest says so:** lines 1296 and 1366 of the report's library.
- **Cost:** `static.ern`, `segment`, gives `None` a 400 (C13).
- **Principle:** 3.
- **Ask:** `Http.target` answers decoded segments, or a decode that cannot fail on what `target` wrote.

**C25. A constructor of two named fields has no positional form.**

- **Where Ernest says so:** the report's language, line 246.
- **Cost:** every module that builds headers wraps `Http.Header(name = n, value = v)` as `header(n, v)`: a form repeated at 4 sites (C15).
- **Principle:** 2.
- **Ask:** a short way to build an `Http.Header`.

**C26. Nothing lies between a module's own and its exports, so two modules' tests cannot share a fixture without copying it or exporting it.**

- **What is copied:** the certificate and key, 27 lines, twice; `next(socket)` 3 times; `next(name)` twice.
- **What is exported:** `Smoke` exports `get`, `upgrade`, `masked`, `readOutput`, `launch` and `terminate` for the tests of six modules, and `ern doc` shows them as the smoke test's.
- **Principle:** 2.
- **Ask:** a way for tests to share a fixture that is no part of a module's exports. I found no such way in the installed pages.

**C27. No `Bytes` function XORs a key over bytes.**

- **Cost:** `web_socket.ern`'s `maskedFrom` masks one byte at a time with the four key bytes rotated as arguments, at 1 site.
- **A missing line:** CLAUDE.md says such a function gets its line in `language_feedback.md`, and there is none.
- **Principle:** 5.
- **Ask:** `Bytes.xor(bytes, key)` with the key repeated.

There was no opaque page, no message I did not understand, no refusal and no toolchain defect.

### What I could not run, and why

- **The deployed site and its machine:** not touched, as the brief says.
- **C9:** read only. Showing it needs the sessions process to fault.
- **The dimmed answer against a real `ern shell` at a terminal:** not run. C7 shows only that no test reaches it.
- **The smoke test's TLS checks:** not run. They need a certificate that the host's bundle verifies.
- **`deploy/`'s unit, wrapper, Containerfile, certbot hook and logrotate:** read, not run. Running them needs root, podman and systemd as the operator has them.
- **Timing:** no timing was run, and no load.

### What I broke, started and ended

**Breaks:** each was restored by `git checkout` before the next, and `git status` is clean at the end.

- `src/shell.ern:394` (C5)
- `src/smoke.ern:319` (C7)
- `src/client.ern:162` (C6)
- `docs/design.md`: an appended line, then an inserted one (C2)

**Processes:**

- I started two servers: pid 3920661 on 18200 and pid 3940385 on 18202. Each was ended by SIGTERM to its pid, and both exited.
- Two runs under `timeout 30` exited at once with status 1 (C3).
- `ss -ltn` shows nothing on 18200 to 18299, and no process with the clone's path is left.

## K, the cold reader


Read: `README.md`, `examples/` whole, `deploy/` whole, and the thirteen pages `make doc` wrote under `build/`. Nothing under `docs/`, `src/` or `tools/`, and no text of the Makefile or the launcher. Built and run in the clone with `ern 0.11.0+93a13b13` from `/home/jocke/opt/local/bin` on `PATH`. In the commands below `K` is the clone and `S` is `K-scratch`.

Most serious first within each part. K1 to K13 are defects, K14 to K19 matters of clarity, K20 to K24 Ernest's.

### Defects

**K1. `make release` is refused with the only Ernest the README's floor can be met with.**
- Place: `README.md` line 59 and line 75.
- Quote: "It needs Ernest on your `PATH`, the release `package.conf` names or a later one, `ern 0.11.0`" and "`make release    # the archive, build/ernest_httpd-VERSION.tar.gz, and its checksum beside it`".
- Wrong: `make release` ran the whole of `make test` and `make doc`, then stopped: `a release is not made with a development build of ern`, `make: *** [Makefile:235: release] Error 1`. The installed `ern` says `0.11.0+93a13b13`, which Ernest's report §11.7 calls an archive off the release's tag, "no release". The README names no such condition, and its line for `make release` promises the archive. The refusal comes last, after 20 seconds of tests. So no archive was to be had, and every step that starts from one went unrun (see the end).
- Shows it: `cd K && PATH=/home/jocke/opt/local/bin:$PATH make release`.
- Fix: say in the README's line for `make release` that it takes a release build of `ern`, one whose version text is the version alone, and check that first, before the tests.

**K2. The smoke test cannot pass against a site whose canonical host carries a port.**
- Place: `build/smoke.md`, the module's page, second paragraph; `Smoke.main`.
- Quote: "`/` on the redirect port, and `/` for the redirect host it is given ... each answered 301 to `https://`, the host and `/`", beside "from the origin a page of the site sends, `https://` and the host, with `:` and the port where it is not 443".
- Wrong: the page allows a TLS port other than 443 for the origin, but the two 301 checks expect `https://HOST/` while the server writes `Location` with the canonical host "as the configuration writes it, its port among it" (`build/hosts.md`). With `canonical-host` `localhost:18150`: host `localhost` gives `http://localhost:18151/ answers 301 to https://localhost/: failed: 301 https://localhost:18150/`; host `localhost:18150`, the canonical host the page asks for, gives `https://localhost:18150:18150/ answers 200: failed: Io.Other("non-existing domain")` on every line.
- Shows it: `deploy/config.json` with its paths under `S/srv`, addresses `127.0.0.1` and `::1`, ports 18150 and 18151, `canonical-host` `localhost:18150`; serve it, then `ern run build/smoke.erc localhost S/srv/node2/config.json` and `ern run build/smoke.erc localhost:18150 S/srv/node2/config.json`.
- Fix: expect `https://` and the configuration's `canonical-host` as written in the two 301 checks, and dial the host without its port.

**K3. `shell.origins` takes what is no origin without a word, and the shell then answers every page 403.**
- Place: the configuration's `shell.origins`; `build/config.md`, *Config.Shell*, "the origins allowed".
- Wrong: `["http://localhost:18130/"]` (one slash too many), `["localhost"]`, `["*"]` and `[]` each start the server. A browser's `Origin` never carries a path, so the first refuses every upgrade, 403, and nothing at the start or on standard error says why. Every other field I broke was refused by name.
- Shows it: `S/cfg/v_origin_path.json`, the example's configuration on ports 18130 and 18131 with `"origins": ["http://localhost:18130/"]`; `bin/ernest_httpd` starts; the examples page's upgrade line, from `Origin: http://localhost:18130`, answers `HTTP/1.1 403 Forbidden`.
- Fix: refuse an origin that is not a scheme, `://`, a host and an optional port, and an empty list, as the other fields are refused.

**K4. The 431 has no phrase.**
- Place: `build/static.md`, *Static.error*.
- Quote: "plain text naming the status and its phrase, `404 Not Found` and a line feed".
- Wrong: headers past `limits.headers` answer the status line `HTTP/1.1 431 ` and the body `431 ` and a line feed, five bytes, and the access log's size says 5. `Http.reason` gives a phrase to RFC 9110's statuses alone (report Appendix E, `Http.reason`), and 431 is RFC 6585's (K20).
- Shows it: `curl -i -H "X-Big: $(printf 'a%.0s' $(seq 1 17000))" http://localhost:8080/`.
- Fix: the program gives 431 its phrase, `Request Header Fields Too Large`, until the library names it.

**K5. The installed launcher does not run through a link.**
- Place: `README.md`, *Running*: "the installed `ernest_httpd` runs the same way".
- Wrong: with `S/bin/ernest_httpd` a symbolic link to `S/prefix/bin/ernest_httpd`, the common way to put a prefix's program on `PATH`, the run fails `ern run: S/package.conf: no such file`, status 1: the launcher takes its root from the link's place. Run by its own path, from any directory and from a prefix moved whole, it works.
- Shows it: `make install PREFIX=S/prefix; ln -s S/prefix/bin/ernest_httpd S/bin/; S/bin/ernest_httpd config.json`.
- Fix: the launcher resolves its own path through links before it takes its root.

**K6. The launcher's command line: four answers that are not the README's usage line.**
- Place: `README.md` line 91, `bin/ernest_httpd [--config-dir dir] config.json`.
- Wrong: (a) `bin/ernest_httpd --config-dir` says `bin/ernest_httpd: 19: shift: can't shift that many`, the shell's own error, status 2. (b) `bin/ernest_httpd --help` says `--help: cannot read the file: Io.NotFound`, status 1: an option is read as the configuration's path. (c) The usage line is `usage: ernest_httpd config.json`, without the `[--config-dir dir]` the README gives. (d) With no `ern` on `PATH` it says `bin/ernest_httpd: 25: exec: ern: not found`, status 127.
- Fix: one usage line, `usage: ernest_httpd [--config-dir dir] config.json`, for a missing directory and for any word that begins with `-`; and a sentence where `ern` is not found.

**K7. `make run` on a machine that cannot reach npm serves nothing, and says so in three tools' words.**
- Place: `README.md` lines 45 to 53; `examples/README.md` line 19.
- Wrong: the README's first step says nothing of a fetch; only the list of targets and the examples page do. With the fetch failing, `make run` ends before the server starts: `curl: (7) Failed to connect ...`, an empty line, `gzip: stdin: unexpected end of file`, `tar: Child returned status 1`, `tar: Error is not recoverable: exiting now`, `make: *** [Makefile:121: xterm] Error 1`. The site's four pages need no xterm.js.
- Shows it: after `make clean`, `https_proxy=http://127.0.0.1:9 make run`.
- Fix: say beside `make run` in the README that the first run fetches xterm.js from registry.npmjs.org with `curl`; and one line of the build's own where the fetch fails.

**K8. Two things the configuration takes silently.**
- Place: the configuration; `README.md` line 96.
- Wrong: (a) a member written twice is accepted and the last wins: `"root": "x", "root": "examples/site/root"` serves the second. Ernest's own `ernest.conf` refuses a field named twice. (b) `"access-log": "build"`, a directory, passes the start, where a missing directory is refused, and every response then writes `build: Io.NotAFile` on standard error and loses its line.
- Shows it: `S/cfg/v_duproot.json` and `S/cfg/v_logisdir.json`, each served and asked `/`.
- Fix: refuse a member named twice, and an `access-log` that names a directory.

**K9. A directory's 301 drops the query.**
- Place: `build/static.md`, *Static.serve*, "a redirect to a directory's path".
- Wrong: `GET /guide?x=1` answers `Location: /guide/`. The host's 301 keeps the query (`build/hosts.md`: "the target's path and query"), so the two redirects of one server differ.
- Shows it: `curl -i 'http://localhost:8080/guide?x=1'`.
- Fix: `Location` is the path, `/`, and the query where there is one; or the page says the query goes.

**K10. `deploy/README.md` step 10 quotes a message logrotate does not say.**
- Place: `deploy/README.md` line 197.
- Quote: "`unknown user 'httpd'` where step 2 did not make the user".
- Wrong: on this machine, Debian 13.8 with logrotate 3.22.0 and no user or group `httpd`, the line is `error: deploy/logrotate:8 unknown group 'httpd'`, then `error: found error in /home/httpd/ernest-httpd/log/access.log, skipping`.
- Shows it: `/usr/sbin/logrotate -d K/deploy/logrotate`.
- Fix: quote `unknown group 'httpd'`.

**K11. `deploy/README.md` step 4 describes the version text of an Ernest the server's release cannot be made with.**
- Place: `deploy/README.md` line 55.
- Quote: "`ern --version` prints the version and, after its `+`, the commit Ernest's archive was made from."
- Wrong: the transcript above it shows `ern VERSION`, a release's text, which has no `+` (Ernest's report §11.7), and `make release` refuses an `ern` whose text has one (K1). The archive "the release was built with" therefore never prints a `+`.
- Fix: "`ern --version` prints the version alone."

**K12. `deploy/README.md` step 12 names one of a session's two helpers.**
- Place: `deploy/README.md` line 245.
- Quote: "a session, spawned in `Sessions`, its program, `Os.startTerminal`, and its reader, spawned in `Session`".
- Wrong: `:processes` on a node with one visitor lists two processes spawned in `Session`, `Session.serve:148 calling Os.startTerminal` and `Session.serve:149 receiving`, the reader and the writer of `build/session.md`. The rest of the step's listing matched line for line.
- Shows it: `ern config` for `S/node` (listening on 127.0.0.1:18140) and `S/ops`, each listed in the other; the installed launcher with `--config-dir S/node`; a shell page opened; `printf ':processes\n:quit\n' | ern shell --config-dir S/ops --attach node`.
- Fix: "its reader and its writer, spawned in `Session`".

**K13. The tree is 0.1.0 by name and no longer 0.1.0 by what it needs.**
- Place: `CHANGES.md` line 7; `VERSION`; `deploy/README.md` line 9.
- Quote: "an Ernest program built with `ern 0.9`" and "Ernest's, `ern-VERSION.tar.gz`, the one the release was built with, which its section of `CHANGES.md` names".
- Wrong: `VERSION` says 0.1.0 and `package.conf` says `"ernest": "0.11.0"`. An operator who makes the archive from this commit gets `ernest_httpd-0.1.0.tar.gz`, is sent to the 0.1.0 section for Ernest's version, and reads `ern 0.9`, which is neither a whole version nor the one this tree builds with.
- Fix: the next release's section names `ern 0.11.0` whole, and `VERSION` moves when the floor does.

### Clarity

**K14. The configuration's fields are not in anything a user of the program reads.**
- Place: `README.md` line 96: "the design's §4 ... describes each field with its rule".
- Wrong: I wanted the file's members, their spelling and their units, and found them only by reading the two example files and by breaking fields to read the refusals. `build/config.md` gives the record's names, `canonicalHost`, `mostAtOnce`, and not the file's, `canonical-host`, `most-at-once`, and says nothing of `kind`'s three words or of which member each kind takes. I did not open the design, as the brief has it.
- Fix: `build/config.md`'s page carries the file's members with their rules, or the README says the design's §4 is the user's reference and stands alone.

**K15. The README describes machinery this program does not have.**
- Place: `README.md` lines 82 to 84, 106 and 110.
- Quote: "it then builds each Erlang application `ERL_DEPS` names, a git submodule under `erl/`", "A repository with an `erl/` is cloned with `--recursive`", "`test/`, where it exists", "listed with its licenses in `THIRD_PARTY_LICENSES`".
- Wrong: `package.conf` names no package, and there is no `erl/`, no `test/` and no `THIRD_PARTY_LICENSES`. `ERL_DEPS` is named and never said to be a variable of the Makefile. I read two paragraphs to learn that none of it applies.
- Fix: one sentence, "this program names no package and loads no Erlang application", before or in place of the two paragraphs.

**K16. A configuration that is not JSON is said with a byte's number.**
- Place: `build/config.md`, *Config.reason*, "`is not JSON: ` and the error".
- Quote: `cfg/notjson.json: is not JSON: Json.UnexpectedByte(byte = 111, at = Json.Position(line = 1, column = 2))`.
- Wrong: the operator is given 111 to look up, and a value of Ernest's where every other refusal is prose.
- Fix: `is not JSON: line 1, column 2: "o" was not expected`.

**K17. The shell page says "unavailable" and nothing more.**
- Place: `examples/README.md` line 11; `examples/site/root/shell.js`.
- Wrong: past either cap the status line reads `unavailable`. The page's sentence gives the lifetime and the warning, and the client's `limits` carries `mostAtOnce` and `starts` too, which the page does not use. A visitor cannot tell a full server from a server that is down, nor when to come back. I met it after ten starts of my own tests.
- Fix: the page's sentence adds the two caps from `limits`.

**K18. The installed example cannot show its shell.**
- Place: `deploy/README.md` line 57, "its documents under ... `share/doc/ernest_httpd/`, `deploy/` and `examples/` among them".
- Wrong: `make install` copies `examples/site/` without `root/xterm/`, and installs no Makefile to fetch it. Run from `share/doc/ernest_httpd`, the installed launcher first refuses `access-log must stand in a directory that exists: "build/examples/site/access.log"`, which the README does say; and the installed `root/` has no `xterm/`, from which `shell.html` loads its three files, so with the directory made the shell page would still have no terminal. I did not serve it that far.
- Fix: `examples/README.md` says the example runs from a checkout or an unpacked archive, by `make run`, and not from the installed copy.

**K19. The example site has no icon.**
- Place: `examples/site/root/`.
- Wrong: every first visit asks `/favicon.ico` and gets 404, a line of the access log and an error in the browser's console, beside the lines the README's `curl` commands explain.
- Fix: a `favicon.ico` in the example's root, or a `<link rel="icon" href="data:,">` in its pages.

### Ernest's

**K20. `Http.reason` stops at RFC 9110.**
- Place: `share/doc/ernest/report/library.md` line 1349, "`Http.reason : (Int) -> String // RFC 9110's phrase; "" for a status it does not name`".
- Wrong: 431, the status a server answers at its header limit, is RFC 6585's, with 428, 429 and 511; so a server that uses it writes `HTTP/1.1 431 ` (K4). The page says so; the gap is the table.
- Shows it: in `ern shell`, `:load Http` and `List.map([413, 421, 426, 428, 429, 431, 451, 511], Http.reason)` answer `["Content Too Large", "Misdirected Request", "Upgrade Required", "", "", "", "", ""]`.
- Ask: the phrases of IANA's registry, RFC 6585's four and RFC 7725's 451 at least.

**K21. The installation does not say what 0.11 changed.**
- Place: `share/doc/ernest/CHANGES.md`, whose newest section is "## 0.10.0, 2026-11-10"; `share/doc/ernest/README.md`, titled "Ernest 0.11.0".
- Wrong: `ern --version` says `0.11.0+93a13b13`. `ern unpack`, which ernest-httpd's README builds on, is in the report and in no release note; `grep -n unpack CHANGES.md` finds nothing.
- Ask: the archive of 0.11.0 carries its section.

**K22. A path under the root directory is written without its slash.**
- Place: report §11, "A refusal names the path as resolved, as §11.5 writes a file".
- Wrong: from the working directory `/`, `ern run /tmp/nosuch-k.erc` says `ern run: tmp/nosuch-k.erc: no such file`; from `/usr` it says `/tmp/nosuch-k.erc`. `/` is systemd's default working directory, so a unit's refusals would all read as relative paths.
- Shows it: `cd / && ern run /tmp/nosuch-k.erc`.
- Ask: a path is written absolute where the working directory is the root.

**K23. Two lines at every orderly end that I did not understand until I read the deployment guide.**
- Quote: `2026-11-23T17:57:45.552Z the end waits for 1 subscriber: ErnestHttpd.main` and, a millisecond later, `the subscriber ErnestHttpd.main answered`.
- Wrong: a user of `make run` who ends it with `kill -TERM` reads "subscriber", a word of no page of ernest-httpd's. The guide says the first line is said "while it waits"; here the wait was a millisecond, and both lines came each time.
- Ask: the line is said only once a wait has lasted long enough to be worth a line.

**K24. A TLS failure is the host's source line.**
- Quote: `Io.Other("TLS client: In state wait_cert_cr at ssl_handshake.erl:2306 generated CLIENT ALERT: Fatal - Bad Certificate\n selfsigned_peer")`.
- Wrong: the cause, a self-signed certificate, is the last word after a line feed, behind a state and a file of OTP's. `deploy/README.md` quotes it with two ellipses, so the operator is told to expect it.
- Ask: an error of its own for a certificate that does not verify, with the host's reason in it.

### What held

The quick start as written: `make`, `make run`, the four pages, the shell page in Chromium (type `1 + 2`, reload joins the same session, a second tab takes it over, Stop, Restart, `:quit`). The warning came 120.0 s after the last key, Extend moved it, and the session expired 180.2 s after the Extend. Every `curl` line of `examples/README.md` answered what its comment says. Four at once and ten starts in an hour both refuse with `unavailable`; 32 connections from one address; head deadline 10.0 s with a 408; idle 60.0 s with no response; body 413; ranges and `Accept-Encoding` ignored.

Ctrl-C ends at once and leaves no program behind; `kill -TERM` ends in order, the page reads `disconnected`. 5000 requests on 20 connections, then the termination signal at once: 5000 lines in the access log. The log is begun anew after a rename. `make test` passed, 186 tests in 21.6 s, and without Chromium said so plainly. `ERN=` worked in each form the README gives. `make install`, the installed launcher, `--config-dir`, `ern reload`, `ern stop`, the attached shell, `make uninstall` and `make clean` did what the pages say. The key's and the certificate's refusals, the port below 1024, the port in use, `ern config`'s three refusals, `ern` without `erl`, and the attach's two refusals are each as `deploy/README.md` quotes them. The shell ran over TLS on `127.0.0.1` and on `::1`.

### What I could not run, and why

- **`make release`, and so everything from an archive**: refused, K1. Not run: the launcher from an unpacked release, `make install` and `make smoke` from one, and whether `deploy/` and the sources stand in it.
- **`make smoke HOST=ernest-lang.org`**: the deployed site is not to be touched. I ran `build/smoke.erc` against my own TLS site instead; its certificate is self-signed, so each TLS check failed at the certificate, in the words step 11 quotes. `make smoke` without `HOST` and the program's three refusals were run.
- **`deploy/README.md` steps 1 to 3**: root, `apt`, `useradd`, and a build of OTP. The machine has OTP 29.1.2 already, and step 3's `erl` line printed `29`.
- **Step 4 from archives**: no archive of either. Run instead: `make install PREFIX=S/prefix` from the checkout.
- **Step 5 as written**: no `sudo`, no `chown`. Run instead with two directories of my own.
- **Step 6**: run with paths under `S/srv`, addresses `127.0.0.1` and `::1` in place of `0.0.0.0` and `::`, and ports 18150 and 18151.
- **Step 7**: podman is not installed and there is no linger to set. `Containerfile`, `shell.sh` and `shell-start.sh` were read, and the two scripts pass `sh -n`; none was run. Whether the image's `make install` without a `make` before it builds Ernest's helper I could not tell: Ernest's README runs `make` first.
- **Step 8**: no root. `systemd-analyze verify` of the unit names the three programs that are not on this machine and nothing else.
- **Step 9**: certbot and root. `certbot-deploy.sh` passes `sh -n`.
- **Step 10**: `logrotate -d` run as myself on the file as shipped, K10.
- **An `ern` before 0.11**, for `ern: no job unpack`, and **another build of `ern`**, for `compiled by another build of ern`: there is one `ern` on the machine.
- **The clone from GitHub**: the commit under review is the clone I was given.

Every process I started is ended, by its number: the servers, the headless Chromium and my probes. The clone's `git status` is clean, and nothing was written outside `K` and `K-scratch` but this list.

## D, the documents reader


Read: `README.md`, `CHANGES.md`, `SECURITY.md`, `CLAUDE.md`, `assets/README.md`, `deploy/README.md`, `examples/README.md`, `docs/README.md`, `docs/design.md`, `docs/plan.md`, `docs/release.md`, `docs/agents.md`, `docs/full_review.md`, `docs/language_feedback.md`, against the program part of every module of `src/`, the Makefile, `bin/ernest_httpd`, `tools/docs.ern`'s head, `deploy/` and `examples/`. Not read: `docs/log.md`, `docs/proposals/`.

Run, in the clone `review/D` with `ern 0.11.0+93a13b13`: `make`; the launcher on a copy of the example's configuration on ports 18300 and 18301; every `curl` line of `examples/README.md`; the server as a node with an attached shell and `:processes`; `Smoke.main` against a port with nothing on it; `make install` and `make uninstall` under a scratch prefix; `ern test build/connection.erc`. `$S` below is `review/D-scratch`.

The design holds up well against the code: every signature, type and error text of §2 to §14 that I compared is as written, and so is every `curl` answer of `examples/README.md`. What follows is what does not hold.

### Defects: statements that are false or stale

**D1. `deploy/README.md` lines 9, 20, 49, 94, 137, 140, 164, 181, 193, 204: the steps name the archive of 0.1.0, which does not hold what they copy.**
"`httpd$ mkdir image && cp ernest_httpd-0.1.0/deploy/Containerfile ernest_httpd-0.1.0/deploy/shell-start.sh image/`"
The page describes this commit's `deploy/`, but names the released archive by a literal version in ten lines. The archive of tag `v0.1.0` has no `deploy/shell-start.sh`, so step 7's `cp` fails, and its `Containerfile`, unit and wrapper are the older ones. The version's owner is `VERSION`.
Shows it: `git ls-tree --name-only v0.1.0 deploy/` lists no `shell-start.sh`; `grep -c '0\.1\.0' deploy/README.md` says 10.
Fix: write `ernest_httpd-VERSION` as the page already writes `ern-VERSION`, with one sentence saying which release it stands for.

**D2. `docs/design.md` §4, line 94, the row `headers`: the list of headers "which the server writes itself" lacks two that §11 and §14 have it write.**
"`be none of Allow, Connection, Content-Length, Content-Type, Date, Last-Modified, Location, Sec-WebSocket-Accept, Set-Cookie, Transfer-Encoding and Upgrade`, compared in ASCII case, which the server writes itself"
§14 has the client's response carry `Cache-Control: no-store`, and §11 has a 426 carry `Sec-WebSocket-Version: 13`. Neither is in the rule, so a configuration may name them and the response carries the header twice with two values. `Config.written` in `src/config.ern` follows the design, and its comment names §5, §6, §9 and §11 but not §14.

Shows it: a configuration with `"headers": {"Cache-Control": "max-age=60", "Sec-WebSocket-Version": "8"}` starts; `curl -i http://localhost:18302/shell/client.js` answers both `Cache-Control: max-age=60` and `Cache-Control: no-store`, and `curl -i http://localhost:18302/shell/session` answers both `Sec-WebSocket-Version: 8` and `Sec-WebSocket-Version: 13`.
Fix: add `Cache-Control` and `Sec-WebSocket-Version` to the rule in §4, then to `written` and `writtenRule`; it changes an error's text, so it is the user's to decide.

**D3. `README.md` lines 8 and 45: the README says the deployed site has the shell, and the plan and the design say it has not yet.**
"On ernest-lang.org the program is `ern shell` in a container." and "To see the server at work, open ernest-lang.org and press Try it."
`docs/plan.md` line 9 has "Release 0.1.0 serves the one page of https://ernest-lang.org", the shell going live at item 5's switch; design §13 has `deploy/config.json` hold "no `shell`, until the site's page has one", and `deploy/config.json` has none. I did not open the deployed site, so this stands on the repository's own documents alone.
Shows it: `grep -c '"shell"' deploy/config.json` says 0.
Fix: hold the two sentences until the switch, or have item 5 name them as part of the switch.

**D4. `deploy/README.md` line 245: the list of a session's processes lacks its writer.**
"A visitor whose shell runs has a session, spawned in `Sessions`, its program, `Os.startTerminal`, and its reader, spawned in `Session`"
Design §2 and §12 give a session a reader and a writer, both spawned in `Session.serve` (lines 148 and 149). The operator who follows step 12 sees a process the page does not name.
Shows it: the server run with `--config-dir`, one shell attached over a WebSocket, then `printf ':processes\n:quit\n' | ern shell --config-dir $S/ops --attach node` lists `Session.serve:148 calling Os.startTerminal` and `Session.serve:149 receiving`.
Fix: "and its reader and its writer, spawned in `Session`".

**D5. `deploy/README.md` line 55: a release's `ern --version` has no `+`.**
"`ern --version` prints the version and, after its `+`, the commit Ernest's archive was made from."
Step 1 has the operator bring the archive the release was built with, and design §13 has `make release` refuse an `ern` whose version text "holds a `+`". The report's §11.7 gives `ern 0.4.0` for a release and the `+` and a commit only for an archive made off the release's tag. The transcript above it, `ern VERSION`, is right, and the sentence under it is not.
Shows it: `grep -n 'ern 0.4.0+1a2b3c4d' /home/jocke/opt/local/share/doc/ernest/report/toolchain.md`, and the Makefile's `release` target, `*-dev|*+*`.
Fix: "`ern --version` prints the version alone, the archive being a release's."

**D6. `docs/design.md` Glossary, line 432: the listener is not the process that accepts, and `acceptor` is the design's own word.**
"**listener**: a listening socket of the configuration and the process that accepts on it, §7. Not `acceptor`."
§2 and §7 have "an acceptor process of its own", which "alone calls `Tcp.accept`", and the code has `AcceptorMsg`, `AcceptorEnded` and `accepting`.
Shows it: `grep -o acceptor docs/design.md | wc -l` counts the word in §2, §7 and here; `grep -n AcceptorMsg docs/design.md` finds §7's type.
Fix: "the process that owns its connections, §7; its **acceptor** is the process that alone calls `Tcp.accept` on it", and drop "Not `acceptor`".

**D7. `docs/design.md` §6, line 175: "the two paragraphs above" no longer names the paragraphs it means.**
"The connection closes after a response of the two paragraphs above"
Above *The response* now stand *Reading*, the two paragraphs of *The request* and *The upgrade*. The two directly above are the served request and the upgrade, and a served request's response keeps the connection.
Shows it: `curl -sv -o /dev/null -o /dev/null http://localhost:18300/ http://localhost:18300/about.html` says "Re-using existing http: connection".
Fix: "The connection closes after a response of *Reading*, after a refusal of *The request* and after a refusal of *The upgrade*", each named.

**D8. `docs/design.md` §2, line 11: "every socket the program ends it so closes" is not true of the stop.**
"every socket the program ends it so closes, so that the caps count a connection until its close has answered"
The same paragraph allows a socket that "ends with the process that owns it", and §7's end ends each connection that waits for a request by `kill`, with no `Tcp.close`; `Listener.ending` does so.
Fix: "every socket a connection or a shell ends it so closes; at the stop a connection's socket ends with its process, §7".

**D9. `docs/design.md` line 3: `CLAUDE.md` has no section *Before code*.**
"this is corrected first, then the log, then the code (CLAUDE.md, *Before code*)"
The rule stands in *Who decides*, "The design changes first, then the log, then the code".
Shows it: `grep -c 'Before code' CLAUDE.md` says 0.
Fix: "(CLAUDE.md, *Who decides*)".

**D10. `docs/full_review.md` line 20 against `docs/agents.md` line 17: one says a reader writes its list to a file as the other says, and the other says an agent cannot. Both are the template's.**
"A reader hands its list back as text and writes it to a file under the review's session's scratchpad, as `agents.md` says of an agent." against "an agent cannot write a file of its report. The session keeps what it needs of it in a file under its scratchpad".
My own brief had me write the file, so the practice is `full_review.md`'s.
Fix, to the template: in `agents.md`, "an agent's report comes back as its answer, and a review's reader writes its list to a file as well".

**D11. `docs/plan.md` line 31: the step it points at is done and gone from the plan.**
"for its stop time, 130 seconds today and what *The floor's rise* leaves it"
Line 23 has the floor's rise done and "§13's 85 seconds, which stand", so nothing is left to leave: the unit's `TimeoutStopSec` is 130 and stays.
Shows it: `grep -n "floor's rise" docs/plan.md` finds only the done line and this one.
Fix: "for its stop time, 130 seconds".

**D12. `docs/language_feedback.md` line 23, in line 36 of the queue: the test it says fails passes.**
"and the test of a plain-text client of a TLS listener fails on it"
The test's client now reads the alert and closes first, so that the server's close answers; its comment in `src/connection.ern` line 1163 says so.
Shows it: `ern test build/connection.erc` says "serves a connection over TLS: passed".
Fix: "and the test of a plain-text client of a TLS listener has its client close first, so that the close answers".

**D13. `tools/docs.ern` lines 10 to 11 and 45 against `CLAUDE.md` *Writing*: two rules cite an owner that does not hold them. Both are the template's.**
"Every prose paragraph past 150 words ... (CLAUDE.md, *Writing*)" and "The project's history stays out of the code and of what a user reads (CLAUDE.md, *Writing*)"
*Writing* has three bullets: the design is tight, every other document is plain and short, American English. The 150 words, the history kept out, and a command's description after `#` are stated only in the tool's comment and in the README's line on `make test`, so `make test` refuses on rules no document owns.
Shows it: `grep -n '150\|history' CLAUDE.md` finds nothing.
Fix, to the template: give *Writing* the three rules, a bullet each, or have the tool's comment own them and cite nothing.

**D14. `docs/README.md` line 3: "What each document of this repository is" leaves two tracked documents out.**
`SECURITY.md` and `assets/README.md` are tracked Markdown and are not in the list.
Shows it: `git ls-files '*.md'` against the list.
Fix: a bullet for each.

### Clarity, and facts outside their owner

**D15. The shell's member stands whole in three places.** Design §13, *The shell's command* and *The shell's member* (lines 364 and 368), is the owner. `deploy/README.md` lines 118 to 131 repeat it as JSON, and lines 149 to 151 repeat the command a third time. They agree today. `src/client.ern` line 234 holds "the deployed one's numbers" a fourth time, in a test. Fix: `deploy/README.md` keeps the JSON, which the operator pastes, and says the design's values are those; or a test holds the README's block against the design.

**D16. The make targets and what each does stand in `README.md` lines 61 to 80 and in the Makefile's head, lines 6 to 37, and differ.** The README's block lacks `make examples`, `make lib`, `make doc`, `make format` and `make clean`, three of which its prose adds below. What `make test` refuses of the documents is listed a third time in `tools/docs.ern`'s head, and the README's list lacks the backticked paths. Fix: one owner, the Makefile's head, and the README's block points at it for what it leaves out.

**D17. What each document is stands in `CLAUDE.md` *Where a fact lives* and in `docs/README.md`, in different words.** The plan is "what is built next, and where we are", "where the program stands and what comes next", and in `docs/plan.md` line 3 itself "what remains to be built, in what order, and the milestones done". `CLAUDE.md`'s table already sends a reader to `docs/README.md` for "any other document". Fix: `docs/README.md` lists only what *Where a fact lives* does not, and points there for the rest.

**D18. A release's note is described in `docs/release.md` step 5, line 9, and again in `CHANGES.md` line 3, which cites it and then restates it, less one part.** `release.md` has "the design's diff between the last release's tag and this one's"; `CHANGES.md` does not. Fix: `CHANGES.md` keeps "Each release's note, newest first, written as `docs/release.md` says".

**D19. What `make uninstall` removes is stated four times.** Design §13 line 340, the owner; `README.md` lines 78 to 79; `deploy/README.md` line 57; and the Makefile twice, lines 34 and 277. They agree, and the run under a scratch prefix kept a `share/doc` that was not empty, as all four say. Fix: the README and the deployment's page say "removes what `make install` put there" and leave the rest to §13.

**D20. `docs/language_feedback.md` line 3 restates how a line is carried, which `CLAUDE.md` *The work* owns**, with more in it than the owner has: who reads the file, who writes it, and that the file goes when empty, which `docs/README.md` line 14 says again. And none of lines 35 to 37 carries "the program that shows it", which *The work* names as a part of a line: each describes its probe in prose. Fix: the header keeps the numbering and the dates and cites *The work*; each line names its probe's file or holds its lines.

**D21. `docs/plan.md` lines 15 to 23: five paragraphs of what is done, in a document whose first line gives it "what remains to be built, in what order, and the milestones done".** They are an index into the log by its titles, a third of the page, and `CLAUDE.md` has the plan hold "what is built next, and where we are". Fix: one line, "Done: items 1 to 4 and 6 to 11, and item 5's rehearsal; the log has each", or a row of the table when the milestone closes.

**D22. `docs/design.md` §6, line 175: "a 101 carries its own `Connection: Upgrade` and none of these" reads as though a 101 carried no `Date` and none of the configuration's headers.** It carries both. Shows it: the last `curl` of `examples/README.md` answers `Date`, `Content-Security-Policy` and `X-Content-Type-Options` before `Upgrade`. Fix: "and neither `Connection: close` nor `keep-alive`".

**D23. `docs/design.md` Glossary, line 430: `server` is given one meaning and used with two.** "**server**: what every connection of a listener shares, `Connection.Server`", while §1, §4, §13, §14 and the glossary's own *node* and *client* use "the server" for the program: "The server runs on one machine", "which the server writes itself", "the server run with a configuration directory". Fix: "**server**: the program as it runs; a listener's `Connection.Server` is what its connections share of it".

**D24. `README.md` lines 82, 84, 106 and 110 describe machinery this program does not have.** "it then builds each Erlang application `ERL_DEPS` names", "A repository with an `erl/` is cloned with `--recursive`", "`test/`, where it exists", "the examples where they exist", "`THIRD_PARTY_LICENSES`": `ERL_DEPS` is empty, `package.conf` names no package, and there is no `erl/`, no `test/`, no program under `examples/` and no `THIRD_PARTY_LICENSES`. A reader who clones looks for what is not there. Fix: say once that the program loads nothing beyond Ernest's own, and drop the rest.

**D25. `docs/design.md` §13, line 372: "as the rule `must not be empty`".** §4 and the glossary write a rule without its `must`, `not be empty`, and `Smoke.configured` holds it so; the line printed is `redirect-hosts must not be empty: []`. Fix: "as the rule `not be empty`".

**D26. `deploy/README.md` line 102: "stay under 256 MiB while that file is at most 0.32 MiB".** 160 connections times five times 0.32 MiB is 256 MiB, not under it. The 0.32 stands again in `docs/plan.md` line 35; it follows from §13's rule and the two caps, and no document owns it. Fix: "stay within 256 MiB", and the plan says "the size §13's rule allows the caps".

**D27. The OTP release stands in `deploy/README.md` lines 31 and 32, `OTP-29.1.2`, and in `deploy/Containerfile` line 12, `erlang:29.1.2.0-slim`**, tied by the README's "the one the shell's image runs". The test that holds `deploy/` (`Smoke.holdsTheDeployment`) holds neither. `README.md` line 59 likewise restates the floor, `ern 0.11.0`, whose owner is `package.conf`. Fix: the test holds the Containerfile's `FROM` against the README's URL, or the README names the Containerfile as the owner.

**D28. `deploy/README.md` line 116 does not say which file takes the member `shell`.** Step 6 installs the archive's `deploy/config.json`, and step 11's smoke test reads "`deploy/config.json`, the archive's own", so the two lines of the shell's checks come only where the member was written into the archive's file. Fix: "write the member into `ernest_httpd-VERSION/deploy/config.json`, and step 6 installs it again".

**D29. `docs/design.md` §12, lines 310 and 312, says one thing twice.** "the start then counted and the starts older than the window dropped", and two sentences on, "Each start counted drops every remote address's starts older than the window." Fix: keep the second.

**D30. `docs/design.md` §13, line 338, counts `assets/` among "the user's documents", and the Makefile's line 78 says of it "whose pictures the documents show".** No document shows them: `assets/README.md` says they are the repository's icon and its social preview on GitHub. They are installed under `share/doc/ernest_httpd/assets/`. Shows it: `grep -rn 'assets/' README.md deploy/README.md examples/README.md docs/design.md` finds only §13's own line. Fix: leave `assets/` out of `DOCS` and of §13, or have the README show the icon.

**D31. The rehearsal's unit, its directory `/home/httpd/rehearsal/` and its port 8443 are stated only in `docs/plan.md` lines 9 and 31**, while design §13 line 342 has "Everything the server's but the prefix stands under `/home/httpd/ernest-httpd`". The plan has them go at the switch, so it is a narrow gap; the design is not true of the machine until then. Fix: none before the switch, if the user agrees; else one sentence in the plan saying §13 describes the machine after it.

**D32. `docs/agents.md` line 13 and `docs/full_review.md` line 15 both state what a reader keeps of `CLAUDE.md`, and count differently**: "the one rule of it a reader keeps is to leave untracked files alone" against "to leave untracked files alone, and to read Ernest's `guide/style.md` before it writes Ernest". Both are the template's. Fix: `agents.md` cites `full_review.md` and states neither.

**D33. `deploy/README.md` line 9 has the release's section of `CHANGES.md` name Ernest's archive, and the section names `ern 0.9`**, a minor and not an archive's version. Fix: the next section names the version whole, `ern 0.11.0`.

### Of Ernest's, not the program's

**D34. The installation's `share/doc/ernest/CHANGES.md` has no section for 0.11.** `ern --version` says `ern 0.11.0+93a13b13`, and the newest section of the installed file is "0.10.0, 2026-11-10". A program moving its floor to 0.11 cannot read what the release changed, and the README's "an `ern` before 0.11 stops `make` at its first step, `ern: no job unpack`" cannot be checked from the installation: the word `unpack` is nowhere in the file. Shows it: `grep -n '^## \|unpack' /home/jocke/opt/local/share/doc/ernest/CHANGES.md`. It may be that the section is written only at the release; then an archive made before it could say so in the file.

Nothing else. Every line of the toolchain's that the documents quote and that I could bring about came as quoted: `ern config: <dir> exists`, `a peer is named "node" already`, `no such directory`, `the peer node connected`, `ern shell: the peer node is unreachable`, `ern: erl, of Erlang/OTP 29, is not on the path`, the fault of a 16-bit segment overflow, and the node's lines with their time where standard error is a pipe, as the guide's section 1.4 says.

### What I could not check, and why

- **The deployed site and its machine**, which the brief keeps me from: D3, the plan's *Where we are* (the rehearsal at port 8443, the build of `75faac8`), and every step of `deploy/README.md` that needs root, systemd, podman, certbot or logrotate, with the messages those steps quote. Steps 5 and 12 I ran with scratch directories and no `sudo`; they hold but for D4.
- **`README.md` line 59, `ern: no job unpack`**: no `ern` before 0.11 is installed, and see D34.
- **`make release`**: this `ern` is a `+` build, which the target refuses, after `make test` and `make doc`. I read the target and did not run it. `compiled by another build of ern` I checked against the report only.
- **`make test` whole**: I ran `ern test build/connection.erc` alone, for D12, and took the session's fresh clone for the rest.
- **`make run` and `make xterm`**: ports 8080 and 8081 were another session's, and `make xterm` fetches from the network. I ran the launcher on a copy of the example's configuration with the ports changed, which is all `make run` adds to `make`.
- **A browser**: that a `Secure` cookie is kept from `localhost` over plain HTTP, and that `connect-src 'self'` admits the WebSocket, in `examples/README.md` lines 9 and 23.
- **The log's titles the plan cites**: the log is not mine to read.
- **Ctrl-C at a terminal**: I sent the signal instead, `kill -INT`, and the server ended at once with status 130; `kill -TERM` ended it with 143.

Every process I started has ended, each by its process number or by its own exit: the servers, the WebSocket clients and the attached shells. Nothing listens on 18300 to 18399. The clone's `git status --short` is empty.
