"""The write deadline's measurement: the server started on a scratch site with
a file of 1 MiB, N connections that each ask for the file and read nothing,
and the node's resident memory before, with the connections held, and after
they close; then one connection and the time until its write returns, as the
access log's line shows it. Each wait is on a condition with a deadline."""
import os, signal, socket, ssl, subprocess, sys, time

repo, measure, count = sys.argv[1], sys.argv[2], int(sys.argv[3])
log = os.path.join(measure, "access.log")
port = 18080
context = ssl.create_default_context()
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE
request = b"GET /big.bin HTTP/1.1\r\nHost: localhost\r\n\r\n"


def rss(pid):
    with open(f"/proc/{pid}/status") as status:
        for line in status:
            if line.startswith("VmRSS:"):
                return int(line.split()[1])  # kB


def tcp_mem_pages():
    with open("/proc/net/sockstat") as sockstat:
        for line in sockstat:
            if line.startswith("TCP:"):
                words = line.split()
                return int(words[words.index("mem") + 1])


def send_queues():
    out = subprocess.run(["ss", "-tnH", "state", "established", f"( sport = :{port} )"],
                         capture_output=True, text=True).stdout
    queues = [int(line.split()[1]) for line in out.splitlines() if line.strip()]
    return len(queues), sum(queues)


def lines():
    try:
        with open(log) as f:
            return sum(1 for _ in f)
    except FileNotFoundError:
        return 0


def wait(test, ms, what):
    deadline = time.monotonic() + ms / 1000
    while not test():
        if time.monotonic() > deadline:
            raise SystemExit("timed out waiting for " + what)
        time.sleep(0.01)


if os.path.exists(log):
    os.remove(log)
server = subprocess.Popen([os.path.join(repo, "bin/ernest_httpd"), os.path.join(measure, "config-tls.json")],
                          cwd=repo, stdout=subprocess.PIPE, text=True)
for _ in range(2):
    print(server.stdout.readline().strip())
pid = server.pid
try:
    # one whole GET read first, so that the modules it runs are loaded
    warm = context.wrap_socket(socket.create_connection(("127.0.0.1", port)), server_hostname="localhost")
    warm.sendall(request)
    got = b""
    while len(got) < 1048576:
        got += warm.recv(1 << 20)
    warm.close()
    wait(lambda: lines() >= 1, 5000, "the warm-up line")
    wait(lambda: send_queues()[0] == 0, 10000, "the warm-up connection's end")
    before = (rss(pid), tcp_mem_pages())
    print(f"before: VmRSS {before[0]} kB, TCP mem {before[1]} pages")

    rounds = int(sys.argv[4]) if len(sys.argv) > 4 else 1
    for round in range(rounds):
        print('round', round + 1)
        started = time.monotonic()
        sockets = []
        for _ in range(count):
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)
            s.connect(("127.0.0.1", port))
            s = context.wrap_socket(s, server_hostname="localhost")
            s.sendall(request)
            sockets.append(s)
        wait(lambda: lines() >= 1 + count * (round + 1), 30000, "every write's line")
        took = time.monotonic() - started
        held = (rss(pid), tcp_mem_pages())
        established, queued = send_queues()
        print(f"held: {count} connections, every write returned within {took * 1000:.0f} ms")
        print(f"held: VmRSS {held[0]} kB (+{held[0] - before[0]} kB), TCP mem {held[1]} pages "
              f"(+{(held[1] - before[1]) * 4} kB), {established} established, send queues {queued} bytes")

        for s in sockets:
            s.close()
        wait(lambda: send_queues()[0] == 0, 30000, "the connections' end")
        after = (rss(pid), tcp_mem_pages())
        print(f"after close: VmRSS {after[0]} kB (+{after[0] - before[0]} kB), "
              f"TCP mem {after[1]} pages (+{(after[1] - before[1]) * 4} kB)")

    one = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    one.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)
    one.connect(("127.0.0.1", port))
    one = context.wrap_socket(one, server_hostname="localhost")
    lines_before = lines()
    sent = time.monotonic()
    one.sendall(request)
    wait(lambda: lines() > lines_before, 30000, "the one write's line")
    print(f"one connection: its write returned within {(time.monotonic() - sent) * 1000:.1f} ms, "
          f"send queue {send_queues()[1]} bytes, VmRSS {rss(pid)} kB")
    one.close()
finally:
    os.kill(pid, signal.SIGTERM)
    print("server exited with", server.wait(timeout=30))
