# The shell client

Milestone 2, item 11 of the plan: the server owns both ends of its socket. Ernest's site knows the server today in three places, the messages its script speaks, the configuration its generator reads and the stub socket its browser test speaks; a client the server ships makes the server their one owner (principle 2).

## What is asked

- **A client.** A script the server serves on the site's host at a path the configuration names, `/shell/client.js` for the site. It holds no element of a page and no terminal; it opens the socket and speaks the messages. It offers a session by what it means, a start with a size, keys, a resize, an extension and a stop, and tells the output, the session attached and whether this browser joined it, the warning, and each end by its name: expired, taken over, unavailable, stopped, or lost, which is every other close. A stop asked for before the session is attached is the client's to order.
- **The limits.** The client answers the limits the server enforces, without a session: the lifetime without a key, the warning before the end, the most sessions at once, and the starts an address may make and their window.
- **Never stale.** A page loaded whole runs the client of the server it talks to, never one a browser kept from the server before.
- **Its own test.** The client against a server the test starts itself, on the machine it runs on, in this repository.

## The decisions

Each is argued and then decided, weighed against the five principles. A decision not yet taken says so.

### 1. How the client is served and kept current

Decided 2026-11-10, read by Ernest's design session against its proposal under MVP 4.6, which recommended the module's form.

Where the client's text lives decides the rest. A file the operator installs and the configuration names by path puts the client's version in the operator's hands: a server upgraded with the file left behind serves the old client, and the client's standing is a fact in two places again (principle 2 against). A file the installation carries beside the compiled modules keeps one owner, but the launcher must pass its path and the program find and read it at start, parts added for the same result (principle 5 against).

So the text lives inside the program, a raw string in a module `Client`, served from memory: the client is part of the server as its handshake is, nothing to install, nothing to find, the version the server's by construction. Its one cost is that the client holds no backtick, so no template literal, a rule the module states. The script is a few kilobytes, held once.

The client is an ES module with named exports and nothing on `window`, which a page loads on demand by a dynamic `import()`, as Ernest's site does from its one script: one fetch for each session started, where a script element in every page would cost one for each page load of the site under `no-store` (principle 5); and an import answers the interface as a value and its failure as a rejected promise, where a classic script loaded on demand takes a created element, an agreed global name and an onload for the same (principle 3). The example site's page and the client's test import it the same way.

The path is a field of the configuration's `shell`, `shell.client`, a string, required, rule `begin with /` and `not be shell.path`, since §6 decides the shell's path first and a client at the same path would never be served, which the configuration refuses instead of deviating silently. The client is served after the host decides, as the shell's path is: a redirect host and the redirect listener answer 301 as for any target, and the canonical host alone serves it. `GET` answers 200 with `Content-Type: text/javascript; charset=utf-8`, which a module import requires, `Content-Length`, `Cache-Control: no-store` and the body; `HEAD` the same without the body; another method 405 with `Allow: GET, HEAD`, as §5 answers one. No `Last-Modified`, since the text has no date of its own, and no 304.

Kept current by `no-store` on that response alone: a browser keeps no copy, so a page loaded whole fetches the client from the server it talks to. The alternative, `no-cache` with a validator, needs a tag the server computes and a conditional request it reads, both of which §1 leaves out, to save one small fetch for each session (principle 5 decides). §1's list then leaves out `Cache-Control` but for the client's. A page restored from the back-forward cache, or one the site's navigation keeps, is not loaded whole; a reload mends it, and Ernest's proposal says the same. Where the configuration has no `shell` there is no client.

### 2. Where the limits are answered

Decided 2026-11-10, read by Ernest's design session against its proposal.

A second path answering JSON is a second address the site names and the operator configures, a second response shape and a second fetch, for five numbers that change only with the configuration, read once at the program's start (principle 5 against, and a second fact of the server's standing in the site, principle 2). A message over the socket before the first resize, which §11 could answer without attaching, costs a socket and a cookie for a page that may start no session, and changes the messages, which stay as Ernest's site speaks them until the switch (principle 1 against).

