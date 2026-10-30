# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it, `// design §n: ...`, and every `design §n` in a module's comment names a section; `make test` holds both.

## 1. What the program does

ernest-httpd serves one site, ernest-lang.org: its static pages, and one WebSocket per visitor that connects a terminal in the browser to a shell in a container on the server. What it implements of HTTP/1.1 and WebSocket, and what it leaves out, is `docs/proposals/basic/proposal.md`'s until the proposal is decided and this section states it as rules.

## 2. Processes

## 3. Modules

## Glossary

The names that recur across modules, one for each concept, in every module. A name the report states takes the report's; the names of the glossary of Ernest's `guide/style.md` hold here too.
