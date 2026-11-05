# Ernest module Config

The configuration: one JSON file read into one record, and every rule
it checks, so that a bad file is refused at the start with its field,
the rule and the value named (design §4).

A program reads the file once, at its start, with `read`, and keeps the
record; a change of the file is a restart. `parse` reads a text alone
and checks no rule of the file system's, for a test or a tool.

An error is a value: what kept the file from being read, a text that is
not JSON, or the first field that breaks a rule, named from the file's
top, `listeners[0].port`, with the value it refused. `reason` writes it
for the operator, to stand after the file's path.

A host is compared with its port dropped, `withoutPort`, and in any
case: a redirect host so compared with the canonical host is refused,
and a request's host is so compared with both (design §9).

## Examples

A field that breaks a rule, the rule it breaks, and no value, since the
field is absent:

```ernest
Config.parse("{}")
// => Left(Config.Invalid(field = "listeners", rule = "is required", value = None))
```

What the operator reads, the value as JSON writes it:

```ernest
#(Config.reason(Config.Invalid(field = "listeners[0].port",
                               rule = "be 0 to 65535",
                               value = Some("70000"))),
  Config.reason(Config.Invalid(field = "root", rule = "is required", value = None)))
// => #("listeners[0].port must be 0 to 65535: 70000", "root is required")
```

## Config.Config

```ernest
type Config =
    Config(listeners : List(Listener),
           root : Path,
           canonicalHost : String,
           redirectHosts : List(String),
           timeouts : Timeouts,
           limits : Limits,
           contentTypes : Map(String, String),
           headers : List(Http.Header),
           accessLog : Path,
           shell : Optional(Shell))
```

The configuration, as the file's fields have it (design §4).

## Config.Listener

```ernest
type Listener = Listener(kind : Kind, address : String, port : Int)
```

A listener: its kind, the address it binds and its port.

## Config.Kind

```ernest
type Kind = Plain | Tls(certificate : Path, key : Path) | Redirect(acmeChallenge : Path)
```

A listener's kind: plain HTTP, TLS with the certificate's and the key's
files, or the redirect listener with the ACME challenge's directory.

## Config.Timeouts

```ernest
type Timeouts = Timeouts(head : Int, idle : Int, write : Int, file : Int)
```

The deadlines, in milliseconds: for a request's head, for an idle
connection, for a write, and for a read or an append of the file system.

## Config.Limits

```ernest
type Limits =
    Limits(requestLine : Int, headers : Int, connections : Int, connectionsPerAddress : Int)
```

The limits: the most bytes of a request line and of the headers
together, and the most connections open in all and from one address.

## Config.Shell

```ernest
type Shell =
    Shell(path : String,
          origins : List(String),
          command : List(String),
          mostAtOnce : Int,
          starts : Starts,
          lifetime : Int,
          warning : Int,
          messageLimit : Int,
          hangup : Int)
```

The shell: the WebSocket's path, the origins allowed, the command a
session runs, how many at once, each visitor's starts, a session's
lifetime and its warning in milliseconds, the most bytes of a message,
and the milliseconds a program has to exit after its terminal is hung up.

## Config.Starts

```ernest
type Starts = Starts(count : Int, within : Int)
```

How many starts a visitor may make within the milliseconds.

## Config.Error

```ernest
type Error =
    Unreadable(Io.Error)
  | NotJson(Json.Error)
  | Invalid(field : String, rule : String, value : Optional(String))
```

Why there is no configuration: the file cannot be read, its text is not
JSON, or a field breaks a rule, the field named from the file's top, the
rule as design §4's table writes it, and the value refused as JSON
writes it, None for a field absent or of no field, which no value breaks.

## Config.read

```ernest
Config.read(path : Path, ms : Int) : Either(Error, Config)
```

The file read within `ms` milliseconds and every rule checked, those of
the file system's after the rest: the record, or the first error.

## Config.parse

```ernest
Config.parse(text : String) : Either(Error, Config)
```

The text read and every rule checked but the file system's: the record,
or the first error.

## Config.reason

```ernest
Config.reason(error : Error) : String
```

The error in prose, after which the operator reads the file's path:
`cannot read the file: ` and the error, `is not JSON: ` and the error,
the field, ` must `, the rule, `: ` and the value refused, or, where
there is no value, the field, a space and the rule.

## Config.withoutPort

```ernest
Config.withoutPort(host : String) : String
```

The host with its port dropped: a `:` and digits alone after it at the
host's end, none among them; any other tail stands. A `:` inside an
IPv6 address's brackets is followed by its `]`, so `[::1]` stands whole.

### Examples

```ernest
#(Config.withoutPort("ernest-lang.org:443"),
  Config.withoutPort("[::1]"),
  Config.withoutPort("ernest-lang.org:abc"))
// => #("ernest-lang.org", "[::1]", "ernest-lang.org:abc")
```

---

Generated by ern 0.10.0+612faac8 from src/config.ern.
