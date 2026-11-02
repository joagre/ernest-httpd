# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it, `// design §n: ...`, and every `design §n` in a module's comment names a section; `make test` holds both.

## 1. What the program does

ernest-httpd serves one site, ernest-lang.org: its static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell in a container on the server. It implements what that needs of HTTP/1.1 and WebSocket, and nothing more. It is configured by one file, §4, runs as §2 says, answers a request for a file as §5 says and serves it over HTTP/1.1 as §6 to §8 say; what else it implements of HTTP/1.1 and WebSocket, and what it leaves out, is `docs/proposals/basic/proposal.md`'s until the item that builds it states it here.

## 2. Processes

The program's processes, each with what it owns; a process is spawned by the one that holds its address. A socket is called by one process at a time, and is closed by the process that holds it once no call on it is under way, or ends with the process that owns it, since a call on a socket another process has closed faults (report Appendix E.18).

**The entry process** runs `ErnestHttpd.main`. It takes one argument, the configuration's path, and refuses another count with the line `usage: ernest_httpd config.json` on standard error and the status 2. It reads the configuration within 5000 milliseconds, `Config.read`, §4, and refuses it with the path, `: ` and `Config.reason` on standard error and the status 1; a configuration with a listener of a kind other than `plain` is refused so, the first such by its index, as `listeners[i].kind is plain`.

It then makes the site, §5, starts the access log, §8, and for each listener of the configuration, in its order, listens, `Tcp.listen`, prints a line of `listening on `, the address, `:` and the port it got, `Tcp.port`, on standard output, and spawns the listener process, §7, monitored. A listen or a port that fails is said on standard error with the address, `:`, the port, `: ` and the error as `Io.show` writes it, and ends the program with the status 1. It then subscribes to the program's end, `Os.termination`, and waits.

**The end.** Told of the program's end, the entry process tells each listener process to stop, `Listener.Stop`, waits for each to end, has the access log write what it holds, `AccessLog.Flush`, and answers the end's reply. A listener process that ends before the end was told is a failure of the program: the entry process stops the others and has the log write what it holds, as at the end, and then faults with `a listener ended: ` and the reason as `Io.show` writes it, which ends the program with a status that is not 0.

**A listener** is one process for each listener of the configuration, §7, with an acceptor process of its own; the listener owns the count of its connections and closes the listening socket at the end, the entry process opened and owns the socket, and the acceptor alone calls `Tcp.accept` on it. **A connection** is one process for each socket a listener accepted, §6, which owns the socket. **The access log** is one process, §8, which owns the lines waiting to be written.

```
type ErnestHttpd.MainMsg = Terminated(Reply(Unit)) | ListenerEnded(Down)
```

## 3. Modules

Each module has one job, which its doc block states.

| Module | File | Owns |
|---|---|---|
| `ErnestHttpd` | `src/ernest_httpd.ern` | the entry point: the program's start and its end, §2 |
| `Config` | `src/config.ern` | the configuration: the file read into the record of §4, and every rule of §4 checked |
| `Static` | `src/static.ern` | a request for a file to its response, §5 |
| `Connection` | `src/connection.ern` | a socket's life: each request read, checked, served and answered, and its line told to the log, §6 |
| `Listener` | `src/listener.ern` | the connections of one listening socket: accepted within the caps, each in a process of its own, and closed in order at the end, §7 |
| `AccessLog` | `src/access_log.ern` | the access log: each response a line of Common Log Format, appended by the file's path in batches, §8 |

## 4. The configuration

The configuration is one JSON file, RFC 8259, read through `Json` at the program's start into the record `Config`, and read no more while the program runs: a change of the file is a restart. `Config.read(path, ms)` reads the file and answers the record, or the first rule the file breaks; `Config.parse(text)` reads the text alone and checks no rule of the file system's.

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
  mostAtOnce : Int, starts : Starts, lifetime : Int, warning : Int, messageLimit : Int)
