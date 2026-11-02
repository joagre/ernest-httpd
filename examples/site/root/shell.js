// The shell page's script: xterm.js over the server's WebSocket, as design
// §11 of ernest-httpd has it. The terminal's bytes go each way as binary
// messages; the page's own messages are text, one JSON object each: the
// terminal's size at the open and at each change, which attaches the
// session and then resizes it, an extend and a stop. The server's one text
// message is the warning of the seconds left. At the close the status line
// says why, by the close code.
"use strict";

const path = "/shell/session"; // the configuration's shell.path
const reasons = {
    4001: "expired",
    4002: "taken over by another tab",
    4003: "unavailable",
    4004: "stopped",
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
let socket = null;
let restarting = false;

function connect() {
    const scheme = location.protocol === "https:" ? "wss://" : "ws://";
    socket = new WebSocket(scheme + location.host + path);
    socket.binaryType = "arraybuffer";
    statusLine.textContent = "connecting";
    socket.onopen = () => {
        statusLine.textContent = "connected";
        terminal.reset();
        sendText({ resize: [terminal.rows, terminal.cols] });
        terminal.focus();
    };
    socket.onmessage = (event) => {
        if (event.data instanceof ArrayBuffer) {
            terminal.write(new Uint8Array(event.data));
        } else {
            const message = JSON.parse(event.data);
            if ("warning" in message) {
                warn(message.warning);
            }
        }
    };
    socket.onclose = (event) => {
        warning.hidden = true;
        statusLine.textContent = reasons[event.code] || "disconnected, code " + event.code;
        if (restarting) {
            restarting = false;
            connect();
        }
    };
}

// What is sent while the socket is not open is dropped.
function send(data) {
    if (socket.readyState === WebSocket.OPEN) {
        socket.send(data);
    }
}

function sendText(message) {
    send(JSON.stringify(message));
}

// A key moves the session's end as an extend does, so it takes the warning
// down.
function sendKeys(bytes) {
    warning.hidden = true;
    send(bytes);
}

function warn(seconds) {
    const end = new Date(Date.now() + seconds * 1000);
    left.textContent = "The session ends at " + end.toLocaleTimeString() + " unless extended.";
    warning.hidden = false;
}

// A restart stops the session and connects anew at the close, or at once
// where the socket is closed already.
function restart() {
    if (socket.readyState === WebSocket.CLOSED) {
        connect();
    } else {
        restarting = true;
        if (socket.readyState === WebSocket.OPEN) {
            sendText({ stop: true });
        } else {
            socket.close();
        }
    }
}

terminal.onData((data) => sendKeys(encoder.encode(data)));
terminal.onBinary((data) => sendKeys(Uint8Array.from(data, (char) => char.charCodeAt(0))));
terminal.onResize((size) => sendText({ resize: [size.rows, size.cols] }));
window.addEventListener("resize", () => fit.fit());
document.getElementById("extend").addEventListener("click", () => {
    warning.hidden = true;
    sendText({ extend: true });
    terminal.focus();
});
document.getElementById("stop").addEventListener("click", () => sendText({ stop: true }));
document.getElementById("restart").addEventListener("click", restart);
connect();
