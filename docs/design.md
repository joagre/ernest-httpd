# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it, `// design §n: ...`, and every `design §n` in a module's comment names a section; `make test` holds both.

## 1. What the program does

ernest-httpd serves one site, ernest-lang.org: its static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell in a container on the server. It implements what that needs of HTTP/1.1 and WebSocket, and nothing more. It is configured by one file, §4, runs as §2 says, and serves the site, §5 to §9, and the shell, §10 to §12; §13 is its deployment. It leaves out of HTTP/1.1 a request's body, chunked responses, ranges, `ETag`, `Cache-Control`, content negotiation, compression, trailers and every version but 1.0 and 1.1, §6; and of WebSocket its extensions and its subprotocols, §10.

## 2. Processes

The program's processes, each with what it owns; a process is spawned by the one that holds its address. A socket is read by one process and written by one, the same process or, a shell's, its reader and the shell, and is closed by the process that holds it once no call on it is under way, or ends with the process that owns it, since a call on a socket another process has closed faults (report Appendix E.18).

**The entry process** runs `ErnestHttpd.main`. It takes one argument, the configuration's path, and refuses another count with the line `usage: ernest_httpd config.json` on standard error and the status 2. It reads the configuration within 5000 milliseconds, `Config.read`, §4, and refuses it with the path, `: ` and `Config.reason` on standard error and the status 1.

It then makes the site, §5, starts the access log, §8, and the sessions where the configuration has a `shell`, §12, and for each listener of the configuration, in its order, listens, `Tcp.listen` for a `plain` or a `redirect` listener and `Tcp.listenTls` with its certificate and its key for a `tls` one, prints a line of `listening on `, the address, `:` and the port it got, `Tcp.port`, on standard output, and spawns the listener process, §7, monitored, with the server its connections share, §6: the configuration, the site, the access log's address, the sessions where there are any and, for a `redirect` listener, its challenge site, §9.

A listen or a port that fails is said on standard error with the address, `:`, the port, `: ` and the error as `Io.show` writes it, `Io.Denied` on a port below 1024 followed by `: a port below 1024 needs CAP_NET_BIND_SERVICE`, and ends the program with the status 1. It then subscribes to the program's end, `Os.termination`, and waits.

**The end.** Told of the program's end, the entry process stops the sessions where it started them, `Sessions.Stop`, which closes every attached shell with 1001 and ends every session, and waits for its reply; then tells each listener process to stop, `Listener.Stop`, which closes every shell left with 1001, waits for each to end, has the access log write what it holds, `AccessLog.Flush`, and answers the end's reply. A listener process that ends before the end was told is a failure of the program: the entry process stops the others and has the log write what it holds, as at the end, and then says `a listener ended: ` and the reason as `Io.show` writes it on standard error and ends the program with the status 1.

**A listener** is one process for each listener of the configuration, §7, with an acceptor process of its own; the listener owns the count of its connections and closes the listening socket at the end, the entry process opened and owns the socket, and the acceptor alone calls `Tcp.accept` on it. **A connection** is one process for each socket a listener accepted, §6, which owns the socket. **The access log** is one process, §8, which owns the lines waiting to be written.

**The sessions** are one process, §12, where the configuration has a `shell`, which owns the sessions by their cookies, their count and the visitors' starts. **A session** is one process for each cookie whose program runs, §12, spawned by the sessions, which owns the program under its terminal, `Os.startTerminal`, its deadline and the shell attached to it, and reads the terminal through a reader process of its own, which alone calls `Os.read`, and writes the keys to it through a writer process of its own, which alone calls `Os.write`. **A shell** is a connection's process after an upgrade, §11, which owns the socket and writes it, and reads it through a reader process of its own, which alone calls `Tcp.read`. A reader is ended, `kill`, before what it reads is closed.

```
type ErnestHttpd.MainMsg = Terminated(Reply(Unit)) | ListenerEnded(Down)
```

## 3. Modules

Each module has one job, which its doc block states.

| Module | File | Owns |
|---|---|---|
| `ErnestHttpd` | `src/ernest_httpd.ern` | the entry point: the program's start and its end, §2 |
| `Config` | `src/config.ern` | the configuration: the file read into the record of §4, and every rule of §4 checked; and a host's port dropped, `Config.withoutPort`, by which §4 and §9 compare hosts |
| `Static` | `src/static.ern` | a request for a file to its response, §5 |
| `Connection` | `src/connection.ern` | a socket's life: each request read, checked, served and answered, and its line told to the log, §6 |
| `Hosts` | `src/hosts.ern` | a request's host and what it decides before the site: the canonical host served, a redirect host and the redirect listener answered 301, a host that is neither 421, and the ACME challenge served, §9 |
| `Listener` | `src/listener.ern` | the connections of one listening socket: accepted within the caps, each in a process of its own, and closed in order at the end, §7 |
| `AccessLog` | `src/access_log.ern` | the access log: each response a line of Common Log Format, appended by the file's path in batches, §8 |
| `WebSocket` | `src/web_socket.ern` | RFC 6455's frames and its accept value: messages decoded from bytes and encoded to frames, knowing no socket, §10 |
| `Shell` | `src/shell.ern` | a shell's life: the upgrade's handshake, and after the 101 the socket read through its reader, the session attached at the page's first resize, and the terminal's bytes and the messages carried both ways, §11 |
| `Sessions` | `src/sessions.ern` | the sessions by cookie: a shell's attach passed to its session or a session started within the caps, and every session ended at the stop, §12 |
| `Session` | `src/session.ern` | one session: its program under a terminal, read through its reader while a shell is attached, its deadline, and its end with a close code, §12 |
| `Smoke` | `src/smoke.ern` | the smoke test: the checks run against a deployed site, the shell's where its configuration has a `shell`, each said on standard output, and run by the end-to-end test against the example site, and the client the checks and the end-to-end tests run with, §13 |

## 4. The configuration

The configuration is one JSON file, RFC 8259, read through `Json` at the program's start into the record `Config`, and read no more while the program runs: a change of the file is a restart. `Config.read(path, ms)` reads the file and answers the record, or the first rule the file breaks; `Config.parse(text)` reads the text alone and checks no rule of the file system's. A relative path the file names, the root's, a listener's or the log's, names a file under the program's working directory, as Appendix E.14 reads one.

