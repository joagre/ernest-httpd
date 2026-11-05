# Ernest module Smoke

The smoke test: the checks run against a deployed site, each said on
standard output as a line, and the program's status whether every one
passed (design §13).

`main` takes the site's canonical host and the path of its
configuration, `deploy/config.json` for the deployed site, and runs the
checks the configuration takes against the host over TLS on 443, the
far end's certificate verified against the host's bundle,
`/etc/ssl/certs/ca-certificates.crt`, and over plain HTTP on 80, the
shell's where the configuration has a `shell`, at its path, from the
origin `https://` and the host. It prints each check's line, the check's
name and `: ok`, or `: failed: ` and what came, and exits with the
status 0 where every check passed and 1 otherwise. It refuses another
count of arguments with `usage: smoke host config.json` on standard
error and the status 2, and a configuration it cannot read, whose text
`Config.parse` refuses, or that has no redirect host, with `smoke: `,
the path, `: ` and `Config.reason` on standard error and the status 2,
the last as `redirect-hosts must not be empty: []`; the rules of the
file system's are not checked, since the files they name are the
machine's.

`checks` runs the same checks against any site, over the scheme its port
takes, `https` or `http`: `/` answered 200; `/` on the redirect port,
and `/` for the redirect host it is given, the configuration's first,
each answered 301 to `https://`, the host and `/`; `/` for a host that
is neither, `elsewhere`, answered 421; and where it is given the shell's
path, the path upgraded from the origin, a resize of 24 rows by 80
columns attaching a new session, `{"attached": "new"}`, `1 + 2` and a
line feed typed as keys answering output that holds `3 : Int` within
5000 milliseconds, its type dimmed as the shell writes it at a terminal
or plain where `NO_COLOR` is set, and a stop closing with 4004. Each
check opens a connection of its own, so that one that fails says what
came and the next runs as any.

The checks' client is the end-to-end tests' too: a GET's response,
`get`; an upgrade's, `upgrade`; a message framed as a client frames it,
`masked`; and a shell's attach and its output read until a test passes,
`readOutput`. So is the server they run against, started by its
launcher on a configuration, `launch`, and ended by the termination
signal, `terminate`.

## Examples

Against the deployed site, from a checkout or an unpacked release:

```sh
make smoke HOST=ernest-lang.org
```

which runs `ern run build/smoke.erc ernest-lang.org deploy/config.json`.

## Smoke.Check

```ernest
type Check = Check(name : String, result : Either(String, Unit))
```

A check run: its name, and `Right(Unit)` where it passed or what came
where it failed.

## Smoke.main

```ernest
Smoke.main() : Unit
```

The checks the configuration the second argument names takes, run
against the site of the host the first names, over TLS on 443 and plain
HTTP on 80, each check's line printed, and the status 0 where every one
passed and 1 otherwise.

## Smoke.checks

```ernest
Smoke.checks(scheme : String, host : String, port : Int, redirectPort : Int, redirectHost : String, shellPath : Optional(String), origin : String) : List(Check)
```

The checks run against the site of the host on the port, over the
scheme, `https` or `http`, on the redirect port over plain HTTP, and for
the redirect host, and the shell's upgrade at the shell's path from the
origin where the path is given, each with its name and what came where
it failed, in the order the module's documentation gives them.

## Smoke.get

```ernest
Smoke.get(socket : Address(Tcp.SocketMsg), target : String, host : String, ms : Int) : Either(Io.Error, #(Http.Response, Bytes))
```

The response to a GET of the target naming the host, written to the
socket, and its body, of at most 16 MiB; the write, the head and the
body each within the milliseconds. A response that is no HTTP/1.1
answers `Other` and what is wrong with it.

## Smoke.upgrade

```ernest
Smoke.upgrade(socket : Address(Tcp.SocketMsg), target : String, host : String, origin : String, ms : Int) : Either(Io.Error, #(Http.Response, Bytes))
```

The response to an upgrade of the target to a WebSocket, naming the
host and from the origin, its key 16 bytes of its own, written to the
socket, and the bytes after the response's head; the write and the head
each within the milliseconds. A response that is no HTTP/1.1 answers
`Other` and what is wrong with it.

## Smoke.masked

```ernest
Smoke.masked(message : WebSocket.Message) : Bytes
```

The message as a client sends it: one frame masked with a key of its
own, `Crypto.randomBytes(4)`.

## Smoke.readOutput

```ernest
Smoke.readOutput(socket : Address(Tcp.SocketMsg), decoder : WebSocket.Decoder, carried : Bytes, test : (Bytes) -> Bool, ms : Int) : Either(String, #(String, Bytes, WebSocket.Decoder))
```

A shell's attach and its output, the messages the socket carries after
a resize that attaches it, the bytes carried first, decoded with the
decoder: the text of the attach's completion, `{"attached": word}`,
first, and then binary messages until the test passes of what they hold
together, read within the milliseconds. It answers the word, `new` or
`joined`, what the binary messages hold and the decoder after them, or
what came instead, the output shown and then the message, the error or
the time that came before the test passed.

## Smoke.launch

```ernest
Smoke.launch(path : String, count : Int) : Either(Io.Error, #(Address(Os.ProgramMsg), String, List(Int)))
```

The server started by its launcher, `bin/ernest_httpd` from the
repository's root, on the configuration at the path, whose listeners,
the count of them, are on `127.0.0.1`: run through a shell that says its
process number first and then runs the launcher in its place, each line
read within 30000 milliseconds. It answers the running program, its
process number, for `terminate`, and the port each listener says it
listens on, in the configuration's order. A line that is not `listening
on 127.0.0.1:` and a port answers `Other` naming it, and a program that
exits first `Other` with its status and what it said.

## Smoke.terminate

```ernest
Smoke.terminate(program : Address(Os.ProgramMsg), pid : String) : Either(Io.Error, Int)
```

The server `launch` started told to end by the termination signal, by
its process number, within 5000 milliseconds, and its status once it
has exited, read within 30000 milliseconds, what it writes before left
unread.

---

Generated by ern 0.10.0+612faac8 from src/smoke.ern.
