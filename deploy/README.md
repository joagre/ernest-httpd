# Deploying ernest-httpd

The operator's steps, in their order, from a machine with Ubuntu 24.04, systemd, podman and certbot to the smoke test passing. Each step gives its commands and what it says when it fails. What each file of `deploy/` is, and the server's arrangement on the machine, is the design's §13, [`docs/design.md`](../docs/design.md); the files stand here as they are installed, and the release archive carries them under its own `deploy/`.

A line whose prompt is `$` is typed by the operator, `sudo` before what the superuser runs. A line whose prompt is `httpd$` is typed in a shell of the server's user, `sudo -u httpd -H bash` and then `cd`, its home, with `export PATH=/home/httpd/opt/local/bin:$PATH`, the user's prefix's `bin` first, so that the prefix's `erl` and `ern` are found once steps 3 and 4 install them.

## 1. The machine

The machine runs Ubuntu 24.04 with systemd, podman and certbot, `sudo apt install podman certbot`, its ports 80 and 443 open, and the four names in DNS: `ernest-lang.org`, `www.ernest-lang.org`, `ernest-lang.se` and `www.ernest-lang.se`. The operator brings the server's release archive, `ernest_httpd-0.1.0.tar.gz`, which `make release` writes, and Ernest's, `ern-0.9.0.tar.gz`, the one the release was built with.

The listeners stand on `::`, which takes IPv4 as well where the kernel's dual stack is on, Ubuntu's default: `sysctl net.ipv6.bindv6only` says `= 0`. Where it says `= 1`, the server serves IPv6 alone.

## 2. The user

The server runs as its own user, `httpd`, whose home, `/home/httpd`, holds everything of the server's: the prefix it is installed under, `opt/local`, its directory, `ernest-httpd`, and podman's storage. The user has a home, no login shell, and the subordinate user and group numbers rootless podman maps the container's users to:

```console
$ sudo useradd --create-home --home-dir /home/httpd --shell /usr/sbin/nologin httpd
$ grep httpd /etc/subuid /etc/subgid
$ sudo install -o httpd -g httpd -m 0644 ern-0.9.0.tar.gz ernest_httpd-0.1.0.tar.gz /home/httpd/
```

`grep` prints a line of each file; where it prints none, `useradd` gave the user no range, and podman later says `potentially insufficient UIDs or GIDs available in user namespace`: give one of 65536 that no other line of the files holds, `sudo usermod --add-subuids 300000-365535 --add-subgids 300000-365535 httpd`. A user made before is refused, `useradd: user 'httpd' already exists`.

## 3. Erlang/OTP

`ern` runs on Erlang/OTP 29, which Ubuntu 24.04 does not package, its own being 25, so OTP is built as `httpd` from its source release, the one the shell's image runs, and installed under the user's prefix:

```console
$ sudo apt install build-essential autoconf libncurses-dev libssl-dev
httpd$ curl -fLO https://github.com/erlang/otp/releases/download/OTP-29.1.2/otp_src_29.1.2.tar.gz
httpd$ tar -xzf otp_src_29.1.2.tar.gz && cd otp_src_29.1.2
httpd$ ./configure --prefix=/home/httpd/opt/local && make && make install
httpd$ cd && erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().'
29
```

`./configure` ends with the applications it will not build; `crypto` and `ssl` among them means it found no OpenSSL, which the server's TLS needs: install `libssl-dev` and configure again. An `erl` that prints another release is not the prefix's: `PATH` lacks `/home/httpd/opt/local/bin` first.

## 4. Ernest and the server

Ernest is installed under the same prefix from the archive the release was built with, since a node runs only what its own build of `ern` compiled and refuses another's, `ern run: /home/httpd/opt/local/lib/ernest_httpd/build/ernest_httpd.erc: compiled by another build of ern`; then the server, from its unpacked release archive, which `make install` installs as it was compiled:

