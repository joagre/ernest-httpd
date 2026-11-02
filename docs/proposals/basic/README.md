# The server

What each file here is, and which is current. All of it is under discussion, as CLAUDE.md says of a proposal: nothing flows from it into the design, the plan or the log until the proposal is decided.

| File | What it is | Status |
|---|---|---|
| [`proposal.md`](proposal.md) | the server: what of HTTP/1.1 and WebSocket it implements and leaves out, the live shell's server side, its limits, its security, its hosts, its modules, its tests, its configuration, its log and its life under systemd | current; written in Ernest's repository from 2026-10-26, read back 2026-10-30 and split here that day |
| [`measure/`](measure/) | the write deadline's measurement, `measure.py` over plain HTTP and `measure_tls.py` over TLS: `python3 measure.py <checkout> <dir> <count>` starts the checkout's server on `<dir>/config.json`, a `plain` listener on `127.0.0.1:18080` whose root holds `big.bin` of 1 MiB and whose access log is `<dir>/access.log`, opens `<count>` connections that each ask for the file and read nothing, and prints the node's resident memory before, with them held and after they close; the TLS script does the same on `<dir>/config-tls.json` | run 2026-11-02 for the log's *Item 6: the deployment*; run again when Ernest collects at a wait, the plan's paragraph of that name |

What the server asks of Ernest is Ernest's own proposal, https://github.com/joagre/ernest/blob/main/docs/proposals/httpd/proposal.md.
