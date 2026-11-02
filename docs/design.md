# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it, `// design §n: ...`, and every `design §n` in a module's comment names a section; `make test` holds both.

## 1. What the program does

ernest-httpd serves one site, ernest-lang.org: its static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell in a container on the server. It implements what that needs of HTTP/1.1 and WebSocket, and nothing more. It is configured by one file, §4, and answers a request for a file as §5 says; what else it implements of HTTP/1.1 and WebSocket, and what it leaves out, is `docs/proposals/basic/proposal.md`'s until the item that builds it states it here.

## 2. Processes

## 3. Modules

Each module has one job, which its doc block states.

| Module | File | Owns |
|---|---|---|
| `Config` | `src/config.ern` | the configuration: the file read into the record of §4, and every rule of §4 checked |
| `Static` | `src/static.ern` | a request for a file to its response, §5 |

## 4. The configuration

The configuration is one JSON file, RFC 8259, read through `Json` at the program's start into the record `Config`, and read no more while the program runs: a change of the file is a restart. `Config.read(path, ms)` reads the file and answers the record, or the first rule the file breaks; `Config.parse(text)` reads the text alone and checks no rule of the file system's.

```
type Config = Config(listeners : List(Listener), root : Path, canonicalHost : String,
  redirectHosts : List(String), timeouts : Timeouts, limits : Limits,
  contentTypes : Map(String, String), headers : List(Http.Header), accessLog : Path,
  shell : Optional(Shell))
type Listener = Listener(kind : Kind, address : String, port : Int)
type Kind = Plain | Tls(certificate : Path, key : Path) | Redirect(acmeChallenge : Path)
type Timeouts = Timeouts(head : Int, idle : Int, write : Int) // milliseconds
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
| `timeouts.head`, `timeouts.idle`, `timeouts.write` | integers, milliseconds | each `is above 0` |
| `limits.request-line`, `limits.headers` | integers, bytes | each `is above 0` |
| `limits.connections`, `limits.connections-per-address` | integers, counts | each `is above 0` |
| `content-types` | an object of strings | each name `begins with a dot`, `.wasm`; each value `is not empty` |
| `headers` | an object of strings | each name `is a token`, RFC 9110's: letters, digits and ``!#$%&'*+-.^_`|~`` |
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
```

**The method.** `GET` and `HEAD` are served; any other method answers 405 with `Allow: GET, HEAD`. A `HEAD` request's response is the `GET`'s with its body dropped and, but for a 304, `Content-Length` the body's size.

**The path.** The target is read by code point, as `Path` reads a path, in origin form, the path up to the first `?`, or in absolute form, a scheme, RFC 3986's, a letter and then letters, digits, `+`, `-` and `.`, then `://`, an authority up to the next `/` or `?`, and the path up to the first `?`, `/` where the path is empty; the query is ignored. A target of another form answers 400. The path is percent-decoded: `%` and two hexadecimal digits are the byte they write, and `%2F`, in either case, answers 400, as does a `%` not followed by two hexadecimal digits, and bytes that are not UTF-8. A decoded path holding a control character, U+0000 to U+001F or U+007F, answers 400.

The path is then split at `/` into segments: an empty segment and `.` are dropped; `..` answers 400, and otherwise a segment beginning with `.` answers 404. A path that ends in `/`, or has no segments, asks for a directory.

**The file.** The segments name a path under the root, links followed. One that leads nowhere answers 404. One that leads to a directory and did not ask for one answers 301 with no body and `Location` the target's path as written, without its query, its leading `/`s made one, with `/` appended. A directory asked for is served as its `index.html`, and answers 404 where that is no regular file. A regular file is served where the path did not ask for a directory; anything else answers 404.

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