```console
httpd$ tar -xzf ern-0.9.0.tar.gz && cd ern-0.9.0
httpd$ make && make install PREFIX=/home/httpd/opt/local
httpd$ cd && ern --version
ern 0.9.0
httpd$ tar -xzf ernest_httpd-0.1.0.tar.gz && cd ernest_httpd-0.1.0
httpd$ make install PREFIX=/home/httpd/opt/local
httpd$ cd && command -v ernest_httpd
/home/httpd/opt/local/bin/ernest_httpd
```

`make` without a C compiler fails at the helper's line, `make: cc: No such file or directory`, and `ern` without OTP says `ern: erl, of Erlang/OTP 29, is not on the path`. A prefix the user cannot write fails at its first `mkdir`, `Permission denied`.

The server's `make install` puts the launcher in `/home/httpd/opt/local/bin/ernest_httpd`, the compiled program under `/home/httpd/opt/local/lib/ernest_httpd/` and its documents under `/home/httpd/opt/local/share/doc/ernest_httpd/`, and replaces an installation there whole; a launcher there of another program's is refused, `/home/httpd/opt/local/bin/ernest_httpd is there already and is not this program's`. A later release installs the same way, from its own unpacked archive, and `make uninstall PREFIX=/home/httpd/opt/local` there removes what `make install` put under the prefix and nothing else.

## 5. The directories

The server's directory, `/home/httpd/ernest-httpd`, holds the site, `site/`, the challenge's directory, `acme/`, which certbot writes into, and the access log's, `log/`; the site's files, its pages and its shell page, are copied under `site/`:

```console
httpd$ mkdir -p ernest-httpd/site ernest-httpd/acme ernest-httpd/log
```

The node's directory, `node/`, listens on the loopback alone and lists one peer, the operator's directory, `~/ops`, which lists the server with its address. A configuration directory opens to its owner alone, so the superuser makes the two and lists each in the other, with the prefix's `ern`, and then gives each to its user:

```console
$ path=/home/httpd/opt/local/bin:$PATH
$ sudo env PATH=$path ern config --config-dir /home/httpd/ernest-httpd/node --listen 127.0.0.1:8654
$ sudo env PATH=$path ern config --config-dir ~/ops
$ sudo env PATH=$path ern config --config-dir /home/httpd/ernest-httpd/node --peer-dir ~/ops
$ sudo env PATH=$path ern config --config-dir ~/ops --peer-dir /home/httpd/ernest-httpd/node
$ sudo chown -R httpd:httpd /home/httpd/ernest-httpd/node
$ sudo chown -R "$USER": ~/ops
```

Each directory lists the other by its name, the server the peer `ops` and the operator `node`. A directory made before is refused, `ern config: /home/httpd/ernest-httpd/node exists`, and a peer listed before with the file's path and `a peer is named "node" already`; neither changes anything. A parent that is not there is refused, `no such directory`: the server's directory of the step's first command is made first.

## 6. The configuration and a first certificate

```console
httpd$ install -m 0644 ernest_httpd-0.1.0/deploy/config.json ernest-httpd/node/config.json
httpd$ openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 2 \
      -subj /CN=ernest-lang.org -keyout ernest-httpd/node/privkey.pem -out ernest-httpd/node/fullchain.pem
httpd$ chmod 0600 ernest-httpd/node/privkey.pem
```

The certificate is the server's own until certbot's first replaces it, in step 9: the server listens on 443 only with a certificate, and certbot's webroot asks the server, on 80, for the challenge. A key that others may read is refused at the server's start, in step 8.

`limits.connections` is 160 and `limits.connections-per-address` 16, so that 160 connections whose clients read nothing, each holding five times the site's largest file over TLS, xterm.js's 0.3 MiB, stay under 256 MiB; a site that gains a larger file sizes the two again by that rule. `timeouts.idle` is 15000, so that an idle connection gives back what it holds soon.

## 7. The shell's image