type Starts = Starts(count : Int, within : Int) // within in milliseconds
type Error = Unreadable(Io.Error) | NotJson(Json.Error) | Invalid(field : String, rule : String)
Config.read : (Path, Int) -> Either(Error, Config) // the file read within the milliseconds, each rule checked
Config.parse : (String) -> Either(Error, Config) // the text read, every rule but the file system's checked
Config.reason : (Error) -> String // the error in prose, the field first for an Invalid
```

**The file.** The file is one object whose members are the fields of the table, each required but `shell`, and no other; a text whose value is no object breaks `is an object`, its field named `the configuration`. A field that is absent breaks the rule `is required`, and a member of no field breaks the rule `is no field of` and the object's name: `the configuration` at the top, `a plain listener` for a listener with its kind named, and otherwise the object's field, `timeouts`. A field whose value is not what the table says breaks the rule naming it, `is a string`, `is an integer`, `is an array` or `is an object`; an array's elements are so held one by one, indexed from 0, `redirect-hosts[1]`.

A string of the file, a member's name among them, breaks `holds no control character` where it holds one, U+0000 to U+001F or U+007F. `headers` is read into `List(Http.Header)` in the order of the names' code points, and `content-types` into a `Map` from each extension to its type.

| Field | Value | Rule |
|---|---|---|
| `listeners` | an array of objects | `is not empty` |
| `listeners[i].kind` | a string | `is one of plain, tls and redirect` |
| `listeners[i].address` | a string | `is not empty` |
| `listeners[i].port` | an integer | `is 0 to 65535` |
| `listeners[i].certificate`, `listeners[i].key` | strings, paths, with `"tls"` alone | `names a regular file`; the key also `is readable by the program's user alone`: its user is the program's and its mode has none of the bits `0o077` |
| `listeners[i].acme-challenge` | a string, a path, with `"redirect"` alone | `names a directory` |
| `root` | a string, a path | `names a directory` |
| `canonical-host` | a string | `is not empty` |
| `redirect-hosts` | an array of strings | each `is not empty` |
| `timeouts.head`, `timeouts.idle`, `timeouts.write`, `timeouts.file` | integers, milliseconds: a request's head, an idle connection, a write, and a read or an append of the file system | each `is above 0` |
| `limits.request-line`, `limits.headers` | integers, bytes | each `is above 0` |
| `limits.connections`, `limits.connections-per-address` | integers, counts | each `is above 0` |
| `content-types` | an object of strings | each name `begins with a dot`, `.wasm`; each value `is not empty` |
| `headers` | an object of strings | each name `is a token`, RFC 9110's: letters, digits and ``!#$%&'*+-.^_`|~``, and `is none of Content-Length, Date, Connection and Transfer-Encoding`, compared in any case, which the server writes itself |
| `access-log` | a string, a path | `stands in a directory that exists` |
| `shell` | an object, or absent where no WebSocket is served | |
| `shell.path` | a string | `begins with /` |
| `shell.origins` | an array of strings | each `is not empty` |
| `shell.command` | an array of strings | `is not empty`; the first is the program |
| `shell.most-at-once` | an integer, a count | `is above 0` |
| `shell.starts.count`, `shell.starts.within` | integers, a count and milliseconds | each `is above 0` |
| `shell.lifetime`, `shell.warning`, `shell.message-limit` | integers, milliseconds, milliseconds and bytes | each `is above 0`, and the warning `is below the lifetime` |

A field that breaks a rule is answered as `Invalid`, its `field` the field's name from the file's top, `listeners[0].port`, and its `rule` the rule's text as the table writes it. An object's members of no field are answered before its fields, the first by its name's code points, a listener's after its kind; then the fields are checked in the table's order, a row's rules in the order it writes them, an array's elements in theirs and an object of strings' members by their names' code points, each name before its value, each string's control characters before its rule, and the first rule broken is answered. `read` checks the rules of the file system's after every other, in the table's order.

**The errors.** `read` answers `Unreadable(error)` where the file cannot be read, `Io.NotUtf8` among them, and `NotJson(error)` where its text is not one JSON value. `reason(error)` writes `Unreadable` as `cannot read the file: ` and the error as `Io.show` writes it, `NotJson` as `is not JSON: ` and the error so written, and `Invalid` as the field, a space, and the rule: `listeners[0].port is 0 to 65535`.

## 5. The static site

`Static.serve(site, request, ms)` answers the response and its body for a request, whatever its method and target; the site is `Static.site(root, contentTypes)`. The response is of HTTP/1.1 and carries the headers this section names and no other: `Date` and the configuration's `headers` are added by the connection that writes it. `ms` bounds each read of the file system.

```
type Site = Site(root : Path, contentTypes : Map(String, String))
Static.site : (Path, Map(String, String)) -> Site // the root, and the built-in table extended by the map, which wins for a shared extension
Static.contentTypes : Map(String, String) // the built-in table
Static.serve : (Site, Http.Request, Int) -> #(Http.Response, Bytes) // the response and its body
Static.error : (Site, Int, Int) -> #(Http.Response, Bytes) // the response of the status, its body the error's
Static.withoutBody : (#(Http.Response, Bytes)) -> #(Http.Response, Bytes) // a HEAD's response of a GET's
```

**The method.** `GET` and `HEAD` are served; any other method answers 405 with `Allow: GET, HEAD`. A `HEAD` request's response is the `GET`'s with its body dropped and, but for a 304, `Content-Length` the body's size, as `withoutBody` makes it.

**The path.** The target is read by code point, as `Path` reads a path, in origin form, the path up to the first `?`, or in absolute form, a scheme, RFC 3986's, a letter and then letters, digits, `+`, `-` and `.`, then `://`, an authority up to the next `/` or `?`, and the path up to the first `?`, `/` where the path is empty; the query is ignored. A target of another form answers 400. The path is percent-decoded: `%` and two hexadecimal digits are the byte they write, and `%2F`, in either case, answers 400, as does a `%` not followed by two hexadecimal digits, and bytes that are not UTF-8. A decoded path holding a control character, U+0000 to U+001F or U+007F, answers 400.

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

`Connection.serve(socket, server, listener)` is a connection's life, run in the process that owns the socket: it reads one request at a time, in the order they come, answers each before it reads the next, tells the listener at `listener` what §7 needs, and returns when the connection closes. `server` is what every connection shares. The connection first asks for its remote address, `Tcp.remote`'s host, and closes the connection without a response, and without a line, where the host cannot tell it.

```
type Server = Server(config : Config.Config, site : Static.Site, log : Address(AccessLog.LogMsg))
type Told = RequestRead(Process) | ResponseWritten(Process) // what a connection tells its listener, §7
Connection.serve : (Address(Tcp.SocketMsg), Server, Address(Told)) -> Unit
```

**Reading.** Where no bytes were carried past the last head, the connection waits for the next request's first bytes within the idle deadline, `timeouts.idle`, and closes the connection without a response, and without a line, where none come, the client closes or the read fails. It then reads the head, `Http.readRequest` with the bytes carried and the limits `limits.request-line` and `limits.headers`, within the head deadline, `timeouts.head`. A head that does not end in time answers 408; a `Malformed` head 400, `LineTooLong` 414 and `HeadersTooLarge` 431; a client that closes before the head ends, or a read that fails otherwise, ends the connection without a response and without a line. Each response of this paragraph closes the connection.

**The request.** In this order: a version other than 1.0 and 1.1 answers 505; a 1.1 request without `Host`, and a request with two `Host` headers, answers 400; a request with `Transfer-Encoding` answers 413; one with `Content-Length` whose values are not one decimal number, each value digits alone and every value the same number, answers 400, above 0 answers 413, and 0 has no body. Each of these closes the connection, its body dropped for a `HEAD` as `Static.withoutBody` drops it, §5. Any other request is served by `Static.serve`, each read of the file system within `timeouts.file`.

**The response.** Every response carries `Date`, the time it is written as RFC 9110's date, then the configuration's `headers`, then its own, and `Connection: close` where the connection closes after it, or `Connection: keep-alive` where a 1.0 request's connection is kept. It is written with `Http.render` within the write deadline, `timeouts.write`; a write that fails or does not end in time closes the connection, and is told neither to the log nor to the listener. The connection closes after a response of the two paragraphs above, after a 1.1 request whose `Connection` headers list `close`, and after a 1.0 request whose `Connection` headers do not list `keep-alive`, the headers' values parted at commas, trimmed and compared in any case; otherwise it reads the next request with the bytes after the head carried.

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

An accepted socket whose remote address, `Tcp.remote`'s host, has `limits.connections-per-address` connections open, or whose remote address the host cannot tell, is closed at once, without a response; any other is given to a connection process spawned and monitored for it, which runs `Connection.serve` with the listener's address adapted to `Told`. An accept that fails is said on standard error as a line of `cannot accept: ` and the error as `Io.show` writes it, and the listener asks again after an idle deadline, by an alarm, `Retry`. An acceptor that ends before the stop ends the listener, which closes the socket and returns.

**The end.** Told to stop, `Stop`, the listener ends the acceptor, `Process.kill`, waits for its `AcceptorEnded`, and closes the socket, `Tcp.closeListener`; a socket the acceptor accepted and had not yet given ends with the acceptor, and one it gave that the listener had not yet placed is closed at once. It then ends the process of each connection that is not serving a request, by what it was told, `Process.kill`, ends each that tells `ResponseWritten` after, and returns once every connection has ended.

## 8. The access log

`AccessLog.start(path, ms)` starts the access log's process and answers its address; the process appends each entry it is sent to the file at `path` as a line of Common Log Format, and holds no file open.

```
type LogMsg = Entry(remote : String, time : Int, request : Optional(String), status : Int, size : Int)
  | Flush(Reply(Unit))
AccessLog.start : (Path, Int) -> Address(LogMsg) // the process, appending within the milliseconds
AccessLog.line : (LogMsg) -> Optional(String) // an Entry's line, without its line feed; None for a Flush
```

**The line.** `remote - - [time] "request" status size` and a line feed: the time in UTC over `Time.civil`, `02/Nov/2026:13:55:36 +0000`, the day and the month's three letters in English; the request as the client wrote it with `"` written `\"`, `\` written `\\`, and each byte outside U+0020 to U+007E as `\x` and two upper-case hexadecimal digits, so that no request forges a line, and `-` where there was none; the size in bytes.

**Batches.** The process takes every entry in its mailbox and appends their lines in one `Fs.append`, by the path, within `ms`, so that a rotated file is opened anew by its name at the next append; an append that fails is said on standard error with the path, `: ` and the error as `Io.show` writes it, and its lines are lost. A `Flush` is answered once every entry sent before it is written, or lost.

## Glossary

The names that recur across modules, one for each concept, in every module. A name the report states takes the report's; the names of the glossary of Ernest's `guide/style.md` hold here too.

- **configuration**: the record `Config.Config`, read once from the file, §4. Not `settings`, `options`.
- **field**: a member of the configuration's file, named from the file's top, `limits.headers`, `listeners[0].port`, §4. Not `key`, `entry`.
- **rule**: what a field's value must be, written as the table of §4 writes it, which an `Invalid` carries. Not `check`, `constraint`.
- **site**: the root and the content types a request for a file is served from, `Static.Site`, §5.
- **root**: the directory the site's files stand under, §5. Not `docroot`, `base`.
- **target**: a request's target as the client wrote it, `Http.Request`'s; its **path** is the target's path, decoded and split into **segments**, §5.
- **response**: an `Http.Response` with its body beside it, `#(Http.Response, Bytes)`, as `Static.serve` answers it and `Http.render` takes it, §5. Not `reply`, which is the prelude's.
- **table**: the content types by extension, the built-in table extended by the configuration's, §5. Not `mimeTypes`.
- **server**: what every connection shares, `Connection.Server`: the configuration, the site and the access log's address, §6.
- **connection**: a socket a listener accepted and the process that serves it, §6, §7. Not `client`, `handler`.
- **listener**: a listening socket of the configuration and the process that accepts on it, §7. Not `acceptor`.
- **deadline**: a time of the configuration's a wait is bounded by, the idle, head, write and file deadlines, `timeouts`, §4, §6. Not `timeout`, which is the library's `Io.Timeout`.
- **remote address**: the host of a connection's far end, `Tcp.remote`'s, by which connections are capped and logged, §7, §8. Not `peer`, which is the report's.
- **entry**: what a connection tells the access log of one response, `AccessLog.Entry`, written as a line, §8.