So the limits are a named export of the module. The served module begins with one line the server writes from the configuration, `export const limits = ` and the JSON of the five, then the client's text as written. A page that imports the module has the limits as a value, with no session and no second fetch, and they are the limits of the server that served it, since `no-store` fetches the module from that server and the configuration cannot change under a running program. The module's text as written stands alone, a valid module that uses `limits` nowhere, so nothing is substituted inside it.

The value is `{"lifetime", "warning", "mostAtOnce", "starts": {"count", "within"}}`, the configuration's fields under `Config.Shell`'s names, in the configuration's units, milliseconds and counts, so that one unit stands for a duration from the file to the page, and the operator reads one word in the file and in the interface. Ernest's shell page imports the client at its load and writes its five numbers from the value; every other page of its site imports it at the first session, and one document, which its navigation keeps, fetches it once. The body is written at each request from `Config.Shell`, five numbers encoded and a concatenation, which no measurement would have the program hold ready instead.

The warning the client tells is in milliseconds too, one unit through the interface, where the wire says seconds; the interface's draft states it.

### 3. How the test runs the client

Decided 2026-11-10, read by Ernest's design session, which added the page's reports of its own failures and the wait's form from its own browser test.

The client runs in a browser, and only a browser on this machine has a WebSocket and a module loader, so the test runs the client where a visitor runs it. A JavaScript runtime of its own stands nowhere here and would run the client where no visitor does (principle 1 against). Headless Chromium with `--dump-dom` dumps the document at the load event and its virtual time leaps past the socket, experiment 1. Headless Chromium driven over the DevTools protocol, as Ernest's browser test drives it from Erlang, would have the test speak a protocol over a WebSocket client, read the endpoint from the browser's standard error and attach to a target, a library's work taken on for one test (principle 5 against).

So the page reports to the test. The case, a `Test.Case` of the module `Client`, writes a page of its own into a root under `build/`, launches the server on a configuration naming that root and the client, as the end-to-end tests launch it, listens on a port of its own, and starts Chromium headless on the page. The page imports the client, drives it through one scenario, and reports each thing the client told it as one line, an awaited `fetch` to the test's port, so that the lines come in order; it reports the window's error and unhandled-rejection events and the failure of its own import the same way, so that an absence of lines means only a browser that hangs or dies.

The test reads each request line with the program's own request reader, answers 204, compares the lines with those it expects, and ends the browser. The case's configuration has no `Content-Security-Policy`, since the deployment's `connect-src 'self'` would refuse the page's fetch to the listener's origin and leave the test with no lines; §14's test shape says so, so that the deployment's headers are not copied into it. The one wait that is a time: the test waits on its own socket or the browser's end, with a deadline for the rest, and its failure names the lines received so far. Experiment 2 shows the way, and it uses only what the program and the library have: `Tcp.listen`, `Http.readRequest`, `Os.start` and `kill`.

The origin must stand in the configuration before the server is launched on port 0, so the page is loaded as `http://client.test/`, which Chromium's `--host-resolver-rules` carries to the server's port, experiment 3; the configuration's canonical host and the shell's origin are then fixed words. The browser is `chromium`, by that name on `PATH`, with `--headless=new` and its profile under the test's directory in `build/`, `--user-data-dir`, without which a browser joins the user's own running profile; Debian's Chromium was never seen to need another flag, by Ernest's 127 runs and experiment 4, and none is taken that a probe does not show. A machine without it fails the case with a line naming the package, since a test that cannot run says so rather than passing green; the README's *Building* names it.

The scenario runs the shell's command as `sh`, not `ern shell`: the test is the client's, a resize is then observable, `stty size` answering the rows and columns, and `sh` starts at once (principle 5). It walks every word of the interface: the limits as configured, a start attached new, keys and their output, a resize, the warning at a short lifetime, an extension moving it, the expiry, a stop, a second start in the same document taken over and attached joined, a third start refused unavailable under a starts cap of two, a stop ordered before the attach, and the server ended under a session, lost. A shell behind the socket stays the smoke test's check, §13.

