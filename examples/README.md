# Examples

The examples, by topic: what each shows and how it is run. There is one, a site.

## The site

`examples/site/` is a small site with its configuration, `examples/site/config.json`, which `make run` serves on localhost over plain HTTP. Its pages stand under `root/`: a home page with two pictures, a second page, a guide in a directory of its own, the page for a path that leads nowhere, `404.html`, and the shell page, `shell.html`, a terminal in the browser over the server's client, which its script, `shell.js`, imports from the configuration's `shell.client`, `/shell/client.js`, and whose limits write the page's sentence on a session's life. Its paths are relative, and name files under the checkout, from which it runs.

The configuration has two listeners on 127.0.0.1: the plain one on port 8080, which serves the site and the shell, and the redirect one on 8081, which answers 301 to `https://localhost/` and serves the ACME challenge from `acme/`. It serves the host `localhost` and redirects `www.localhost`. Every response carries `X-Content-Type-Options: nosniff` and a `Content-Security-Policy` that admits the site's own scripts and styles, the WebSocket back to it, and the inline styles xterm.js writes as it draws the terminal.

The shell runs `ern shell` under a terminal, at most four at once and ten starts within an hour from one address; a start past either cap is refused, and the page says *unavailable*. A session lives three minutes from its last key or Extend; a minute before its end the page shows the time and an Extend button.

## Running it

```
make run
```

builds the server, fetches xterm.js and its fit addon into `root/xterm/` the first time, each script's MIT license beside it as `xterm.js.LICENSE.txt` and `addon-fit.js.LICENSE.txt`, and serves the site until it is ended: Ctrl-C ends it at once, and `kill -TERM` of its process ends it in order. `ern` must be on `PATH`, since the shell's command names it; `ERN=path/to/ern make run` puts that one first.

The example's shell is `ern shell` run as the server's own user, with no container around it: it is for a look at one's own machine over localhost, and never for the internet, where the site's command starts a podman container instead.

Open http://localhost:8080 in a browser, and not http://127.0.0.1:8080: the configuration serves the host `localhost` alone and answers another 421, the shell takes the origin `http://localhost:8080` alone, and the shell's cookie is `Secure`, which a browser keeps from `localhost` over plain HTTP as from a site over TLS. The pages link each other, and the shell page's Stop ends the session, Restart starts a new one, and the status line says why the session ended.

## What curl shows

What a browser does not show, a request each, with what it answers; the headers every response carries, `Date` and the configuration's two, are left out of the comments. Run them from the checkout, while `make run` serves the site:

```
# the directory without its slash: 301, Location: /guide/, no body
curl -i http://localhost:8080/guide

# the head alone: 200 with Content-Type, Last-Modified and Content-Length
curl -I http://localhost:8080/

# If-Modified-Since the file's own time: 304 Not Modified, no body
curl -i -z examples/site/root/index.html http://localhost:8080/

# a path that leads nowhere: 404 with the site's 404.html
curl -i http://localhost:8080/nothing

# a dot-dot segment, which curl would otherwise remove: 400 Bad Request
curl -i --path-as-is http://localhost:8080/../config.json

# a method other than GET and HEAD: 405 with Allow: GET, HEAD
curl -i -X POST http://localhost:8080/

# a host that is neither localhost nor www.localhost: 421 Misdirected Request
curl -i -H 'Host: elsewhere' http://localhost:8080/

# the redirect host: 301, Location: https://localhost/about.html
curl -i -H 'Host: www.localhost' http://localhost:8080/about.html

# the redirect listener: 301, Location: https://localhost/about.html
curl -i http://localhost:8081/about.html

# the challenge's file on the redirect listener: 200, the key authorization
curl -i http://localhost:8081/.well-known/acme-challenge/LoqXcYV8q5ONbJQxbmR7SCTNo3tiAXDfowyjxAjEuX0

# the client: 200 with Content-Type: text/javascript; charset=utf-8 and
# Cache-Control: no-store, the module whose head is the shell's path and limits
curl -i http://localhost:8080/shell/client.js

# the shell's path without an upgrade: 426 with Upgrade: websocket
curl -i http://localhost:8080/shell/session

# the upgrade from another origin: 403 Forbidden
curl -i -H 'Connection: Upgrade' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Version: 13' \
     -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==' -H 'Origin: http://127.0.0.1:8080' \
     http://localhost:8080/shell/session

# the upgrade from the site's origin: 101 Switching Protocols, with
# Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=, RFC 6455's own example,
# and the shell's cookie; curl shows a 101's head only with -v, and then
# waits, until Ctrl-C ends it
curl -v -H 'Connection: Upgrade' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Version: 13' \
     -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==' -H 'Origin: http://localhost:8080' \
     http://localhost:8080/shell/session

# each response as a line of Common Log Format, as it is written
tail -f build/examples/site/access.log
```

The challenge's file is RFC 8555's own example token, and what it holds is the key authorization a certificate authority reads there.
