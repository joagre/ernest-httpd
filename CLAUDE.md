# ernest-httpd — Claude Instructions

ernest-httpd is an Ernest program, the HTTP/1.1 server that serves ernest-lang.org; `README.md` says what it does.

This file is the way of working, cut from Ernest's own. It is the template's, and *The repository* says how it changes.

## Authority

- **The language is Ernest's report and guide**, which the installation holds under `share/doc/ernest/`, and this repository changes neither. What the toolchain does is the report's §11; what the standard library offers, its Appendix E; what a library of Ernest's offers, its Appendix G.
- **The installation is the only Ernest this repository sees.** A session reads `share/doc/ernest/` and `man`, as a user does, and never Ernest's checkout, not when a page is opaque, badly described or silent. That is the finding, a line of `language_feedback.md` carried to Ernest, and reading the source would destroy it.
- **The design is the normative document of this program**: [`docs/design.md`](docs/design.md), with the plan item being built. Where the two differ, the design is corrected first.
- **Section 0 of the report, the five principles, is the tiebreaker** in every design discussion. Principles 2 to 5 construct, and principle 1 audits the result. Every recommendation weighs the candidate against the five and names the principle that decided.

## Who owns each fact

Each fact has one owner. Every other document points at the owner and does not restate it.

| Owner | Owns |
|---|---|
| [`README.md`](README.md) | what the program is, and how it is built, tested and run |
| [`docs/README.md`](docs/README.md) | what each other document under `docs/` is, and each document it lists from outside `docs/`; each of them owns its subject |
| [`SECURITY.md`](SECURITY.md) | where to report a security hole |
| [`docs/design.md`](docs/design.md) | how the program is arranged: its processes, its types, what each module owns, and the glossary of its names |
| [`docs/plan.md`](docs/plan.md) | the roadmap and where we are |
| [`docs/log.md`](docs/log.md) | the rationale: why the design and the plan say what they say. Never normative |
| [`CHANGES.md`](CHANGES.md) | each release's note, newest first: what the release is, and one line a change naming where it is read, restating nothing. The release step writes it and copies it to the release on GitHub |
| `deploy/README.md`, where `deploy/` exists | the operator's steps, from a machine to the smoke test passing, with the files of `deploy/` as each is installed |
| `examples/README.md`, where `examples/` exists | the example programs, by topic, with what each shows and how each is run |
| Ernest's `guide/style.md`, installed as `share/doc/ernest/guide/style.md` beside `ern` | the rules an Ernest program is written by, Ernest's own, read from the installation and not copied here |
| the code and its tests | what is built |
| `language_feedback.md`, under `docs/` from its first line | what writing Ernest felt against the principles, a queue of lines; *Defects and gaps* says how a line is written and when it goes |
| `findings.md`, under `docs/` while a review's findings are open | the findings, each line until a plan item decides it; it goes when every line is done, dropped or planned |

**Proposals.** [`docs/proposals/`](docs/proposals/) holds what is designed, a directory for each: the proposal, its reasons, what other systems do, and its experiments or programs. Each directory's `README.md` says what its files are and which is current.

Until a proposal is decided all of it is tentative, and nothing flows from it into the design, the plan or the log.

A proposal refused or not taken up stays, its README's status line saying which. Only a built one goes.

A built proposal is kept as the record of its design, its status line saying so. It goes once its milestone's row names the log entries that argue it and nothing else cites the directory. First a reading, decided with the user, finds what it holds that no owner has yet, an experiment's finding or a table of what other systems do, and that goes to `docs/design.md` or the log.

A `scratch/` directory inside a proposal's own directory, untracked, is the user's own thinking: no session edits it, commits it or builds on it.

**Where a sentence goes.** Decide the owner before you write. What will be built and when goes in the plan, and why goes in the log; a paragraph that does both is split at that line. A decision the user must see goes in the plan, in one sentence, with the design section that states it and the log entry that argues it. A finished milestone is a row of the plan's table, naming the log entries that argue it.

## The repository

