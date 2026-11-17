# The agents

How a session works with its agents: what a brief holds, where an agent's report goes, what is checked before agents start and after they end, and the model each job gets. What goes to an agent, and that its report is a claim, is [`CLAUDE.md`](../CLAUDE.md)'s *The repository*, which has a session read this file before it starts its first agent. This file is the template's, as `CLAUDE.md` is.

## The brief

Code goes to an agent one build at a time, given its goal, the design's sections it builds and the check that proves it done.

A diagnosis that needs experiments goes to one agent with the failing case and what is ruled out, never the session's guess, and that agent owns the loop to a passing test.

Agents whose work is bound by the processor, a race's probe, a run under a sanitizer or a load test, run one at a time, and each runs its programs one after another: side by side is for work that waits or reads. The brief says so.

An agent follows `CLAUDE.md`, but a review's reader, whose brief stands in its place as [`full_review.md`](full_review.md)'s *How it runs* says. Its brief tells it in one line to leave untracked files alone, and to read Ernest's `guide/style.md` before it writes Ernest, as `CLAUDE.md`'s *Style* has it.

## An agent's report

Its report comes back to the user and is written to a file under the session's scratchpad, which a compaction keeps whole. A step of many commands, a release's, keeps its checklist in such a file too.

An agent drafts its log paragraph in that file and never edits the log: the session places it, so that the log keeps one voice and two agents never edit one file at once.

## Before and after

`git status --short` is read before agents start and compared after they end, untracked files among it.

An agent that dies leaves its processes running: they are looked for and killed by their process numbers, never by a pattern.

## The models

An agent is given its model and its effort when it is started.

The coding model runs at the stronger effort for a build in what a test shows least, a process's protocol, foreign code or what takes input from outside, for a diagnosis, and for a review's reader of the code. It runs at the lesser effort for any other build from a settled brief, re-run once at the stronger from a brief naming the failure and then returned to the session.

The stronger model, at the session's own effort, reads the documents in a review. The smallest model runs a search or a digest of long output that asks no judgment. A test run or a probe needs no model: the session runs it.

The models' names and their efforts are the session's memory's, not this repository's.
