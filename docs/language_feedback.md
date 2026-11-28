# Language feedback

What writing Ernest felt against the principles, a line each, carried to Ernest as `CLAUDE.md`'s *The work* says.

The lines are numbered on from the thirty-four of the rounds before, all answered.

Line 35 was found on 2026-11-21 against `ern 0.10.0`, while Ernest's close that waits for its bytes was read against the program's closes; lines 36 and 37 were found on 2026-11-23 against `ern 0.11.0+93a13b13`, while the floor's rise timed the program's closes. Lines 45, 50 and 57 were found on the same day against the same, by the full review's readers at `f6bf173`, each naming the review's finding it comes from. Line 61 was found on 2026-11-26 against `ern 0.11.0+ab68ef61`, with item 17's build.

Ernest answered lines 35 to 60 on 2026-11-26 with `ern 0.11.0+ab68ef61`, and line 61 the same day on its release `ern 0.11.0`; the lines it built, and those it declined for reasons agreed with, are gone (the log's *Ernest's answers to lines 35 to 60*), and each that stays has its answer beneath it.

35. **Nothing ends a socket and drops what its host holds: after a close or a kill the bytes go on to a far end the program has given up.** E.18 has the bytes a socket has taken sent "while the far end takes them", however the socket ends, and dropped 5 seconds after the far end's last take or 3 minutes after the end. `Tcp` has no function that ends a socket without them.

    A probe on `ern 0.10.0` over ernest-httpd's plain listener on the loopback, `timeouts.write` 2000: a client asks for a 1 MiB file 33 times in one write and reads nothing. The connection closes at its write past the deadline (its design §6), and its place in the caps was free 2.1 s after the request. A client that still read nothing was reset 5.0 s after that. One that then read everything received 4.00 MiB, and one that read 256 kB every 3 s received the 4.00 MiB over 54 s.

    With `limits.connections` 16, three waves of 16 such clients came, each client reading 4 kB a second once it was given up. Every client of every wave was answered, the places of the wave before being free. The node, 107 MiB resident before, stood at 162 after the first wave, 207 after the second and 225 after the third, with 32 descriptors beyond its 18. It was back at 113 MiB 12 s after the clients stopped reading.

    So the program's caps count a connection until it gives the client up, and the host holds the megabytes after, where no cap of the program's counts them. Ernest's session says that its checkout has `close` answer once the bytes are with the kernel or dropped. The place is then held for that wait, 5 seconds against a client that takes nothing and E.18's 3 minutes against one that trickles, and a `kill` leaves the bytes as today.

    Principle 1: a reader predicts that a program which closes a connection at its deadline sends it nothing more. Principle 3: what a program holds for a connection is the program's to know and to end. Ask: `Tcp` gives a function that ends a socket at once and drops what its host holds, the far end reading a reset, and E.18 says so.

    Filed: Ernest's 270, its MVP 4.5's item 158, planned after the launch.

36. **A close after a failed TLS handshake waits 5 seconds with nothing to send, and E.18 does not say so.** E.18 has `close` answer at once where "its handshake over TLS has not ended", and otherwise once the socket's bytes and the record that ends the connection are with the kernel, or are dropped 5 seconds after the far end's last take.

    A probe on `ern 0.11.0+93a13b13` over the loopback: a client writes plain text to a listener of `listenTls`. The server's first read fails at once, `Left(Other("TLS server: In state hello ... unsupported_record_type ..."))`, and its `Tcp.close` then answers after 5,001 ms. It does so whether the client has read the server's 7-byte alert or reads nothing, in nine runs of nine, and it answers at once in the two where the client closed first. A `kill` of that socket in place of the close ends its process `Killed` after the same 5,001 ms, the process `Running` meanwhile and its descriptor open, in two runs of two, and at once where the client closed first, though E.18 has `kill` end a socket "as it ends any process".

    ernest-httpd's server shows it: a client that speaks plain HTTP to its port 443 holds its place in the caps 5 seconds past the failed read, and the test of a plain-text client of a TLS listener has its client close first, so that the close answers. Principle 3: when a close answers is the program's to know, and the page's one clause on a handshake reads as though a failed one answers at once. Ask: E.18 says what a close and a kill after a failed handshake wait for; and Ernest decides whether each ends the socket at once, as a close does where the handshake has not ended.

    Planned: Ernest's MVP 4.18, item 1, for 0.12.0, reproduced: the 5 seconds are the host's, its connection process reading up to its `alert_timeout` after an alert of its own.