- The program is Ernest, written for one floor of `ern`, which the Makefile names. That `ern` is installed from a release archive of Ernest's, as a user installs it, and never from a checkout.
- `make` builds, `make test` tests and `make run` runs; [`README.md`](README.md)'s *Building* names the rest.
- Everything the program loads beyond Ernest's own, the standard library and its libraries, stands under `lib/`. `make lib` fills it with each dependency, as its release archive unpacks, and with each Erlang application the program stands on. Such an application is a read-only git submodule under `erl/`, pinned and never copied, built by its own `make`.
- This file, `tools/docs.ern` and `docs/full_review.md` are the template's, `ernest-template`'s, and change there. A copy takes each again whole: this file but for its title and the sentence under it, and the review but for the readers the copy added. A good rule found here goes to the template first, by its issue tracker, or, for an application built in Ernest's clean room, by a message to Ernest's session. From the template it goes to the other copies, and to Ernest's own file where it applies there.
- Work in the main checkout, on `main`, with no worktree and no branch of a session's own: the user reads and edits this checkout.
- A job the discussion should not wait for goes to an agent, and so do one whose bulky output only its conclusion needs, an independent reader, and work that can run side by side. The session does the rest itself, since a short dependent chain costs more through an agent. An agent has one job, and its report is a claim: the session reads its diff and runs the check before reporting the work done.
- An agent follows this file. Its report comes back to the user and is written to a file under the session's scratchpad, which a compaction keeps whole. A step of many commands keeps its checklist in such a file too. An agent drafts its log paragraph in that file and never edits the log: the session places it, so that the log keeps one voice and two agents never edit one file at once.
- An untracked file is the user's. `git status --short` is read before agents start and compared after they end, untracked files among it, and an agent is told in one line to leave them. An agent that dies leaves its processes running: they are looked for and killed by their process numbers, never by a pattern.
- A session has one kind of work, chosen when it opens, since a change of model cold-starts its cache. A design session, for the design, the weighing against the five principles and the design's sentences, runs on the stronger model, because no test catches its errors. An item session, for an item's diagnosis, its plan and log, its read-backs and its agents, runs on the lesser model at the stronger effort. Their names are the session's memory's, not this repository's. The session cannot change its own model, so it tells the user in one line when the work calls for the other kind of session, with the command that opens it, and again when the work can go back.
- An agent is given its model and its effort when it is started: the stronger effort for a build in what a test shows least, a process's protocol, foreign code, or what takes input from outside; the lesser for any other build from a settled brief, re-run once at the stronger from a brief naming the failure and then returned to the session; the lesser for a mechanical job with a test behind it; the stronger model for a review's reader and a cold reading of the design's sentences; the smallest model for a search that asks no judgment.
- Where one pass must be right with nobody reading along, a design's section or a large read-back, it runs in a design session, and the user is asked to raise that session's effort, in one line saying why and when to come back down.
- Context is most of what a session costs, so sessions stay short and the thinking stays strong. One item, one session: `/clear` follows its report, and the plan, the log, the commit and a scratch file hold what matters. A large session is finished or compacted before a long break, since the next message past the cache's life rebuilds it.
- Where a check that costs cycles and one that costs tokens would find the same thing, the one that costs cycles runs: a full test run, a probe or a make target before a reader or a rework.
- A commit names its paths, `git commit -F message -- path...`, never a bare `git commit` after `git add`. Read `git status --short` first for entries that are not yours, and leave the index as the user left it. The message says what changed in one or two sentences and points to the log or the plan for why. It carries no attribution line, no co-author and no session link: this file says who works here.

## Before code

- **The design changes first.** An anomaly found while building changes `docs/design.md`, then the log, then the code. Name the design's section a module implements before writing it.
- **A design is discussed in its proposal until the user says it is ready.** Until then bring nothing of it to the plan, the log or the design. At a pause offer another reading back or a harder question: the principles, a real program written against it, the operator's day.

  A proposal, or a plan section written over one, is reported ready only after it has been read, unasked, against every owner it touches: the design's sections it changes or cites, the plan's items for it, and each proposal it meets at a seam. A seam is read from both sides, so that what one requires the other provides and no fact stands twice. The report to the user names the owners read.
- **State a change to the design or the plan and make it; do not ask.** Give the change and its argument, make it, and report it under *Design conformance*. Stop and wait only where the answer decides what gets built and a guess would throw the work away.

  Such a case is a design question, and design questions are discussed one at a time, in prose, the argument before the verdict, with a recommendation. Smaller decisions come together, as one numbered list with a recommendation each.

  A session opened to discuss alone writes nothing until the user asks. Then each write to the plan or the log is named in one line before it is made. A "go" covers the piece just discussed and not the topic. Where more rounds are coming, the writes are gathered into one commit at the pause.
