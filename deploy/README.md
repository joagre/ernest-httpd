# Deploying ernest-httpd

The operator's steps, in their order, from a machine with Debian 13, systemd, podman and certbot to the smoke test passing. Each step gives its commands and what it says when it fails. What each file of `deploy/` is, and the server's arrangement on the machine, is the design's §13, [`docs/design.md`](../docs/design.md); the files stand here as they are installed, and the release archive carries them under its own `deploy/`.

A line whose prompt is `$` is typed by the operator, `sudo` before what the superuser runs. A line whose prompt is `httpd$` is typed in a shell of the server's user, `sudo -u httpd -H bash` and then `cd`, its home, with `export PATH=/home/httpd/opt/local/bin:$PATH`, the user's prefix's `bin` first, so that the prefix's `ern` is found once step 4 installs it, and `/usr/local`'s `erl` after it.

## 1. The machine

The machine runs Debian 13 with systemd, podman and certbot, `sudo apt install podman certbot git curl`, its ports 80 and 443 open, and the four names in DNS: `ernest-lang.org`, `www.ernest-lang.org`, `ernest-lang.se` and `www.ernest-lang.se`. The operator brings the server's release archive, `ernest_httpd-0.1.0.tar.gz`, which `make release` writes, and Ernest's, `ern-0.10.0.tar.gz`, the one the release was built with.

Each of the two ports has a listener on `0.0.0.0` and one on `::`, since a listener takes connections of its address's family alone, and the four names resolve to the machine's address of each family it serves.

## 2. The user

The server runs as its own user, `httpd`, whose home, `/home/httpd`, holds everything of the server's: the prefix it is installed under, `opt/local`, its directory, `ernest-httpd`, and podman's storage. The user has a home, no login shell, and the subordinate user and group numbers rootless podman maps the container's users to:

```console
$ sudo useradd --create-home --home-dir /home/httpd --shell /usr/sbin/nologin httpd
$ grep httpd /etc/subuid /etc/subgid
$ sudo install -o httpd -g httpd -m 0644 ern-0.10.0.tar.gz ernest_httpd-0.1.0.tar.gz /home/httpd/
```

`grep` prints a line of each file; where it prints none, `useradd` gave the user no range, and podman later says `potentially insufficient UIDs or GIDs available in user namespace`: give one of 65536 that no other line of the files holds, `sudo usermod --add-subuids 300000-365535 --add-subgids 300000-365535 httpd`. A user made before is refused, `useradd: user 'httpd' already exists`.

## 3. Erlang/OTP

`ern` runs on Erlang/OTP 29, which Debian 13 does not package, so OTP is built from its source release, the one the shell's image runs, and installed under `/usr/local` by the superuser, where the server's user and the operator both find it:

```console
$ sudo apt install build-essential autoconf libncurses-dev libssl-dev
$ curl -fLO https://github.com/erlang/otp/releases/download/OTP-29.1.2/otp_src_29.1.2.tar.gz
$ tar -xzf otp_src_29.1.2.tar.gz && cd otp_src_29.1.2
$ ./configure --prefix=/usr/local && make && sudo make install
$ erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().'
29
```

`./configure` ends with the applications it will not build; `crypto` and `ssl` among them means it found no OpenSSL, which the server's TLS needs: install `libssl-dev` and configure again. An `erl` that prints another release is another one earlier on `PATH`, a package's; `which erl` says which.

## 4. Ernest and the server

Ernest is installed under the server's prefix, `/home/httpd/opt/local`, from the archive the release was built with, since a node runs only what its own build of `ern` compiled and refuses another's, `ern run: /home/httpd/opt/local/lib/ernest_httpd/build/ernest_httpd.erc: compiled by another build of ern`; then the server, from its unpacked release archive, which `make install` installs as it was compiled:

```console
httpd$ tar -xzf ern-0.10.0.tar.gz && cd ern-0.10.0
httpd$ make && make install PREFIX=/home/httpd/opt/local
httpd$ cd && ern --version
ern 0.10.0+<commit>
httpd$ tar -xzf ernest_httpd-0.1.0.tar.gz && cd ernest_httpd-0.1.0
httpd$ make install PREFIX=/home/httpd/opt/local
httpd$ cd && command -v ernest_httpd
/home/httpd/opt/local/bin/ernest_httpd
```

`ern --version` prints the version and, after its `+`, the commit Ernest's archive was made from. `make` without a C compiler fails at the helper's line, `make: cc: No such file or directory`, and `ern` without OTP says `ern: erl, of Erlang/OTP 29, is not on the path`. A prefix the user cannot write fails at its first `mkdir`, `Permission denied`.