The visitor's shell runs in a container of the image `ernest-shell`, built by `httpd` from `deploy/Containerfile` with Ernest's archive beside it as `ern.tar.gz`, its storage under the user's home, `/home/httpd/.local/share/containers`. The user's systemd instance, kept running by its linger, gives podman its run directory, `/run/user/` and the user's number, and the limits of the container's memory and processes:

```console
$ sudo loginctl enable-linger httpd
httpd$ mkdir image && cp ernest_httpd-0.1.0/deploy/Containerfile image/ && cp ern-0.9.0.tar.gz image/ern.tar.gz
httpd$ podman build -t ernest-shell image
httpd$ podman info --format '{{.Store.GraphRoot}} {{.Store.RunRoot}}'
/home/httpd/.local/share/containers/storage /run/user/1001/containers
```

`podman info` names podman's storage and run directories, which the unit's `ReadWritePaths` makes writable under `ProtectSystem=strict`. A podman without the linger says `The cgroupv2 manager is set to systemd but there is no systemd user session available`, and a container it starts takes no `--memory`.

The image answers a line of Ernest, here from standard input, and the shell's command, at a terminal of the operator's, runs it as a visitor's session does, where `1 + 2` answers `3 : Int`, `Fs.write(Path("x"), <<1>>, 1000)` answers `Right(Unit)` in the size-capped home, and `:quit` leaves:

```console
httpd$ printf '1 + 2\n' | podman run -i --rm --network none ernest-shell
httpd$ podman run -it --rm --network none --read-only --cap-drop=ALL \
      --security-opt=no-new-privileges --memory 128m --pids-limit 128 \
      --tmpfs /home/shell:size=64m ernest-shell
```

## 8. The unit

```console
$ sudo install -m 0644 /home/httpd/ernest_httpd-0.1.0/deploy/ernest-httpd.service /etc/systemd/system/
$ sudo systemctl daemon-reload
$ sudo systemctl enable --now ernest-httpd
$ journalctl -u ernest-httpd
```

The journal says `listening on 127.0.0.1:8654`, the node's own listener, then `listening on :::443` and `listening on :::80`. A configuration the server refuses is said with its field, `/home/httpd/ernest-httpd/node/config.json: listeners[0].key is readable by the program's user alone`, a port another server holds as `:::443: Other("address already in use")`, and a directory of `ReadWritePaths` that does not exist, the image not yet built, by systemd: `Failed to set up mount namespacing`, the status `226/NAMESPACE`.

The unit binds 80 and 443 as no root by `AmbientCapabilities=CAP_NET_BIND_SERVICE`, a capability that goes with systemd. A server run without systemd binds the two ports by `setcap cap_net_bind_service=+ep` on the prefix's own BEAM binary, `/home/httpd/opt/local/lib/erlang/erts-*/bin/beam.smp`, the binary itself and not a link to it, redone at each install of OTP, a file capability putting the binary in secure-exec mode, which drops `LD_LIBRARY_PATH` and the like; authbind and privbind, root's helpers in front of `ern`, are not used.

Yaws' privbind page, https://upload.int.onexglobal.io/privbind.yaws, lists the ways a server that is not root binds a port below 1024, `setcap` on the binary, authbind, privbind and a sysctl among them, of which the unit's `AmbientCapabilities=CAP_NET_BIND_SERVICE` is systemd's own and `setcap` the fallback.

`systemctl reload ernest-httpd` reads the node's peers again, `ern reload`, and nothing of `config.json`, whose change is `systemctl restart ernest-httpd`; `systemctl stop ernest-httpd` ends the server in order, each shell closed with 1001.

## 9. The certificate

One certificate names the four hosts, issued by certbot in webroot mode against the challenge's directory, which the server's redirect listener serves on 80. The deploy hook, installed first, copies it into the node's directory and restarts the server:

```console
$ sudo install -D -m 0755 /home/httpd/ernest_httpd-0.1.0/deploy/certbot-deploy.sh \
      /etc/letsencrypt/renewal-hooks/deploy/ernest-httpd.sh