- **Where a step looks wrong, say so once, hard**: the verdict, the principle that decides, the argument. If the user insists, build it whole, and the log entry records the decision with the argument against it. The code carries no trace of the dissent.
- **A finding is argued only after the log and the program.** The log is searched for the decision a finding may sharpen, and the program that shows it is run in the session. A verdict recommended on a reader's probe alone says so. A batch of findings that changes what the program refuses, prints or exits with is run over the repository's own programs and tests, once a batch before it is decided.
- **Leave no decision pending.** A question a step raises is decided in the same turn and recorded in the plan and the log. One that needs the user stands in the plan meanwhile as a named decision in a named milestone, never as "open".

## Design

- **Prefer minimal, direct implementations** over speculative abstraction. A feature enters or stays out by the five principles, and the log names the principle that decided (§0, principle 5).
- **Bring options, not defenses.** When a simplification seems to conflict with a principle, first check whether the principle is being applied too dogmatically.
- **The tools are fast.** A test or a tool that costs more than its work is a defect: measure it, and fix it at its cause or plan it with a date. Every run is timed against its work, and one that costs more is named to the user in the same message.
- **The program is beautiful, inside and out.** Keep no code only to make it go faster. Measure first, and where the plain form is fast enough it stays plain.
- **A measurement ends when its number stops deciding anything.** A number that confirms the plain form goes to the log once, and its item closes. Following it further is an item of its own, planned with the decision it would change.
- **No fixed sleep, in the code or in a test.** A process waits on what it means: a message, a monitor, a port that answers, a process's end, or a deadline the design states.
- **The program is Ernest.** `foreign` is only what the host alone can do, and nothing is written in Erlang meanwhile. A function the library lacks is written in Ernest where Ernest can express it, and waits where only the host can, as *Defects and gaps* says.
- **A shim is written with the host's page open.** Where the program wraps a host library, an operation a host function does exactly is a `foreign fn` over it. Where one almost does, Ernest closes the difference around the call. The function's arguments, edge cases and errors are carried into the Ernest contract, and what its page leaves unsaid is tried against the host before the design states it. The prose is the program's own; nothing is copied.

## Defects and gaps

- **No warts.** Never leave an approximation, a silent deviation from the design, or an unstated semantic choice in the code.
- **Fix a known defect when found.** A gap too large to fix now, or a defect not yet diagnosed, goes in the plan with a date and the shape of its fix, never in a comment.
- **Memory that no collection reclaims is a defect, fixed at its cause.** Never fix it by capping a list, a table or a cache.
- **Nothing routes around a defect or a gap of Ernest's.** A gap the program meets in Ernest goes to Ernest first and is fixed there, in its next release. Where writing Ernest feels against a principle, a workaround, a second way, something invisible, a function the library lacks, a refusal, a line the tool should say or a defect of the toolchain, say so at once. Write the line in `language_feedback.md` as a change request: the finding, the program that shows it, the principle, and the ask.

  One gap does not wait. A function the library lacks, which Ernest can express over what the library has, is written in the program, and its line names it. It goes when a release brings the library's own. Every other gap waits: what needed the line stands in the plan, and nothing here goes around it.

  The user carries a line to Ernest by its issue tracker. For an application built in Ernest's clean room, the session carries it by a message to Ernest's session. Ernest's verdict comes with its next release, which the session installs and checks each verdict against. A line the release answers goes, the log citing Ernest's number. One not answered, or not agreed with, stays, the verdict and the reason beneath it. The file goes when it is empty.
- **A refusal is a decision, and a workaround in prose is a gap.** A refusal the design states is weighed on the principles in its log entry. One whose only reason is how the code was built was never decided, and is weighed when found. A sentence that teaches a way around the program or Ernest, "the shortest way to", "write it as ... instead", is a gap with its workaround beside it, and goes as the rule above says.
- **A published specification or a general-purpose engine is a library's work**: a pattern language, a data format, a protocol, dates and times. Where the program finds itself writing one, stop. Whether it becomes a library of the program's own, a dependency, or an ask of Ernest is decided with the user first.
- **Where the design is silent, add the sentence to the design or reject the input with an error.** Never accept it silently, and state the choice to the user.

## Tests