### 4. The section of the design that states the interface

Decided 2026-11-10, read by Ernest's design session, whose site note will cite the section by its address and nothing else of the design.

A paragraph of §11, the shell, would put the page's end of the socket under the server's process, and a page's author and Ernest's site note would cite a section whose rest is the server's reader, its messages and its close, none of it the page's (principle 3 against: one address for one thing). A section placed before the deployment, as §13 with the deployment moved to §14, reads in the order of the program, but every citation of §13 changes, in the Makefile, the operator's steps, the plan, the code's comments and the log's entries, which cite the section as it stood (principle 5 against).

So the interface is a section of its own after the deployment, **§14, The client**, before the glossary, which owns everything of the client's: the module's text and its head, the response, the interface, and the test's shape, so that Ernest's note cites one address. §4 takes the field's rows, §6 the sentence that routes the path, §1 the exception to `Cache-Control`, §3 the module's row, and the glossary **client**.

## The interface

Agreed with Ernest's design session on 2026-11-10, which read it against its ask's four lines and its page as it stands; its stub speaks the same values. In the register §14 states it in. The module is served at `shell.client`; its head is two lines the server writes, the shell's path, not exported, and `limits`; the rest is the client's text as written, strict by its nature, with no backtick.

```
export const limits // { lifetime, warning, mostAtOnce, starts: { count, within } }, the configuration's shell, milliseconds and counts
export function start(rows, columns, told) // a session of the size, told as below; answers the Session
Session.keys(bytes) // a Uint8Array to the program
Session.resize(rows, columns)
Session.extend()
Session.stop()
told.output(bytes) // a Uint8Array the program wrote
told.attached(joined) // the session is attached; true where this browser joined a live session
told.warning(left) // the milliseconds before the end, unless a key or an extension moves it
told.ended(reason) // "expired", "takenOver", "unavailable", "stopped" or "lost", once, last
```

**The session.** `start` opens the socket to the shell's path on the module's own origin, `import.meta.url`, `wss:` for `https:` and `ws:` otherwise, and sends the size at the open; it answers the session at once. What the session is asked before the socket is open is sent at the open, after the size, in its order, so that a stop asked before the attach is ordered after it; the server holds what comes after the size until the session is attached, §11.

A row or column count outside 1 to 65535 faults the call with a `RangeError`, and a `told` whose four are not each a function faults it with a `TypeError`, since each is the page's defect and a fault where it stands shows it there, where a session ended lost would hide it behind the page's gentlest word (principle 1). After `ended` a session takes nothing more, and asks nothing of the page.

The reasons are camelCase values the page compares, one convention with `mostAtOnce`; how a page words a state is the page's. Keys and output are bytes alone, the page encoding its terminal's strings, one way.

**What is told.** `attached` once, before any `output`, from the server's word, `joined` true for `"joined"`; `output` for each binary message, in order; `warning` for each warning, its seconds made milliseconds; `ended` once, at the socket's close, from the close code: 4001 `"expired"`, 4002 `"takenOver"`, 4003 `"unavailable"`, 4004 `"stopped"`, and any other code, a socket that does not open or that fails among them, `"lost"`. The client reads no other message and keeps no state of the page's.

## Experiments

Run on 2026-11-10 on this machine, Chromium 156 from Debian 13, against the server built from `594f1bb` on `ern 0.10.0`, serving a page of the probe's own from a configuration whose shell runs `ern shell`. The machine has Chromium, Google Chrome and Firefox, and no JavaScript runtime outside a browser.

