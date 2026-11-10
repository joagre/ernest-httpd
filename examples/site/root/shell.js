// The shell page's script: xterm.js over the server's client, which design
// §14 of ernest-httpd states and the page imports from the server, at the
// configuration's shell.client. The terminal's keys go to the session and
// its output to the terminal; a page that joined a live session sends C-l,
// so that the shell draws its line again on the fresh terminal; a warning
// shows the time the session ends and an Extend button; and at the end the
// status line says why. The page's sentence on the session's life is
// written from the server's limits.
"use strict";

const words = {
    expired: "expired",
    takenOver: "taken over by another tab",
    unavailable: "unavailable",
    stopped: "stopped",
    lost: "disconnected",
};

const terminal = new Terminal();
const fit = new FitAddon.FitAddon();
terminal.loadAddon(fit);
terminal.open(document.getElementById("terminal"));
fit.fit();

const statusLine = document.getElementById("status");
const warning = document.getElementById("warning");
const left = document.getElementById("left");
const encoder = new TextEncoder();
let session = null; // the session under way, null once it has ended
let restarting = false;

// A session started at the terminal's size, its output written to the
// terminal; at its end a restart asked for starts the next.
function connect(client) {
    statusLine.textContent = "connecting";
    terminal.reset();
    const started = client.start(terminal.rows, terminal.cols, {
        output: (bytes) => terminal.write(bytes),
        attached: (joined) => {
            statusLine.textContent = "connected";
            if (joined) {
                started.keys(Uint8Array.of(0x0c));
            }
        },
        warning: warn,
        ended: (reason) => {
            warning.hidden = true;
            statusLine.textContent = words[reason];
            session = null;
            if (restarting) {
                restarting = false;
                connect(client);
            }
        },
    });
    session = started;
    terminal.focus();
}

// A key moves the session's end as an extend does, so it takes the warning
// down.
function sendKeys(bytes) {
    warning.hidden = true;
    session?.keys(bytes);
}

function warn(ms) {
    const end = new Date(Date.now() + ms);
    left.textContent = "The session ends at " + end.toLocaleTimeString() + " unless extended.";
    warning.hidden = false;
}

// A restart stops the session and starts anew at its end, or at once where
// it has ended already; a stop asked before the session is attached is the
// client's to order.
function restart(client) {
    if (session === null) {
        connect(client);
    } else {
        restarting = true;
        session.stop();
    }
}

// A duration of the limits in words: seconds where it is no whole number
// of minutes.
function spoken(ms) {
    const seconds = Math.round(ms / 1000);
    if (seconds % 60 !== 0) {
        return seconds === 1 ? "a second" : seconds + " seconds";
    }
    const minutes = seconds / 60;
    return minutes === 1 ? "a minute" : minutes + " minutes";
}

function loaded(client) {
    const { lifetime, warning: before } = client.limits;
    document.getElementById("lifetime").textContent =
        "It ends " + spoken(lifetime) + " after your last key or Extend, and this page warns you " +
        spoken(before) + " before.";
    terminal.onData((data) => sendKeys(encoder.encode(data)));
    terminal.onBinary((data) => sendKeys(Uint8Array.from(data, (char) => char.charCodeAt(0))));
    terminal.onResize((size) => session?.resize(size.rows, size.cols));
    window.addEventListener("resize", () => fit.fit());
    document.getElementById("extend").addEventListener("click", () => {
        warning.hidden = true;
        session?.extend();
        terminal.focus();
    });
    document.getElementById("stop").addEventListener("click", () => session?.stop());
    document.getElementById("restart").addEventListener("click", () => restart(client));
    connect(client);
}

import("/shell/client.js").then(loaded, () => {
    statusLine.textContent = "the client did not load";
});