37. **Over TCP a close that waits answers up to a second after the far end has read the last byte and the close, and E.18 does not say so.** E.18 has `close` answer "once the socket's bytes ... are with the kernel, or the bytes are dropped", and states a lag of up to a second for TLS alone: "Over TLS it reads the close, with the record that ends the connection, when the socket next looks at what the host holds, up to a second later".

    A probe on `ern 0.11.0+93a13b13` over the loopback: a server writes 4 MiB and closes, and its client reads every byte and the close within 4 ms; the server's `Tcp.close` answers 1,000 to 1,001 ms after it began, in five runs of five. Against ernest-httpd's server, a client of an 8 MiB response with `Connection: close` that begins to read 300 ms later reads the close 0.0 ms after the last byte, and the server's close answers after 1,001 ms, in three runs of three.

    So a connection holds its place in ernest-httpd's caps up to a second after a large response, which its client has long had. Principle 3: when a close answers is the program's to know. Ask: E.18 says when a close over TCP answers once the far end has taken everything, and Ernest decides whether it answers then.

    Planned: Ernest's MVP 4.18, item 1, for 0.12.0, reproduced: the second over TCP is the closer's look.

45. **A TLS handshake that fails at the certificate is the host's state and source line.** ernest-httpd's smoke test, dialing a site of a self-signed certificate, is answered `Io.Other("TLS client: In state wait_cert_cr at ssl_handshake.erl:2306 generated CLIENT ALERT: Fatal - Bad Certificate\n selfsigned_peer")` (the review's K24): the cause is the last word, after a line feed, behind a state and a file of OTP's, and the program can match on none of it. Principle 1 and principle 3. Ask: an error of `Io`'s own for a certificate that does not verify, with the host's reason in it.

    Filed: Ernest's 285, a cause told by a text, which names a handshake that fails at the certificate.

50. **A declaration is private or exported, and nothing between, so tests copy their fixtures.** Report §9: "`fn parse` ... is exported as `Net.Http.parse` when marked `export`; otherwise it is private to its module." ernest-httpd's tests copy a certificate and its key, 27 lines, into two modules, and a helper `next` into three; `Smoke` exports six test helpers, which `ern doc` shows as its interface (the review's C15 and C26). Principle 2. Ask: a declaration that a module's tests and its package's tests see and its users do not.

    Filed: Ernest's 308, no declaration between private and exported, which names these fixtures.

57. **The library has no WebSocket, so a program writes RFC 6455.** G.11's `Http` reads and writes HTTP/1.1 and offers no upgrade. ernest-httpd's `src/ernest_httpd/web_socket.ern` holds RFC 6455's framing, its close codes and its accept value in 550 lines before its tests, written as a library of Ernest's is (its design §10; the review's L17). A published specification is a library's work. Principles 2 and 5. Ask: a `WebSocket` beside `Http`.

    Planned: Ernest's MVP 4.18, item 6, decides where a library over a published specification lives.

61. **E.18 does not say whether `Tcp.ipAddress` reads an IPv4 part with a leading zero.** E.18 has `ipAddress(text)` answer "4 for an IPv4 address written as four decimal numbers". On `ern 0.11.0+ab68ef61`, where it was `Tcp.address`, it answers `None` for `192.0.2.07`, `01.2.3.4` and `000.0.0.0`. ernest-httpd counts an IPv4 address as written (its design §7), so were such a part read, one address would be counted under two texts, and its test of the texts that fault holds `192.0.2.07` on what the page does not state. Principle 3. Ask: E.18 says whether a part with a leading zero is read.

    Planned: Ernest's MVP 4.18, item 1, for 0.12.0, reproduced on `ern 0.11.0`: the host refuses a part with a leading zero, and E.18 gains the clause.