1. **`--dump-dom` sees no socket.** A page that opens the shell's socket, sends a resize, and writes each event into the document was dumped at the load event, before the socket opened, with `--headless=new --dump-dom`; with `--virtual-time-budget=6000` a 1500 ms timer had fired and the socket still had not opened, in 0.4 s of real time, and `--timeout=6000` changed nothing. The access log shows the upgrade, 101, each time: the browser opened the socket and the dump did not wait for it. So a test cannot read what the page found from the dumped document.
2. **A page reports to a listener of the test's own.** The same page, with each event sent as `fetch("http://127.0.0.1:8092/" + encodeURIComponent(line), { mode: "no-cors" })` and awaited, against a Python listener answering 204 and closing: the listener read the request lines `/open`, the attach's text, `/close 4004 after 5 binaries` and `/done`, in order, with Chromium run headless and no dump. A cross-origin GET with no header of its own is sent without a preflight, and an awaited fetch orders the lines.
3. **A host-resolver rule fixes the origin before the port is known.** `--host-resolver-rules="MAP client.test 127.0.0.1:8090"` and the URL `http://client.test/t.html` reached the server, which answered 421 for the host `client.test`, the probe's configuration serving `localhost`. So a test's configuration can name the origin `http://client.test` and the canonical host `client.test` before the server is launched on port 0.
4. **The sandbox.** Chromium ran headless with `--user-data-dir` and without `--no-sandbox`, exit 0.

## Seams

Read from both sides on 2026-11-10, each owner with what it takes when the design takes the proposal. Nothing stands twice: §14 owns the client, and each other owner points at it.

- **Design §1.** The program serves the site, the shell and the shell's client, §14; its list of what it leaves out says `Cache-Control` but for the client's.
- **§3.** The row `Client`, its file under `src/` named as the others are: the client, the module served at `shell.client` with the limits at its head, §14.
- **§4.** `Config.Shell` takes `client : String`; the table takes `shell.client`, a string, `begin with /` and `not be shell.path`, after `shell.path`'s row, so that it is checked in that place.
- **§6.** The routing sentence: by the shell, §11, at `shell.path`; by the client, §14, at `shell.client`; else by `Static.serve`. The configuration's `headers` stand on the client's response as on every other, §6's rule as it is; a `Cache-Control` the operator configures stands beside the client's, and `no-store` among a response's directives is kept by every cache.
- **§11 and §12.** Unchanged: the wire stays as Ernest's site speaks it until the switch, and the plan's rule that a change is told to Ernest's session first stands.
- **§13.** The shell's member takes `client` `/shell/client.js`, and so do `deploy/config.json` and `deploy/README.md`'s step 7; the CSP's `default-src 'self'` admits the module's import as it admits a script. The smoke test takes one check where the configuration has a `shell`: its `client` answers 200 as `text/javascript`, so that the rehearsal walks the client's path. `Smoke`'s sentence that it exports the checks' client is reworded, since **client** becomes the glossary's.
- **§14.** New, as decision 4 says: the response, the module's head, the interface, and the test's shape, the browser named and the configuration without a `Content-Security-Policy`. It states nothing of when Ernest's pages import the client, decision 2's argument, which is a fact of Ernest's site, owned by its design note.
- **The glossary.** **client**: the module the server serves at `shell.client`, which a page imports to run a session, §14. Not `script`. The entry under **connection** that refuses `client` stands.
- **`README.md`.** *Building* names `chromium` as what `make test` needs beside `ern`; the first sentence names the client beside the socket.
- **`examples/`.** `examples/site/config.json` takes `client`; `shell.js` imports the client and keeps the terminal, the buttons and the status line, so the example shows the client's use; `examples/README.md` says so.
- **`docs/README.md`.** Takes a line for `proposals/`, the first proposal of this repository, as `CLAUDE.md` describes a proposal's directory.
- **The plan.** Item 11's steps as they stand: the design takes this, Ernest's session is told where the interface stands, then the build, then the rehearsal walks the switch with the client, item 5. The build adds and takes nothing away from the wire.
- **The log.** One entry, *The shell client's design*, arguing the four decisions by the principles named here.
- **`language_feedback.md`.** None: raw strings, `Json.encode` and `Os.start` hold what the client and its test need.
- **Ernest's side**, by its session: its proposal's two sentences, "with its seconds" to milliseconds and "loads from" to imports; its stub written to this interface; its site note citing §14. Nothing of it waits on anything further from here.