The server's `make install` puts the launcher in `/home/httpd/opt/local/bin/ernest_httpd`, the compiled program under `/home/httpd/opt/local/lib/ernest_httpd/` and its documents under `/home/httpd/opt/local/share/doc/ernest_httpd/`, `deploy/` and `examples/` among them, and replaces an installation there whole; a launcher there of another program's is refused, `/home/httpd/opt/local/bin/ernest_httpd is there already and is not this program's`. A later release installs the same way, from its own unpacked archive, and `make uninstall PREFIX=/home/httpd/opt/local` there removes what `make install` put under the prefix, then `share/doc`, `share`, `lib` and `bin` under it where each is empty, and nothing else.

## 5. The directories

The server's directory, `/home/httpd/ernest-httpd`, holds the site, `site/`, the challenge's directory, `acme/`, which certbot writes into, and the access log's, `log/`; the site's files, `site/` of the site's own repository, https://github.com/joagre/ernest-lang.org, cloned beside it, are copied under `site/`:

```console
httpd$ mkdir -p ernest-httpd/site ernest-httpd/acme ernest-httpd/log
httpd$ git clone https://github.com/joagre/ernest-lang.org
httpd$ cp -R ernest-lang.org/site/. ernest-httpd/site/
```

A later change to the site is pulled and copied the same way, and the server serves it at the next request; `cp` replaces and adds, and a file the site's repository deleted is removed from `ernest-httpd/site/` by hand:

```console
httpd$ git -C ernest-lang.org pull && cp -R ernest-lang.org/site/. ernest-httpd/site/
```

A clone made before is refused, `fatal: destination path 'ernest-lang.org' already exists and is not an empty directory`, and changes nothing; a `git` that is not there says `git: command not found`, step 1's `apt install` not run.

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

The certificate is the server's own until certbot's first replaces it, in step 9: the server listens on 443 only with a certificate, and certbot's webroot asks the server, on 80, for the challenge. A key that others may read, or that its user may not, is refused at the server's start, in step 8, and so is a certificate the server's user cannot read.

`limits.connections` is 80, counted by listener, and `limits.connections-per-address` 16, so that the two `tls` listeners' 160 connections whose clients read nothing, each holding five times the site's largest file over TLS, xterm.js's 0.3 MiB, stay under 256 MiB; a site that gains a larger file sizes the two again by that rule. `timeouts.idle` is 15000, so that an idle connection gives back what it holds soon.

## 7. The shell

The linger and podman's directories are made whether or not the configuration takes a shell, since the unit's `ExecStartPre` runs podman and its `ReadWritePaths` names podman's storage and run directories. The user's systemd instance, kept running by its linger, gives podman its run directory, `/run/user/` and the user's number, and the limits of the container's memory and processes; `podman info` makes podman's storage under the user's home, `/home/httpd/.local/share/containers`, and names the two:

```console
$ sudo loginctl enable-linger httpd
httpd$ podman info --format '{{.Store.GraphRoot}} {{.Store.RunRoot}}'
/home/httpd/.local/share/containers/storage /run/user/1001/containers
```

A podman without the linger says `The cgroupv2 manager is set to systemd but there is no systemd user session available`, and a container it starts takes no `--memory`.

The rest of the step is run when the configuration takes a shell, which it does once the site's page has one: `deploy/config.json` then holds the member `shell`, as the design's §13 gives it, and step 6 installs it again:

```json
"shell": {
  "path": "/shell/session",
  "origins": ["https://ernest-lang.org"],
  "command": ["/home/httpd/ernest-httpd/shell.sh", "-it", "--rm", "--network", "none", "--read-only",
              "--cap-drop=ALL", "--security-opt=no-new-privileges",
              "--memory", "128m", "--pids-limit", "128", "--cpus", "1",
              "--mount", "type=tmpfs,destination=/home/shell,tmpfs-size=64m,U=true", "ernest-shell"],
  "most-at-once": 6,
  "starts": { "count": 10, "within": 3600000 },
  "lifetime": 300000, "warning": 60000,
  "message-limit": 65536, "hangup": 5000
}
```

The visitor's shell runs in a container of the image `ernest-shell`, built by `httpd` from `deploy/Containerfile` with the shell's start, `deploy/shell-start.sh`, and Ernest's archive beside it, the archive as `ern.tar.gz`, through the shell's wrapper, `deploy/shell.sh`, installed in the server's directory:

```console
httpd$ mkdir image && cp ernest_httpd-0.1.0/deploy/Containerfile ernest_httpd-0.1.0/deploy/shell-start.sh image/
httpd$ cp ern-0.10.0.tar.gz image/ern.tar.gz
httpd$ podman build -t ernest-shell image
httpd$ install -m 0755 ernest_httpd-0.1.0/deploy/shell.sh ernest-httpd/shell.sh
```

The image holds the two nodes' configuration directories under `/usr/local/share/ernest-shell/`, `a` and `foo`, and its command is the start, `/usr/local/bin/shell-start`, which copies both into the home, starts `foo` and, once it listens, runs the shell on `a`. A build whose `ernest.conf` did not take the limits stops at that `RUN` step, which exits with 1.

The image answers lines of Ernest, here from standard input, and the shell's command, at a terminal of the operator's, runs it through the wrapper as a visitor's session does, where `1 + 2` answers `3 : Int`, `Peer.computeAt("foo", fn() = 3 + 4, 5000)` answers `Right(7)` from the second node, after `the peer foo connected`, `Fs.write(Path("x"), <<1>>, 1000)` answers `Right(Unit)` in the size-capped home, and `:quit` leaves; `podman ps` then lists no container, nor does it after a terminal closed before `:quit`, within a second:

```console
httpd$ printf '1 + 2\nPeer.computeAt("foo", fn() = 3 + 4, 5000)\n' | podman run -i --rm --network none ernest-shell
httpd$ ernest-httpd/shell.sh -it --rm --network none --read-only --cap-drop=ALL \
      --security-opt=no-new-privileges --memory 128m --pids-limit 128 --cpus 1 \
      --mount type=tmpfs,destination=/home/shell,tmpfs-size=64m,U=true ernest-shell
httpd$ podman ps
```

A start whose `foo` did not listen says `foo did not start`, and the container ends with the status 1.

Without the wrapper, a command of `podman run` alone, the container outlives its visitor: `podman run` leaves running a container whose terminal hangs up, so each visitor's stop leaves one `Up`, which `podman ps` shows, and `podman rm -f -t 0` and its id removes. A wrapper run without the linger exits at once, `mktemp: failed to create directory via template`, since `/run/user/` and the user's number is not there.

`U=true` gives the tmpfs to the container's user; without it podman mounts it root's, mode 700, and Erlang, started in it, fails to read its own boot file, `File operation error: eacces. Target: no_dot_erlang.boot`.

## 8. The unit

```console
$ sudo install -m 0644 /home/httpd/ernest_httpd-0.1.0/deploy/ernest-httpd.service /etc/systemd/system/
$ sudo systemctl daemon-reload
$ sudo systemctl enable --now ernest-httpd
$ sudo journalctl -u ernest-httpd
```

An operator in the group `adm` or `systemd-journal` reads the journal without `sudo`. The journal says `listening on 127.0.0.1:8654`, the node's own listener, then `listening on 0.0.0.0:443`, `listening on :::443`, `listening on 0.0.0.0:80` and `listening on :::80`, in the configuration's order. A configuration the server refuses is said with its field, `/home/httpd/ernest-httpd/node/config.json: listeners[0].key must be readable by the program's user alone: "/home/httpd/ernest-httpd/node/privkey.pem"`, a port another server holds as `:::443: Io.Other("address already in use")`, and a directory of `ReadWritePaths` that does not exist, step 7's `podman info` not yet run, by systemd: `Failed to set up mount namespacing`, the status `226/NAMESPACE`.

The unit binds 80 and 443 as no root by `AmbientCapabilities=CAP_NET_BIND_SERVICE`, a capability that goes with systemd; a server without it says `0.0.0.0:443: Io.Denied: a port below 1024 needs CAP_NET_BIND_SERVICE`. A server run without systemd binds the two ports by `setcap cap_net_bind_service=+ep` on the BEAM binary `erl` runs, `/usr/local/lib/erlang/erts-*/bin/beam.smp`, the binary itself and not a link to it, redone at each install of OTP, a file capability putting the binary in secure-exec mode, which drops `LD_LIBRARY_PATH` and the like; authbind and privbind, root's helpers in front of `ern`, are not used.

Yaws' privbind page, https://upload.int.onexglobal.io/privbind.yaws, lists the ways a server that is not root binds a port below 1024, `setcap` on the binary, authbind, privbind and a sysctl among them, of which the unit's `AmbientCapabilities=CAP_NET_BIND_SERVICE` is systemd's own and `setcap` the fallback.