- **A test lives in the module it tests**, a `let` of type `Test.Case(m)` (Appendix E.24). `test/` holds only a program run end to end, as Ernest modules `ern test` runs. Every section of `docs/design.md` has a test whose comment names it, `// design §2: ...`, and every exported function has a test. The comment is no doc block, which would put the test on the module's page.
- **A test written after the code is a regression test.** Say so, and name what it does not cover.
- **A flake is tested under what it was seen under**, its load or its machine. A green run under anything else says nothing of it, and a cause not found is reported as not found.
- **`make test` runs before every commit.** Where a plan item touched the build, it runs from a fresh clone as well, after the item's closing commit and before its report.
- **A new file is added before its check runs**, since the documents' test reads tracked files alone.
- **Edits to a proposal under discussion are committed at a pause**, by their paths, and pushed then.
- **Readers run before a release**, as [`docs/release.md`](docs/release.md) says. A finding is fixed, planned or dropped, and the commit messages say which. The batches' design sentences are read cold, one reader over their diff, before the build starts: a sentence built on costs more to reword than one read. The full review's readers read every area whole, on the user's word, as [`docs/full_review.md`](docs/full_review.md) says.

## Writing

- **`docs/design.md` is tight, in a Wirth language report's register.** State the rule; no rationale, no restating. Clear before short.
- **Every other document is plain and short**, the plan, the log, a proposal, a commit message and this file among them. One point to a sentence, in the order a reader needs it.
- **A paragraph is one turn of the text**, in every document and in a message to the user. A paragraph past about a hundred words is read again for a turn it may hide, and left whole where it holds one thing. One past 150 words no reader takes in whole, so `make test` refuses it, the log, a proposal and a manual page aside, and the writer splits it at its turn.
- **An edit to a set a document names reads the whole page first**, a list, a count or the sections that restate it, and changes every place that enumerates the set, the README's and the plan's among them, in the same commit.
- **A log that nears 250 KB is split by day**: `docs/log/`, a file a day, its `README.md` the index, since GitHub stops rendering a file near 300 KB and says nothing. The template's tool and this file name `docs/log.md`, so the session tells the user first, and the split waits for the template's change.
- **The spelling is American English**, in every document, name and message.
- **No document or message names who proposed an idea**, or that person's role; it states the argument.

## Done

- **Read the result back before reporting it**, as a reader who knows Ernest would, against the principles and the design, and say what surprised. Decide every surprise: act on it in the same item or leave it with its reason, recorded where its owner keeps it.
- **A step forward sweeps what it leaves behind.** What a step makes redundant goes in the step's own commit, never left for a review to find: a sentence, a file or a directory, a built proposal, a decided finding, a citation of what went. A done item's paragraph goes too, one line naming its log entry in its place until the milestone's row takes it.
- **Commit only after the checks pass**, on make's own exit status read in a call of its own, never chained after them with `;` and never on a pipe's, which a `grep` of the output would give. A deletion of tracked files is committed by path at once, or stays staged until the test has run. Push only when the user says so, a proposal's pause excepted.
- **Every message that reports an item that touched the design, the plan or an error's text ends with a "Design conformance" section**: the sections of the design applied; every place the design was silent and what was done, or "none"; every deliberate omission, with the plan item that lifts it; and every line added to `language_feedback.md`, or "none". A report of any other item says in one line that the design was not touched.
- **Stop after each plan item.** Finish it whole, report it, and wait.

**Closing an item.** Each line names a rule of this file.

1. The design changed first, and every question decided, every gap and needed decision in the plan with its log entry.
2. What writing Ernest felt against a principle in `language_feedback.md`, said at once, and nothing gone around a gap that waits.
3. Every section the item built cited by a test, and a test written after the code called a regression test.
4. A new name in `docs/design.md`'s glossary, used as the glossary has it.
5. The result read back, and every surprise decided.
6. `make test` green, and the conformance section written where it is due.
7. A commit that names its paths. It sweeps what the item made redundant, every sentence elsewhere that says the item still waits among it.
8. The report to the user, ending with *Design conformance* where it is due, then a stop until the user's word.

## Style

Ernest's `guide/style.md`, the owner table's, is read before Ernest is written in a session, from the installation beside `ern`. This program's own names are `docs/design.md`'s glossary, living: a name that comes to recur across modules goes in it in the commit that writes it, and is used as it stands.