$ sudo certbot certonly --webroot -w /home/httpd/ernest-httpd/acme --cert-name ernest-lang.org \
      -d ernest-lang.org -d www.ernest-lang.org -d ernest-lang.se -d www.ernest-lang.se
$ sudo certbot renew --dry-run
```

certbot 3.2 and later runs the hook after the issue itself; an earlier one, Ubuntu 24.04's own package among them, runs the hooks of the directory only at a renewal, `certbot --version` says which, and the hook then runs once by hand, `sudo /etc/letsencrypt/renewal-hooks/deploy/ernest-httpd.sh`. A name that does not lead to the server fails its challenge, `Invalid response from http://ernest-lang.se/.well-known/acme-challenge/...`, or `Connection refused` where nothing listens on 80.

## 10. The access log

```console
$ sudo install -m 0644 /home/httpd/ernest_httpd-0.1.0/deploy/logrotate /etc/logrotate.d/ernest-httpd
$ sudo logrotate -d /etc/logrotate.d/ernest-httpd
```

`logrotate -d` says `considering log /home/httpd/ernest-httpd/log/access.log` and rotates nothing; a line of the file it refuses begins with `error:` and names the line, `unknown user 'httpd'` where step 2 did not make the user.

## 11. The smoke test

From the unpacked release archive, as `httpd`, or from a checkout with Ernest on its `PATH`, on the machine or another:

```console
httpd$ cd ernest_httpd-0.1.0 && make smoke HOST=ernest-lang.org
https://ernest-lang.org:443/ answers 200: ok
http://ernest-lang.org:80/ answers 301 to https://ernest-lang.org/: ok
https://ernest-lang.org:443/ for www.ernest-lang.org answers 301 to https://ernest-lang.org/: ok
https://ernest-lang.org:443/ for elsewhere answers 421: ok
https://ernest-lang.org:443/shell/session runs 1 + 2 and closes with 4004 at a stop: ok
```

A check that fails says what came, and `make smoke` then exits with an error: `failed: Refused` where nothing listens; `failed: Other("TLS client: ... Bad Certificate ...")` where the certificate is still step 6's or names another host; and for the shell, `failed: output "..." then Close(code = Some(4003), reason = "")` where no session is free, or the output podman wrote before the session closed where the container did not start.

## 12. Looking in

The operator's shell attaches to the server's node from the operator's directory, as the deployment guide of the installation, `share/doc/ernest/guide/deployment.md`, shows in its section 6, with an `ern` of the same archive as the server's, installed under a prefix of the operator's own as step 4 installs it. The attach waits on Ernest today, as [`docs/plan.md`](../docs/plan.md)'s *The attached shell, a gap waiting on Ernest* says, and this step stands as it will run:

```console
$ ern shell --config-dir ~/ops --attach node
the peer node connected
Ernest 0.9.0, session 1. :help for the commands, :quit to leave.
> :processes
> :quit
```

`:processes` lists the server's processes, each by the site its spawn is written in, with its line, and what it does: the entry process, `ErnestHttpd.main`, receiving; the access log, spawned in `AccessLog.start`, and the sessions, in `Sessions.start`; each listener, spawned in `ErnestHttpd.listening`, and its acceptor, in `Listener.serve`; a connection for each socket a listener holds, spawned in `Listener`; and the sockets and listeners themselves, `Tcp.accept` and `Tcp.listen`.

A visitor whose shell runs has a session, spawned in `Sessions`, its program, `Os.startTerminal`, and its reader, spawned in `Session`; while the visitor's page is attached, the page's connection is a shell with its reader, spawned in `Shell.serve`. `:quit` leaves, and the server runs on. An attach that fails says why, `ern shell: the peer node is unreachable` where the server is not running, and `ern shell: the peer node is not listed` where step 5 did not list it.