The unit's `ExecStartPre` runs `podman system migrate` as `httpd`, which ends podman's pause process of the instance before, whose private `/tmp` the restart deleted; without it a visitor's shell after a restart fails with `container create failed (no logs from conmon)`, and the journal has conmon's `Failed to generate random path for console-socket`. `systemctl reload ernest-httpd` reads the node's peers again, `ern reload`, and nothing of `config.json`, whose change is `systemctl restart ernest-httpd`; `systemctl stop ernest-httpd` ends the server in order, each shell closed with 1001.

## 9. The certificate

One certificate names the four hosts, issued by certbot in webroot mode against the challenge's directory, which the server's redirect listener serves on 80. The deploy hook, installed first, copies it into the node's directory and restarts the server:

```console
$ sudo install -D -m 0755 /home/httpd/ernest_httpd-0.1.0/deploy/certbot-deploy.sh \
      /etc/letsencrypt/renewal-hooks/deploy/ernest-httpd.sh
$ sudo certbot certonly --webroot -w /home/httpd/ernest-httpd/acme --cert-name ernest-lang.org \
      -d ernest-lang.org -d www.ernest-lang.org -d ernest-lang.se -d www.ernest-lang.se
$ sudo certbot renew --dry-run
```

certbot 3.2 and later runs the hook after the issue itself; an earlier one runs the hooks of the directory only at a renewal, `certbot --version` says which, and the hook then runs once by hand, `sudo /etc/letsencrypt/renewal-hooks/deploy/ernest-httpd.sh`. A name that does not lead to the server fails its challenge, `Invalid response from http://ernest-lang.se/.well-known/acme-challenge/...`, or `Connection refused` where nothing listens on 80.

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
```

The smoke test reads the checks it runs from `deploy/config.json`, the archive's own, whose rules but the file system's it checks, the files being the machine's; one it refuses is said with its path, `smoke: deploy/config.json: listeners is required`. A configuration with a shell, step 7's, adds a fifth line:

```console
https://ernest-lang.org:443/shell/session runs 1 + 2 and closes with 4004 at a stop: ok
```

A check that fails says what came, and `make smoke` then exits with an error: `failed: Io.Refused` where nothing listens; `failed: Io.Other("TLS client: ... Bad Certificate ...")` where the certificate is still step 6's or names another host; and for the shell, `failed: output "..." then WebSocket.Close(code = Some(4003), reason = "")` where no session is free, or the output podman wrote before the session closed where the container did not start.

## 12. Looking in

The operator's shell attaches to the server's node from the operator's directory, as the deployment guide of the installation, `share/doc/ernest/guide/deployment.md`, shows in its section 6, with an `ern` of the same archive as the server's. The operator installs that `ern` under a prefix of the operator's own, `~/opt/local`, as step 4 does under the server's, since the operator may not read the server's home, on the OTP step 3 installed for both; the superuser gives the archive, and the prefix's `bin` goes first on `PATH`:

```console
$ cd && export PATH=$HOME/opt/local/bin:$PATH
$ sudo install -o $USER -g $USER -m 0644 /home/httpd/ern-0.10.0.tar.gz ~/
$ tar -xzf ern-0.10.0.tar.gz && cd ern-0.10.0
$ make && make install PREFIX=$HOME/opt/local
$ cd && ern --version
ern 0.10.0+<commit>
```

`ern --version` prints step 4's line, the same commit. Each command fails as step 4's do, and `install` without the archive says `cannot stat '/home/httpd/ern-0.10.0.tar.gz': No such file or directory`. A shell begun later exports the `PATH` again, or puts `PATH=$HOME/opt/local/bin:$PATH` in front of the `ern` line. Then the attach:

```console
$ ern shell --config-dir ~/ops --attach node
the peer node connected
Ernest 0.10.0+<commit>, session 1. :help for the commands, :quit to leave.
> :processes
> :quit
```

`:processes` lists the server's processes, each by the site its spawn is written in, with its line, and what it does: the entry process, `ErnestHttpd.main`, receiving; the access log, spawned in `AccessLog.start`, and the sessions, in `Sessions.start`; each listener, spawned in `ErnestHttpd.listening`, and its acceptor, in `Listener.serve`; a connection for each socket a listener holds, spawned in `Listener`; and the sockets and listeners themselves, `Tcp.accept` and `Tcp.listen`.

A visitor whose shell runs has a session, spawned in `Sessions`, its program, `Os.startTerminal`, and its reader, spawned in `Session`; while the visitor's page is attached, the page's connection is a shell with its reader, spawned in `Shell.serve`. `:quit` leaves, and the server runs on. An attach that fails says why, `ern shell: the peer node is unreachable` where the server is not running, and `ern shell: the peer node is not listed` where step 5 did not list it.
