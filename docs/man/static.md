# Ernest module Static

The static site: a request for a file under the root answered with the
file, its content type and its modification time, or with an error
(design §5).

A connection makes the site once, with `site`, from the configuration's
root and content types, and answers each request with `serve`, whatever
its method and target; it adds `Date` and the configuration's headers to
the response before it writes it. `error` is the response of a status
the connection answers itself, and `withoutBody` makes it a `HEAD`'s.
`pathAndQuery` and `authority` read a target as `serve` reads it, for
what a request's host decides before the site serves it (design §9).

`serve` reads the file system for each request, each read bounded by the
milliseconds given, and keeps nothing between requests: a file changed
under the root is served as it is when the request comes.

## Examples

A method other than `GET` and `HEAD` is answered 405, its body plain text:

```ernest
let request =
    Http.Request(method = "POST",
                 target = "/",
                 version = Http.Version(major = 1, minor = 1),
                 headers = []);
let #(response, body) = Static.serve(Static.site(Path("site"), Map.empty), request, 1000);
#(response.status, response.headers, String.fromUtf8(body))
// => #(405, [Http.Header(name = "Allow", value = "GET, HEAD"), Http.Header(name = "Content-Type", value = "text/plain; charset=utf-8")], Some("405 Method Not Allowed\n"))
```

## Static.Site

```ernest
type Site = Site(root : Path, contentTypes : Map(String, String))
```

The site a request for a file is served from: the root its files stand
under, and the table of content types by extension, each with its dot.

## Static.contentTypes

```ernest
Static.contentTypes : Map(String, String)
```

The built-in table of content types, by extension with its dot.

### Examples

```ernest
Map.get(Static.contentTypes, ".html")
// => Some("text/html; charset=utf-8")
```

## Static.site

```ernest
Static.site(root : Path, contentTypes : Map(String, String)) : Site
```

The site of the root, its table the built-in one extended by
`contentTypes`, whose type wins for an extension both have.

### Examples

```ernest
let site = Static.site(Path("site"), Map.fromList([#(".txt", "text/plain")]));
#(Map.get(site.contentTypes, ".txt"), Map.get(site.contentTypes, ".css"))
// => #(Some("text/plain"), Some("text/css; charset=utf-8"))
```

## Static.serve

```ernest
Static.serve(site : Site, request : Http.Request, ms : Int) : #(Http.Response, Bytes)
```

The response to the request and its body: the file the target names
under the root, a redirect to a directory's path, or an error, each
read of the file system bounded by `ms` milliseconds.

`GET` and `HEAD` are served, and a `HEAD` answers the `GET`'s response
with no body and, but for a 304, its body's size as `Content-Length`;
any other method answers 405. A file the file system refuses to describe
or to read answers 500, and the path and the error are written on
standard error.

### Examples

A target of no form a server reads is answered 400:

```ernest
let request =
    Http.Request(method = "GET",
                 target = "*",
                 version = Http.Version(major = 1, minor = 1),
                 headers = []);
let #(response, _) = Static.serve(Static.site(Path("site"), Map.empty), request, 1000);
response.status
// => 400
```

## Static.withoutBody

```ernest
Static.withoutBody(#(Http.Response, Bytes)) : #(Http.Response, Bytes)
```

A `HEAD`'s response of a `GET`'s: its body dropped and, but for a 304,
the body's size as its `Content-Length`. The connection drops so the
body of a `HEAD` it refuses itself.

### Examples

```ernest
let ok =
    Http.Response(version = Http.Version(major = 1, minor = 1), status = 200, headers = []);
Static.withoutBody(#(ok, <<104, 105>>))
// => #(Http.Response(version = Http.Version(major = 1, minor = 1), status = 200, headers = [Http.Header(name = "Content-Length", value = "2")]), <<>>)
```

## Static.pathAndQuery

```ernest
Static.pathAndQuery(target : String) : Optional(String)
```

The target from its path on, its query among it, as the client wrote
it: an origin-form target whole, and an absolute-form one after its
scheme and its authority, `/` standing for an empty path; `None` for a
target of another form, which `serve` answers 400.

The target is read by code point, as `Path` reads a path.

### Examples

```ernest
#(Static.pathAndQuery("/docs?page=2"),
  Static.pathAndQuery("http://ernest-lang.org?q=1"),
  Static.pathAndQuery("*"))
// => #(Some("/docs?page=2"), Some("/?q=1"), None)
```

## Static.authority

```ernest
Static.authority(target : String) : Optional(String)
```

The authority of a target in absolute form, between its scheme's `://`
and the next `/` or `?`, as the client wrote it, its port among it;
`None` for a target of another form, origin form among them.

### Examples

```ernest
#(Static.authority("http://ernest-lang.org:80/docs"), Static.authority("/docs"))
// => #(Some("ernest-lang.org:80"), None)
```

## Static.error

```ernest
Static.error(site : Site, status : Int, ms : Int) : #(Http.Response, Bytes)
```

The response of the status and its body, plain text naming the status
and its phrase, `404 Not Found` and a line feed.

A 404 answers the root's `404.html` instead, as HTML, where that is a
regular file, and 500 where the file system refuses to read it, the path
and the error written on standard error.

### Examples

```ernest
let #(response, body) = Static.error(Static.site(Path("site"), Map.empty), 400, 1000);
#(response.status, response.headers, String.fromUtf8(body))
// => #(400, [Http.Header(name = "Content-Type", value = "text/plain; charset=utf-8")], Some("400 Bad Request\n"))
```

---

Generated by ern 0.10.0+612faac8 from src/static.ern.