```
type Config = Config(listeners : List(Listener), root : Path, canonicalHost : String,
  redirectHosts : List(String), timeouts : Timeouts, limits : Limits,
  contentTypes : Map(String, String), headers : List(Http.Header), accessLog : Path,
  shell : Optional(Shell))
type Listener = Listener(kind : Kind, address : String, port : Int)
type Kind = Plain | Tls(certificate : Path, key : Path) | Redirect(acmeChallenge : Path)
type Timeouts = Timeouts(head : Int, idle : Int, write : Int, file : Int) // milliseconds
type Limits = Limits(requestLine : Int, headers : Int, connections : Int,
  connectionsPerAddress : Int) // bytes, bytes, counts
type Shell = Shell(path : String, origins : List(String), command : List(String),
  mostAtOnce : Int, starts : Starts, lifetime : Int, warning : Int, messageLimit : Int, hangup : Int)
type Starts = Starts(count : Int, within : Int) // within in milliseconds
type Error = Unreadable(Io.Error) | NotJson(Json.Error) | Invalid(field : String, rule : String, value : Optional(String))
Config.read : (Path, Int) -> Either(Error, Config) // the file read within the milliseconds, each rule checked
Config.parse : (String) -> Either(Error, Config) // the text read, every rule but the file system's checked
Config.reason : (Error) -> String // the error in prose, the field first for an Invalid
Config.withoutPort : (String) -> String // the host with its port dropped, as §9 drops it
```

**The file.** The file is one object whose members are the fields of the table, each required but `shell`, and no other; a text whose value is no object breaks `be an object`, its field named `the configuration`. A field that is absent breaks the rule `is required`, and a member of no field breaks the rule `is no field of` and the object's name: `the configuration` at the top, `a plain listener` for a listener with its kind named, and otherwise the object's field, `timeouts`. A field whose value is not what the table says breaks the rule naming it, `be a string`, `be an integer`, `be an array` or `be an object`; an array's elements are so held one by one, indexed from 0, `redirect-hosts[1]`.

A string of the file, a member's name among them, breaks `hold no control character` where it holds one, U+0000 to U+001F or U+007F. `headers` is read into `List(Http.Header)` in the order of the names' code points, and `content-types` into a `Map` from each extension to its type.

