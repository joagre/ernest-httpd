# Decisions

The dated rationale for the design and the plan, newest last, and what was rejected. Never normative: the design says what the program is, and the plan what is built when. An entry says what was decided, the principle of the report's §0 that decided it, and what would change it.

## Begun from the template

*2026-10-30.* The repository was begun from `ernest-template` at its tag `v0.8.1` and the commits after it to `c0055f5`, whose `CLAUDE.md` and `tools/docs.ern` are refreshed from there and not edited here. The way of working is the template's; a change to it goes to the template first.

## The proposal split from Ernest's

*2026-10-30.* The server's proposal was written in Ernest's repository from 2026-10-26, where the thinking happened, as one page with what the server asks of Ernest; when this repository was made it was split along the line of ownership: the server itself here, `docs/proposals/basic/proposal.md`, and what it asks of Ernest there, each citing the other by address. The principle is Ernest's rule of one owner for each fact: a change to Ernest's report cannot be owned here, and the server's own design cannot be owned there. The same split is Ernest's rule for every program that gets a repository of its own.

## Built against the installed Ernest

*2026-11-02.* The floor moved from 0.8 to 0.9 when Ernest's `make release` wrote 0.9.0, installed under a prefix as a user installs it, `make install PREFIX=...`; the Makefile and the README name it. Nothing of Ernest's checkout was read: the report, the style guide, the server example and the shell under the prefix were enough to write §4 and §5 and the modules, and what they left unsaid or the host answered badly is `docs/language_feedback.md`'s, four lines, carried to Ernest for a release that this repository installs the same way.

## Item 1: the configuration and the static site

*2026-11-02.* `Config` and `Static` are functions over their reads of the file system, as the plan's item 1 asked, each a section of the design written before its code and cited by its tests. What the sections left silent the build decided and wrote back as a sentence each: a top-level value that is no object is `the configuration`'s; members are checked by their names' code points and a row's rules in its order, since a `Map` keeps no source order; a target is read by code point; a scheme is RFC 3986's and an authority ends at `?` too; `..` is answered before a dot segment; a 301 has no body and its `Location`'s leading slashes are made one; a file asked for as a directory is 404; a `404.html` the file system refuses is 500.

Principle 1, least surprise, decided the two that matter. A reader predicts that `/` splits a path wherever it stands, but `String` matches by grapheme, and a `/` followed by a combining mark escaped the root through `Path.join`; the path is split by bytes. A reader predicts that a redirect stays on the site, but `//docs` written back as `Location: //docs/` names another host. Both are tests now. The rules on the configuration are every one the proposal's example implied and no more, a member of no field refused so that a misspelling is not silently ignored (principle 3); `shell` alone may be absent, since a static site costs nothing for a feature it does not use (principle 5). What answers 500 where 404 is due, a path through a regular file, a name too long and a loop of links, waits on `Fs` naming those cases, the plan's gap and the feedback's line 1.