| Field | Value | Rule |
|---|---|---|
| `listeners` | an array of objects | `not be empty` |
| `listeners[i].kind` | a string | `be one of plain, tls and redirect` |
| `listeners[i].address` | a string | `not be empty` |
| `listeners[i].port` | an integer | `be 0 to 65535` |
| `listeners[i].certificate`, `listeners[i].key` | strings, paths, with `"tls"` alone | `name a regular file`; the certificate also `be readable`, which `read` reads it whole to check; the key also `be readable by the program's user alone`: its user is the program's and its mode has the bit `0o400` and none of the bits `0o077` |
| `listeners[i].acme-challenge` | a string, a path, with `"redirect"` alone | `name a directory` |
| `root` | a string, a path | `name a directory` |
| `canonical-host` | a string | `not be empty` |
| `redirect-hosts` | an array of strings | each `not be empty` and `not be the canonical host`, compared as §9 compares hosts |
| `timeouts.head`, `timeouts.idle`, `timeouts.write`, `timeouts.file` | integers, milliseconds: a request's head, an idle connection, a write, and a read or an append of the file system | each `be above 0` |
| `limits.request-line`, `limits.headers` | integers, bytes | each `be above 0` |
| `limits.connections`, `limits.connections-per-address` | integers, counts | each `be above 0` |
| `content-types` | an object of strings | each name `begin with a dot`, `.wasm`; each value `not be empty` |
| `headers` | an object of strings | each name `be a token`, RFC 9110's: letters, digits and ``!#$%&'*+-.^_`|~``, and `be none of Allow, Connection, Content-Length, Content-Type, Date, Last-Modified, Location, Sec-WebSocket-Accept, Set-Cookie, Transfer-Encoding and Upgrade`, compared in any case, which the server writes itself |
| `access-log` | a string, a path | `stand in a directory that exists` |
| `shell` | an object, or absent where no WebSocket is served | |
| `shell.path` | a string | `begin with /` |
| `shell.origins` | an array of strings | each `not be empty` |
| `shell.command` | an array of strings | `not be empty`; the first is the program |
| `shell.most-at-once` | an integer, a count | `be above 0` |
| `shell.starts.count`, `shell.starts.within` | integers, a count and milliseconds | each `be above 0` |
| `shell.lifetime`, `shell.warning`, `shell.message-limit` | integers, milliseconds, milliseconds and bytes | each `be above 0`, and the warning `be below the lifetime` |
| `shell.hangup` | an integer, milliseconds: what a program has to exit after its terminal is hung up | `be above 0` |

A field that breaks a rule is answered as `Invalid`, its `field` the field's name from the file's top, `listeners[0].port`, and its `rule` the rule's text as the table writes it. An object's members of no field are answered before its fields, the first by its name's code points, a listener's after its kind; then the fields are checked in the table's order, a row's rules in the order it writes them, an array's elements in theirs and an object of strings' members by their names' code points, each name before its value, each string's control characters before its rule, and the first rule broken is answered. `read` checks the rules of the file system's after every other, in the table's order.

**The errors.** `read` answers `Unreadable(error)` where the file cannot be read, `Io.NotUtf8` among them, and `NotJson(error)` where its text is not one JSON value. `reason(error)` writes `Unreadable` as `cannot read the file: ` and the error as `Io.show` writes it, and `NotJson` as `is not JSON: ` and the error so written.

An `Invalid`'s `value` is the value refused, a member's name where the rule is the name's, as `Json.format` writes it, without its last line feed and over the lines it lays a long array or object on, and U+007F, which it writes bare, as `\u007f`; it is `None` where the rule is `is required` or `is no field of`, which no value breaks. `reason` writes `Invalid` as the field, ` must `, the rule, `: ` and the value, `listeners[0].port must be 0 to 65535: 70000`, `root must name a directory: "/srv/site"`, and one with no value as the field, a space and the rule, `root is required`, `roots is no field of the configuration`.

## 5. The static site

`Static.serve(site, request, ms)` answers the response and its body for a request, whatever its method and target; the site is `Static.site(root, contentTypes)`. The response is of HTTP/1.1 and carries the headers this section names and no other: `Date` and the configuration's `headers` are added by the connection that writes it. `ms` bounds each read of the file system.

```
type Site = Site(root : Path, contentTypes : Map(String, String))
Static.site : (Path, Map(String, String)) -> Site // the root, and the built-in table extended by the map, which wins for a shared extension
Static.contentTypes : Map(String, String) // the built-in table
Static.serve : (Site, Http.Request, Int) -> #(Http.Response, Bytes) // the response and its body
Static.error : (Site, Int, Int) -> #(Http.Response, Bytes) // the response of the status, its body the error's
Static.withoutBody : (#(Http.Response, Bytes)) -> #(Http.Response, Bytes) // a HEAD's response of a GET's
Static.pathAndQuery : (String) -> Optional(String) // a target's path and query as written; None for a target of another form
Static.authority : (String) -> Optional(String) // the authority of a target in absolute form; None for a target of another form
```

**The method.** `GET` and `HEAD` are served; any other method answers 405 with `Allow: GET, HEAD`. A `HEAD` request's response is the `GET`'s with its body dropped and, but for a 304, `Content-Length` the body's size, as `withoutBody` makes it.

**The path.** The target is read by code point, as `Path` reads a path, in origin form, the path up to the first `?`, or in absolute form, a scheme, RFC 3986's, a letter and then letters, digits, `+`, `-` and `.`, then `://`, an authority up to the next `/` or `?`, and the path up to the first `?`, `/` where the path is empty; the query is ignored. A target of another form answers 400.

`pathAndQuery` answers the target from its path on, the query among it, an origin-form target whole, `/` standing for an absolute-form target's empty path, before its query, and `None` for a target of another form; `authority` answers an absolute-form target's authority, and `None` for a target of another form. The path is percent-decoded: `%` and two hexadecimal digits are the byte they write, and `%2F`, in either case, answers 400, as does a `%` not followed by two hexadecimal digits, and bytes that are not UTF-8. A decoded path holding a control character, U+0000 to U+001F or U+007F, answers 400.

The path is then split at `/` into segments: an empty segment and `.` are dropped; `..` answers 400, and otherwise a segment beginning with `.` answers 404. A path that ends in `/`, or has no segments, asks for a directory.

**The file.** The segments name a path under the root, links followed. One that leads nowhere, through a regular file or a loop of links among them, or whose name the host cannot take, `Io.Invalid`, answers 404. One that leads to a directory and did not ask for one answers 301 with no body and `Location` the target's path as written, without its query, its leading `/`s made one, with `/` appended. A directory asked for is served as its `index.html`, and answers 404 where that is no regular file. A regular file is served where the path did not ask for a directory; anything else answers 404.

**The response.** A file is served with the status 200, `Content-Type` from the site's table by the file's extension with its dot, `application/octet-stream` where the table has none, `Last-Modified` the file's modification time as RFC 9110's date, and the file's bytes as the body. Where the request carries `If-Modified-Since` that `Http.parseDate` reads, and the file was modified at or before that time, it answers 304 with no body and no header of this section's.

**The errors.** An error's body is plain text, `text/plain; charset=utf-8`: the status, its phrase and a line feed, `404 Not Found`. A 404 answers the root's `404.html` instead, as `text/html; charset=utf-8`, where that is a regular file. A file the file system refuses to describe or to read, or does not answer within `ms`, the root's `404.html` among them, answers 500, said on standard error as a line of the path, `: `, and the error as `Io.show` writes it.

**The table.** The built-in content types, by extension:

| Extension | Content type |
|---|---|
| `.html` | `text/html; charset=utf-8` |
| `.css` | `text/css; charset=utf-8` |
| `.js` | `text/javascript; charset=utf-8` |
| `.json` | `application/json` |
| `.svg` | `image/svg+xml` |
| `.png` | `image/png` |
| `.ico` | `image/x-icon` |
| `.woff2` | `font/woff2` |
| `.txt` | `text/plain; charset=utf-8` |
| `.xml` | `application/xml` |
| `.wasm` | `application/wasm` |

## 6. The connection

`Connection.serve(socket, server, listener)` is a connection's life, run in the process that owns the socket: it reads one request at a time, in the order they come, answers each before it reads the next, tells the listener at `listener` what §7 needs, and returns when the connection closes. `server` is what every connection of a listener shares. The connection first asks for its remote address, `Tcp.remote`'s host, and closes the connection without a response, and without a line, where the host cannot tell it. On a `tls` listener the first read runs the handshake, within the idle deadline, the first read's, as E.18 has it, and a handshake that fails ends the connection as a read that fails does.

```
type Server = Server(config : Config.Config, site : Static.Site, challenge : Optional(Static.Site),
  log : Address(AccessLog.LogMsg), sessions : Optional(Sessions.Sessions))
  // the challenge site on a redirect listener, §9, None on another; the sessions where the configuration has a shell, §12
type Told = RequestRead(Process) | ResponseWritten(Process) | Upgraded(Address(Shell.ShellMsg)) // what a connection tells its listener, §7
Connection.serve : (Address(Tcp.SocketMsg), Server, Address(Told)) -> Unit receiving Shell.ShellMsg // the shell's mailbox, §11, run in the connection's process
```

**Reading.** Where no bytes were carried past the last head, the connection waits for the next request's first bytes within the idle deadline, `timeouts.idle`, and closes the connection without a response, and without a line, where none come, the client closes or the read fails. It then reads the head, `Http.readRequest` with the bytes carried and the limits `limits.request-line` and `limits.headers`, within the head deadline, `timeouts.head`. A head that does not end in time answers 408; a `Malformed` head 400, `LineTooLong` 414 and `HeadersTooLarge` 431; a client that closes before the head ends, or a read that fails otherwise, ends the connection without a response and without a line. Each response of this paragraph closes the connection.

**The request.** In this order: a version other than 1.0 and 1.1 answers 505; a 1.1 request without `Host`, and a request with two `Host` headers, answers 400; a request with `Transfer-Encoding` answers 413; one with `Content-Length` whose values are not one decimal number, each value digits alone and every value the same number, answers 400, above 0 answers 413, and 0 has no body. Each of these closes the connection, its body dropped for a `HEAD` as `Static.withoutBody` drops it, §5. Any other request is answered as its host decides, `Hosts.decide`, §9, and where that is `Served`: by the shell, §11, where the server has sessions and the target's path as written, `Static.pathAndQuery` up to its first `?`, is `shell.path`; else by `Static.serve`, each read of the file system within `timeouts.file`.

**The upgrade.** A request of the shell's is answered as `Shell.handshake` says: a refusal with `Static.error` of its status and the refusal's headers added, closing the connection; the 101 written as any response, told to the log with the size 0 and to the listener as `Upgraded` with the shell's address, after which the connection runs `Shell.serve` with the bytes after the head and the cookie, and closes when it returns.

**The response.** Every response carries `Date`, the time it is written as RFC 9110's date, then the configuration's `headers`, then its own, and `Connection: close` where the connection closes after it, or `Connection: keep-alive` where a 1.0 request's connection is kept; a 101 carries its own `Connection: Upgrade` and none of these. It is written with `Http.renderResponse` within the write deadline, `timeouts.write`; a write that fails or does not end in time closes the connection, and is told neither to the log nor to the listener. The connection closes after a response of the two paragraphs above, after a 1.1 request whose `Connection` headers list `close`, and after a 1.0 request whose `Connection` headers do not list `keep-alive`, the headers' values parted at commas, trimmed and compared in any case; otherwise it reads the next request with the bytes after the head carried.

**The line.** Each response written is told to the access log, §8, as an entry: the remote address, the time of its `Date`, the request line as the client wrote it, its method, target and version, `HTTP/1.1`, parted by spaces, or none where no head was read, the status, and the size of the body written, 0 for a `HEAD` and a 304.

**The listener told.** The connection tells its listener `RequestRead` with its own process once a head is read, and `ResponseWritten` once the response is written and its entry told, so that the end ends a connection waiting for a request and not one serving it, §7.

## 7. The listener

`Listener.serve(socket, server)` is a listener's life, run in a process of its own: it accepts connections on the socket through an acceptor process it spawns and monitors, each connection served in a process of its own, within the caps, and once told to stop ends the acceptor, closes the socket, and returns when every connection has ended. The listener waits on its mailbox alone, never in a call that could hold a `Stop`.

```
type ListenerMsg = Accepted(Either(Io.Error, Address(Tcp.SocketMsg))) | AcceptorEnded(Down)
  | Told(Connection.Told) | ConnectionEnded(Down) | Retry(Int) | Stop
type AcceptorMsg = Accept
Listener.serve : (Address(Tcp.ListenerMsg), Connection.Server) -> Unit receiving ListenerMsg
```

**Accepting.** The acceptor accepts one connection each time the listener asks it, `Accept`: it calls `Tcp.accept` in rounds of the idle deadline, `timeouts.idle`, until a connection comes or the accept fails otherwise than by its time, gives the socket to the listener, `Tcp.give`, and tells it `Accepted` with the socket or the error. The listener asks for the first accept at its start and for the next once it has placed the one before, while fewer than `limits.connections` connections are open; at the cap it asks for none until one ends, the rest waiting in the host's backlog. What a connection that has ended told is dropped.

An accepted socket whose remote address, `Tcp.remote`'s host, has `limits.connections-per-address` connections open, or whose remote address the host cannot tell, is closed at once, without a response; any other is given to a connection process spawned and monitored for it, which runs `Connection.serve` with the listener's address adapted to `Told`. An accept that fails is said by the acceptor on standard error, as a line of `cannot accept: ` and the error as `Io.show` writes it; one answered `Closed`, the socket closed by another process, then ends the acceptor, which tells the listener nothing, and after any other the listener asks again after an idle deadline, by an alarm, `Retry`, the connection whose accept failed waiting in the host's backlog until a later accept takes it. An acceptor that ends before the stop ends the listener, which closes the socket and returns.

**The end.** Told to stop, `Stop`, the listener ends the acceptor, `kill`, waits for its `AcceptorEnded`, and closes the socket, `Tcp.closeListener`; a socket the acceptor accepted and had not yet given ends with the acceptor, and one it gave that the listener had not yet placed is closed at once. It then ends the process of each connection that is not serving a request, by what it was told, `kill`, tells each that told `Upgraded` to close with 1001, `Told(Session.Ended(1001))`, as a session tells its shell, ends each that tells `ResponseWritten` after, and returns once every connection has ended.

## 8. The access log

`AccessLog.start(path, ms)` starts the access log's process and answers its address; the process appends each entry it is sent to the file at `path` as a line of Common Log Format, and holds no file open.

```
type LogMsg = Entry(remote : String, time : Int, request : Optional(String), status : Int, size : Int)
  | Flush(Reply(Unit))
AccessLog.start : (Path, Int) -> Address(LogMsg) // the process, appending within the milliseconds
AccessLog.line : (LogMsg) -> Optional(String) // an Entry's line, without its line feed; None for a Flush
```

**The line.** `remote - - [time] "request" status size` and a line feed: the time in UTC over `Time.toCivil`, `02/Nov/2026:13:55:36 +0000`, the day and the month's three letters in English; the request as the client wrote it with `"` written `\"`, `\` written `\\`, and each byte outside U+0020 to U+007E as `\x` and two upper-case hexadecimal digits, so that no request forges a line, and `-` where there was none; the size in bytes.

**Batches.** The process takes every entry in its mailbox and appends their lines in one `Fs.append`, by the path, within `ms`, so that a rotated file is opened anew by its name at the next append; an append that fails is said on standard error with the path, `: ` and the error as `Io.show` writes it, and its lines are lost. A `Flush` is answered once every entry sent before it is written, or lost.

## 9. The hosts

`Hosts.decide(config, challenge, request, ms)` is what a request's host decides before the site serves it: `Served` where the site serves the request, or the response that answers it instead. `challenge` is the redirect listener's challenge site, `None` on a `plain` or a `tls` listener; `ms` bounds each read of the file system.

```
type Answer = Served | Answered(#(Http.Response, Bytes))
Hosts.host : (Http.Request) -> Optional(String) // the request's host, its port dropped; None where the request names none
Hosts.decide : (Config.Config, Optional(Static.Site), Http.Request, Int) -> Answer
```

**The host.** A request's host is the authority of a target in absolute form, `Static.authority`, and otherwise its first `Host` header's value; a request whose target is not in absolute form and that has no `Host` header names none. The port is dropped, `Config.withoutPort`: a `:` at the host's end, after its last `]` where it holds one, with the digits after it, none among them; any other tail stands. A host is compared with the configuration's `canonical-host` and `redirect-hosts`, their ports dropped the same, in any case.

**The answer.** In this order: a request whose host is neither the canonical host nor a redirect host answers 421, a request that names none being the canonical host's. On the redirect listener, a request whose target's path and query, `Static.pathAndQuery`, begins with `/.well-known/acme-challenge/` is served by `Static.serve` from the challenge site, the target from after `/.well-known/acme-challenge`, a 301 it answers being 404 instead, since a challenge is a file; every other request answers 301. On another listener, a redirect host's request answers 301, and the canonical host's is `Served`. The challenge site is `Static.site` of the directory `acme-challenge` names and its `.well-known/acme-challenge` below it, with the configuration's content types, so that the directory is what certbot's `--webroot-path` is given.

**The 301.** Its `Location` is `https://`, the canonical host as the configuration writes it, and the target's path and query as written; it has no body. A target of another form answers 400 instead, as §5 answers it. The 421 is `Static.error`'s. A `HEAD`'s response is the `GET`'s with its body dropped, as `Static.withoutBody` makes it; the connection is kept or closed after any response of this section as §6 has it for a served request.

## 10. The WebSocket

`WebSocket` is RFC 6455's framing and its handshake's accept value, written as a library of Ernest's is, E.0, over `Crypto.sha1`, `Base64.encode`, `String.fromUtf8` and the bit syntax, its doc examples the RFC's own vectors. It knows no socket: it takes bytes and answers messages, and takes a message and answers a frame.

```
type Message = Text(String) | Binary(Bytes) | Ping(Bytes) | Pong(Bytes) | Close(code : Optional(Int), reason : String)
type Role = FromClient | FromServer
type Error = ProtocolError | TooBig | NotUtf8
abstract type Decoder // the frames one role sends, with a frame or a message under way
WebSocket.accept : (String) -> String // Sec-WebSocket-Accept for a Sec-WebSocket-Key: the SHA-1 of the key and 258EAFA5-E914-47DA-95CA-C5AB0DC85B11, in base64
WebSocket.decoder : (Role, Int) -> Decoder // the role's frames, a message of at most the bytes
WebSocket.decode : (Decoder, Bytes) -> Either(Error, #(List(Message), Decoder)) // the messages the bytes complete, in order, and the decoder holding the rest
WebSocket.closeCode : (Error) -> Int // 1002 for ProtocolError, 1009 for TooBig, 1007 for NotUtf8
WebSocket.encode : (Message) -> Bytes // one frame, unmasked, as a server sends
WebSocket.encodeMasked : (Message, Bytes) -> Optional(Bytes) // one frame masked with the four-byte key, as a client sends; None for a key of another size
```

**Decoding.** A decoder of `FromClient` takes masked frames alone, and one of `FromServer` unmasked frames alone; a payload's length is read in each of the RFC's three forms. A `Text` or a `Binary` is its fragments joined, answered at its final frame; a `Ping`, a `Pong` and a `Close` are answered in their place, between two fragments among them. A `Close`'s code is its payload's first two bytes and its reason the rest, `None` and `""` where the payload is empty.

`decode` answers `ProtocolError` for a frame the RFC forbids: masked or unmasked for the wrong role, a reserved bit set, a reserved opcode, a control frame fragmented or with a payload past 125 bytes, a length not in its shortest form or with its top bit set, a continuation with no message under way, a `Text` or a `Binary` frame inside one, or a `Close` whose payload is one byte or whose code is not 1000 to 1003, 1007 to 1014 or 3000 to 4999; `TooBig` for a message whose fragments together pass the limit, at the fragment that passes it; and `NotUtf8` for a `Text`, or a `Close`'s reason, that is not UTF-8.

An error is answered at the bytes that show it, a header's before its payload comes, and the messages the same bytes completed before it go with it; a frame after a `Close` is decoded as any. A decoder that answered an error is not used again.

**Encoding.** `encode` writes one frame, its payload's length in the shortest of the three forms; a `Close` with no code carries no payload, and with a code the code and the reason. A message is written as given, a control message past 125 bytes among them, which a decoder refuses; a close code outside 0 to 65535 faults. `encodeMasked` writes the same frame masked with the key.

## 11. The shell

`Shell.handshake(shell, request)` answers whether a request on the shell's path is an upgrade the server takes: the 101 response with the connection's cookie, or the refusal. `Shell.serve(socket, carried, sessions, cookie, remote, timeouts)` is the shell's life after the 101, run in the process that owns the socket: the socket read through a reader process, the session attached at the page's first resize, and the terminal's bytes and the messages carried both ways until the connection closes; then it returns, the socket closed. `carried` is the bytes after the head, `remote` the remote address.

```
type Refusal = Refusal(status : Int, headers : List(Http.Header))
type Accepted = Accepted(response : Http.Response, cookie : String)
type ShellMsg = Received(WebSocket.Message) | Failed(WebSocket.Error) | Idle | Closed | ReaderEnded(Down)
  | Told(Session.Told) | SessionEnded(Down)
Shell.handshake : (Config.Shell, Http.Request) -> Either(Refusal, Accepted)
Shell.serve : (Address(Tcp.SocketMsg), Bytes, Sessions.Sessions, String, String, Config.Timeouts) -> Unit receiving ShellMsg
```

**The handshake.** In this order: a method other than `GET` is refused 405 with `Allow: GET`; a version other than 1.1, a request whose `Upgrade` values do not list `websocket` or whose `Connection` values do not list `Upgrade`, the values parted at commas, trimmed and compared in any case, or whose `Sec-WebSocket-Version` is not one header `13`, is refused 426 with `Upgrade: websocket` and `Sec-WebSocket-Version: 13`; a request whose `Origin` is not one header among `shell.origins` as written is refused 403; one without one `Sec-WebSocket-Key` whose value is 16 bytes in base64 is refused 400. The rest is accepted: the 101 carries `Upgrade: websocket`, `Connection: Upgrade`, `Sec-WebSocket-Accept`, `WebSocket.accept` of the key, and, where the request carried no cookie, `Set-Cookie` of `shell=`, the cookie, `; Path=`, `shell.path`, and `; Secure; HttpOnly; SameSite=Strict`.

**The cookie.** The request's cookie is the value of the first member `shell` of its `Cookie` headers, their pairs parted at `;` and trimmed, whose value is 32 lower-case hexadecimal digits; a request without one is given 16 bytes of `Crypto.randomBytes` in lower-case hexadecimal.

**The reader.** The shell spawns the reader, monitored, which reads the socket in rounds of the idle deadline, `Tcp.read` within `timeouts.idle`, `carried` first, decodes what it reads with `WebSocket.decoder(FromClient, shell.message-limit)`, and tells the shell each message, `Received`, a round that read nothing, `Idle`, an error, `Failed`, and the connection's close or a read that fails otherwise, `Closed`; it reads on after a message and after `Idle`, and returns after the other two. The shell waits on its mailbox alone and writes the socket itself, each frame `WebSocket.encode`, within the write deadline, `timeouts.write`; a write that fails or does not end in time closes the connection.

**The messages.** A `Text` is one JSON object, read through `Json`: `{"resize": [rows, columns]}`, integers from 1 to 65535, attaches the shell where no session is, `Sessions.Attach` with the cookie, the remote address, the size and the shell's address, §12, and otherwise tells its session `Resize`; `{"extend": true}` tells the session `Extend`, and `{"stop": true}` tells it `Stop`; a `Text` that is none of these closes with 1008. A `Binary` is keys, told to the session as `Keys`.

What is meant for the session while the attach is under way, a resize, keys, extend or stop, is held in order and sent once `Attached` comes; before the first resize, keys, extend and stop are dropped. A `Ping` is answered with a `Pong` of its payload, a `Pong` is dropped, and a `Close` is answered with a `Close` of its code and closes the connection. `Failed` answers a `Close` of `WebSocket.closeCode` and closes; `Closed` closes; `Idle` closes without a frame where no session is attached, and is otherwise dropped.

**The session's messages.** A message of `Session.Told`: `Attached` with the session's address and its attachment attaches the shell, which monitors the session and writes the `Text` `Json.format` writes of `{"attached": "new"}` for `New` or `{"attached": "joined"}` for `Joined`, before any `Output`; `Unavailable` closes with 4003; `Output` is written as a `Binary`, and the session told `Written` with the shell's address once it is on the socket; `Warning` as the `Text` `Json.format` writes of `{"warning": seconds}`; `Ended` with a code closes with the code; a session that ends otherwise, `SessionEnded`, closes with 1011.

**The close.** The shell closes with a code by writing a `Close` of the code and no reason, and closing; it closes by ending the reader, `kill`, waiting for `ReaderEnded`, closing the socket, `Tcp.close`, which sends what the socket holds, and telling its session `Detach` with its address where one is attached; then it returns.

## 12. The sessions

`Sessions.start(shell, timeouts)` starts the sessions' process and answers it with the shell's configuration as `Sessions`; the process holds the sessions by their cookies, their count and the starts by remote address. `Session.serve(shell, timeouts, size, sessions)` is one session's life, run in a process the sessions spawn, `sessions` the address its end's beginning is told to: its program started under a terminal of the size, read through a reader process while a shell is attached, its deadline kept, and its end with a close code, after which it returns.

```
type Sessions.Sessions = Sessions(shell : Config.Shell, address : Address(SessionsMsg))
type Sessions.SessionsMsg = Attach(cookie : String, remote : String, size : Terminal.Size, shell : Address(Session.Told))
  | SessionEnding(Session.Ending) | SessionEnded(Down) | Stop(Reply(Unit))
Sessions.start : (Config.Shell, Config.Timeouts) -> Sessions
type Session.Told = Attached(session : Address(SessionMsg), attachment : Attachment) | Unavailable | Output(Bytes) | Warning(Int) | Ended(Int) // what a shell is told, the seconds left in a Warning and a close code in an Ended
type Session.Attachment = New | Joined // whether the shell attached is the session's first
type Session.SessionMsg = Attach(Address(Told)) | Detach(Address(Told)) | ShellEnded(Down) | Keys(Bytes) | Written(Address(Told))
  | Resize(Terminal.Size) | Extend | Stop | End(Int) | Answered(Either(Io.Error, Os.Output)) | ReaderEnded(Down)
  | Wrote | WriterEnded(Down) | Alarm(Int)
type Session.ReaderMsg = Read
type Session.WriterMsg = Write(Bytes)
type Session.Ending = Ending(process : Process, reply : Reply(Unit)) // the call a session makes of the sessions as its end begins
Session.serve : (Config.Shell, Config.Timeouts, Terminal.Size, Address(Ending)) -> Unit receiving SessionMsg
```

**An attach.** `Attach` whose cookie names a live session is passed to it, `Session.Attach` with the shell's address. Otherwise a session is started for the cookie where fewer than `shell.most-at-once` live and the remote address has fewer than `shell.starts.count` starts within the last `shell.starts.within` milliseconds, the start then counted and the starts older than the window dropped; else the shell is told `Unavailable`.

A session is spawned, monitored, with `Session.serve` of the size, and told `Attach`; one whose end has begun, `SessionEnding`, is dropped by its cookie, its call then answered, and counted among the live until it ends, `SessionEnded`, so that an attach under its cookie starts a new session, which then counts in its place: a session whose end has begun counts no more against an attach under its cookie, nor after the session that attach starts, though the stop still waits for it, so that a restart, a `Stop` and an attach under one cookie, never meets the cap. Each start counted drops every remote address's starts older than the window. After `Stop` the sessions live on, telling each attach `Unavailable` and answering a second `Stop` at once.

**The stop.** `Stop` tells each session `End` with 1001, waits for each to end, and answers the reply.

**The program.** The session starts `shell.command` under a terminal of the size, `Os.startTerminal`, the first word the program and the rest its arguments, and spawns the reader and the writer, monitored. A start that fails is said on standard error as a line of `cannot start `, the program, `: ` and the error as `Io.show` writes it, and the session ends with 4003 at its attach.

The reader reads the terminal once for each `Read` the session sends, `Os.read` within `timeouts.idle`, and tells the session what it answered, `Answered`. The session sends `Read` when a shell attaches, and again once the attached shell has written every piece it was sent, a `Written` for each, or at once after an answer that gave the shell nothing, so that neither a detached session nor one whose page takes its output slowly reads further, its program waiting on its output as on a full terminal; a `Written` from a shell no longer attached is dropped; the output of a read answered while none was attached is held, one piece, and written to the next shell attached.

**The deadline.** The session keeps the time of the last key or `Extend`, its start at first, and one alarm at a time: set for the warning's time, `shell.lifetime - shell.warning` after that time, and once warned, for the end's time, `shell.lifetime` after it. An alarm that fires at the warning's time tells the attached shell `Warning` with the seconds left, `shell.warning / 1000`; one that fires at the end's time ends the session with 4001; one that fires before its time, the time having moved, is set again for the warning's time.

**The messages.** `Attach` tells a shell attached before `Ended` with 4002, attaches the new one, monitored, tells it `Attached` with `New` where no shell was attached to the session before and `Joined` otherwise, and writes it the output held; `Detach` from the attached shell, or its end, `ShellEnded`, detaches it.

`Keys` move the time, as `Extend` does, and are given to the writer, `Write`, which writes them to the program, `Os.write` within the write deadline, and tells the session `Wrote`; keys that come while a write is under way are held, joined, up to `shell.message-limit` bytes, and given at its `Wrote`, and a `Keys` that would pass that is dropped whole, as a terminal whose program reads nothing takes no more, so that the session's mailbox never waits on the program; a write that fails is dropped, its `Exited` being read. A write that does not end within the deadline is not undone (Appendix E.23), so the writer waits for it, writing nothing, an empty write within the deadline again until one answers, and only then tells `Wrote`, so that the program's input holds one write at most.

`Resize` resizes the terminal, `Os.resize`. `Answered` of `Stdout` is written to the attached shell as `Output`; of `Exited`, and `Stop`, end the session with 4004; of a `Left`, nothing, the next `Read` sent as above. `End` with a code ends it with the code; a reader or a writer that ends before the end, `ReaderEnded` or `WriterEnded`, ends it with 1011, without the hangup, the other helper ended and waited for and then the program killed; an `Attach` that reaches a session in its end is told `Ended` with the end's code.

**The end.** The session ends with a code: it calls the sessions `Ending`, within `shell.hangup`, which answer once they have dropped its cookie, so that every `Attach` they passed it stands in its mailbox, and tells the attached shell `Ended` with the code; it ends the writer, `kill`, and waits for `WriterEnded`; where the program has not exited it hangs the terminal up, `Os.closeInput`, and reads on through the reader until `Exited` comes or `shell.hangup` milliseconds pass; it then ends the reader, `kill`, waits for `ReaderEnded`, and kills the program, `kill`, where it has not exited; it tells each `Attach` that has reached it `Ended` with the code; then it returns.

## 13. The deployment

The server runs on one machine as a node under systemd, as its own user, `httpd`, and is installed under that user's prefix, `/home/httpd/opt/local`, where Ernest is installed the same way, from the release archive. The launcher runs `../lib/ernest_httpd/build/ernest_httpd.erc` where that stands beside it, installed, and `../build/ernest_httpd.erc` otherwise, from a checkout or an unpacked archive, with `lib/` of the same root on the load path, and finds `ern` on `PATH` or as `ERN` names it. `make` given an `ERN` that is a path stands that path's directory first on `PATH` for every target, so that what names `ern` by its name, `Smoke`'s test and the example's `shell.command`, runs the same one. `deploy/` holds the files below, each as it is installed, and `deploy/README.md` the operator's steps in their order, with what each says when it fails.

**The archive.** `make release` refuses a build of `ern` that is no release, whose version text ends in `-dev` or holds a `+` (report §11.7). It writes `build/ernest_httpd-VERSION.tar.gz`, which unpacks to `ernest_httpd-VERSION/`: the launcher, `src/`, the compiled modules under `build/`, `lib/`, the `Makefile`, `VERSION`, and the documents, `README.md`, `LICENSE`, `CHANGES.md`, `CLAUDE.md` and the files git tracks under `docs/`, `deploy/` and `examples/`, so that `make run` runs in it, fetching what git ignores by `make xterm`.

**The installation.** `make install PREFIX=`, from the archive or a checkout, puts the launcher in `PREFIX/bin/ernest_httpd`, the compiled modules and `lib/` under `PREFIX/lib/ernest_httpd/`, and the documents under `PREFIX/share/doc/ernest_httpd/`, each at its path in the archive, so that their links resolve there. `make uninstall PREFIX=` removes them, then `PREFIX/share/doc`, `PREFIX/share`, `PREFIX/lib` and `PREFIX/bin`, each where it is empty, whoever made it, and nothing else; `PREFIX` itself stays.

**The directory.** Everything the server's but the prefix stands under `/home/httpd/ernest-httpd`: `node/`, the configuration directory, made by `ern config --listen 127.0.0.1:` and a port, holding beside the node's files the server's `config.json`, the certificate as `fullchain.pem` and the key as `privkey.pem`, the key readable by `httpd` alone, as §4 requires; `site/`, the root; `acme/`, the redirect listener's challenge directory; and `log/`, the access log's. The node lists one peer, the operator's directory, made by `ern config` with no listen under the operator's own home, which lists the server with its address, `ern config --peer-dir` each in the other, both made by the superuser where the two users cannot read each other's and given to their users; the operator's shell is `ern shell --config-dir <dir> --attach node`, the server listed by its directory's name, and nothing else connects.

**The unit**, `deploy/ernest-httpd.service`, installed as `/etc/systemd/system/ernest-httpd.service`: `Type=exec`; `ExecStartPre=/usr/bin/podman system migrate`, which ends the pause process rootless podman keeps in the user's own scope, since that process holds the mount namespace of the instance that started it, whose private `/tmp` a container with a terminal needs and a restart has deleted; `ExecStart` the launcher with `--config-dir` and the configuration's path, both under `node/`; `Environment=PATH=` the prefix's `bin` first, so that the launcher finds `ern` and the shell's wrapper `podman`; `WorkingDirectory=/home/httpd`; `User=httpd`; `Restart=on-failure`; `TimeoutStopSec` above `timeouts.write` and `timeouts.file` of `config.json` and, where it has a `shell`, `shell.hangup` together, the sessions ending before the listeners; `KillMode=mixed`, so that the stop's signal reaches the server alone, which hangs up each session's program itself.

The unit also has `AmbientCapabilities=CAP_NET_BIND_SERVICE`, so that 80 and 443 are bound as no root, and without systemd `setcap cap_net_bind_service=+ep` on the BEAM binary `erl` runs, redone at each install of OTP; `ProtectSystem=strict`, `PrivateTmp=yes`, and `ReadWritePaths` naming `log/`, `node/` for `ernest.pid`, podman's storage under `/home/httpd/.local/share/containers` and `/run/user`, whose directory of the user's number a unit cannot name; no `NoNewPrivileges`, which breaks rootless podman's `newuidmap`, a comment saying so.

The server ends by the termination of §2, exit status 143, which systemd counts as a clean stop; `systemctl reload` runs `ern reload`, which reads the node's peers again and nothing of §4.

**The certificate.** One certificate names the canonical host and the redirect hosts, issued by certbot in webroot mode against `acme/`, the server serving the challenge, §9, after a first certificate the operator makes by hand so that the server listens on 443 at all. The deploy hook, `deploy/certbot-deploy.sh`, installed under `/etc/letsencrypt/renewal-hooks/deploy/`, copies the lineage's `fullchain.pem` and `privkey.pem` into `node/`, owned by `httpd`, the key's mode `0600`, and restarts the unit, and does nothing else.

**The log.** The access log is `log/access.log`; `deploy/logrotate`, installed under `/etc/logrotate.d/`, rotates it by rename, daily, as `httpd`, with no signal and no `postrotate`, §8 appending by the path, and compresses a file a rotation after its rename, so that an append that opened it as it was renamed is kept.

**The shell's image**, `deploy/Containerfile`, builds `ernest-shell`: from the Erlang image of the OTP release Ernest runs on, pinned to its full tag, with Ernest installed from its release archive, given to the build as `ern.tar.gz` beside the file and kept in no layer, `ern` on `PATH`, the standard library, Ernest's libraries and the installation's `share/doc/ernest`, its examples among it, and a user `shell` whose home is `/home/shell`; it holds nothing secret and no network. Its command is the shell's start, `deploy/shell-start.sh`, installed in the image as `/usr/local/bin/shell-start`.

**The shell's nodes.** The image carries two configuration directories under `/usr/local/share/ernest-shell/`, made at its build by `ern config` as `shell`: `a`, which only dials, and `foo`, listening on `127.0.0.1:8655`, each listing the other with `--peer-dir`, and each `ernest.conf` holding `"limits": {"processes": 65536, "ports": 4096}`, so that the two nodes fit the container's memory. Their keys are the image's, the same in every container, which grants nothing where the container has no network.

The start copies both into the home, since the container is read-only and a node writes `ernest.pid` in its directory; starts `foo` as a bare node, `ern run --config-dir foo`, reading its standard error until its line `listening on`, and on after it, the lines dropped; and then runs `ern shell --config-dir a` in its place, so that the container ends with the shell, and `foo` with the container, whose end ends every process in it, the start not ending it itself. A `foo` that ends before its line `listening on` is said on standard error as `foo did not start`, and the start exits with 1.

**The shell's wrapper**, `deploy/shell.sh`, installed as `/home/httpd/ernest-httpd/shell.sh`, runs a container that ends with its terminal, since `podman run` leaves running a container whose terminal hangs up. It runs `podman run --cidfile` with the arguments it is given, in the background with the terminal as its standard input, and waits; at `HUP`, at `TERM` and at podman's own end it removes the container by its id, `podman rm -f -t 0 --cidfile`, and the id's directory, and exits with podman's status, 129 at `HUP` and 143 at `TERM`. The id's file stands in a directory of its own under `/run/user/` and the user's number, which podman's namespaces share, where `/tmp` differs between them.

**The shell's command**, `shell.command`, is the wrapper's path followed by `-it --rm --network none --read-only --cap-drop=ALL --security-opt=no-new-privileges --memory 128m --pids-limit 128 --cpus 1 --mount type=tmpfs,destination=/home/shell,tmpfs-size=64m,U=true ernest-shell`, the scratch directory a tmpfs the memory cap counts, owned by the container's user, so that a program that writes without end ends its own session, and one of the machine's cores, so that a loop that never waits takes no more than one core from the server and the other visitors.

**The configuration**, `deploy/config.json`, installed as `node/config.json`: a `tls` listener on 443 and a `redirect` listener on 80 on each of `0.0.0.0` and `::`, since a listener takes its address's family alone (E.18), the two `tls` listeners naming one certificate and key; the hosts of §9; the headers `Strict-Transport-Security: max-age=31536000`, `X-Content-Type-Options: nosniff` and `Content-Security-Policy: default-src 'self'; style-src 'self' 'unsafe-inline'; connect-src 'self' wss://` and the canonical host; the log above; `limits.connections`, which §7 counts by listener, and `limits.connections-per-address` sized so that the two `tls` listeners' connections together times what one holds after the site's largest file, five times the file over TLS, stays under 256 MiB, and `timeouts.idle` 15000, so that an idle connection gives it back soon; and no `shell`, until the site's page has one. `Config.parse` reads it in a test, every rule but the file system's.

**The shell's member.** Where the site's page has a shell, the configuration takes the member `shell`: `path` `/shell/session`, `origins` `["https://ernest-lang.org"]`, the command above, `most-at-once` 6, sized to the machine's 1.9 GB of memory, `starts` 10 within 3600000, `lifetime` 300000, `warning` 60000, `message-limit` 65536 and `hangup` 5000.

**The smoke test**, `Smoke`, `make smoke HOST=` and the canonical host, `ern run` on the module's own `.erc`, `build/smoke.erc`, with the host and `deploy/config.json` as its arguments, since `--main` names a function of the file's own module alone: against the deployed site over TLS, verified against the host's bundle, `/etc/ssl/certs/ca-certificates.crt`, each check a line on standard output, the check's name and `ok`, or `failed: ` and what came; the program exits 0 where every check passed and 1 otherwise. `Smoke` exports the checks' client, and the server's start by its launcher on a configuration and its end by the termination signal, which the end-to-end tests run with.

`Smoke.main` takes the host and the configuration's path, and refuses another count of arguments with `usage: smoke host config.json` on standard error and the status 2. It reads the file's text within 5000 milliseconds and checks it with `Config.parse`, every rule but the file system's, whose files are the machine's; a file it cannot read, as `Unreadable`, or a text `Config.parse` refuses is said on standard error as `smoke: `, the path, `: ` and `Config.reason`, with the status 2, and so is one whose `redirect-hosts` is empty, as the rule `must not be empty`, since the checks need the first.

**The checks.** `/` over 443 answers 200; `/` over 80 answers 301 to `https://`, the canonical host and `/`; `/` with the first redirect host answers 301 the same; `Host: elsewhere` answers 421; and where the configuration has a `shell`, its `path` upgrades with the origin `https://` and the canonical host, a resize of 24 by 80 attaches a new session, `{"attached": "new"}`, `1 + 2` and a line feed typed as keys answer output holding `3 : Int`, its type dimmed as the shell writes it at a terminal, or plain where `NO_COLOR` is set, and a stop closes with 4004.

`Smoke.checks(scheme, host, port, redirectPort, redirectHost, shellPath, origin)` runs them against any site, `redirectHost` a `String`, the first of the configuration's `redirect-hosts`, `shellPath` an `Optional(String)`, the shell's check where it is `Some(path)`, at the path from the origin; `ErnestHttpd`'s end-to-end test runs them against the example site over plain HTTP at its shell's path, so that `make test` holds them. The operator's `:processes` at an attached shell is a step of `deploy/README.md`, not of the program.

## Glossary

The names that recur across modules, one for each concept, in every module. A name the report states takes the report's; the names of the glossary of Ernest's `guide/style.md` hold here too.

- **configuration**: the record `Config.Config`, read once from the file, §4. Not `settings`, `options`.
- **field**: a member of the configuration's file, named from the file's top, `limits.headers`, `listeners[0].port`, §4. Not `key`, `entry`.
- **rule**: what a field's value must be, written as the table of §4 writes it, which an `Invalid` carries. Not `check`, `constraint`.
- **site**: the root and the content types a request for a file is served from, `Static.Site`, §5.
- **root**: the directory the site's files stand under, §5. Not `docroot`, `base`.
- **target**: a request's target as the client wrote it, `Http.Request`'s; its **path** is the target's path, decoded and split into **segments**, §5.
- **response**: an `Http.Response` with its body beside it, `#(Http.Response, Bytes)`, as `Static.serve` answers it and `Http.renderResponse` takes it, §5. Not `reply`, which is the prelude's.
- **table**: the content types by extension, the built-in table extended by the configuration's, §5. Not `mimeTypes`.
- **server**: what every connection of a listener shares, `Connection.Server`: the configuration, the site, the redirect listener's challenge site, the access log's address and the sessions, §6.
- **connection**: a socket a listener accepted and the process that serves it, §6, §7. Not `client`, `handler`.
- **listener**: a listening socket of the configuration and the process that accepts on it, §7. Not `acceptor`.
- **deadline**: a time of the configuration's a wait is bounded by, the idle, head, write and file deadlines, `timeouts`, §4, §6. Not `timeout`, which is the library's `Io.Timeout`.
- **remote address**: the host of a connection's far end, `Tcp.remote`'s, by which connections are capped and logged, §7, §8. Not `peer`, which is the report's.
- **entry**: what a connection tells the access log of one response, `AccessLog.Entry`, written as a line, §8.
- **host**: a request's host, its `Host` header's value or an absolute-form target's authority, its port dropped, §9; the **canonical host** is the configuration's `canonical-host`, served, and a **redirect host** one of its `redirect-hosts`, answered 301. Not `domain`, `vhost`.
- **challenge**: the ACME challenge's files, served from the redirect listener's challenge site, `Static.Site` of its directory's `.well-known/acme-challenge`, §9. Not `webroot`.
- **message**: what one side of a WebSocket sends whole, `WebSocket.Message`, a text or a binary message, a ping, a pong or a close, decoded from its frames, §10. Not `frame`, which is the wire's.
- **shell**: a connection after its upgrade on the shell's path, `shell.path`, and its process, §11; `shell` is the configuration's object for it, §4. Not `terminal`, `socket`.
- **session**: the process that owns one visitor's program under a terminal, by the visitor's cookie, §12; **the sessions** is the process that holds them. Not `container`, which is the command's.
- **cookie**: the value of the `shell` cookie that names a visitor's session, 32 hexadecimal digits, §11. Not `token`, `id`.
- **program**: the command a session runs under its terminal, `shell.command`, §12. Not `child`, `container`.
- **reader**: a process that alone calls the read of a socket or a terminal and tells its owner what it read, §11, §12.
- **attached**: the shell a session writes its program's output to, one at a time, §12.
- **close code**: the code a shell closes with, RFC 6455's or the program's own, 4001 expired, 4002 taken over, 4003 unavailable and 4004 stopped, §11, §12.
- **node**: the server run with a configuration directory, so that the operator's shell attaches to it, §13. Not `instance`.
- **operator**: whoever runs the machine: makes the directories, installs the files of `deploy/` and attaches the shell, §13. Not `admin`.
- **image**: the container image the shell's command runs, `ernest-shell`, §13.
- **wrapper**: the shell's wrapper, `deploy/shell.sh`, the program of the shell's command, which runs the image and removes its container at the end, §13. Not `launcher`, which is the server's.
- **smoke test**: the checks `Smoke` runs against a deployed site, §13. Not `health check`.
- **check**: one of the smoke test's checks, `Smoke.Check`, its name and whether it passed, §13; a rule of §4 is no check.
