# ernest-httpd — Claude Instructions

ernest-httpd is an Ernest program, the HTTP/1.1 server that serves ernest-lang.org; `README.md` says what it does. This file is the way of working, cut from Ernest's own; it changes in the template, `ernest-template`, and is copied from there.

## Authority

- **The language is Ernest's report and guide**, which the installation holds under `share/doc/ernest/`, and this repository changes neither. What the toolchain does is the report's §11; what the standard library offers, its Appendix E; what a library of Ernest's offers, its Appendix G.
- **The installation is the only Ernest this repository sees.** A session reads `share/doc/ernest/` and `man`, as a user does, and never Ernest's checkout, not when a page is opaque, badly described or silent: that is the finding, a line of `language_feedback.md` carried to Ernest, and reading the source would destroy it.
- **The design is the normative document of this program**: [`docs/design.md`](docs/design.md), with the plan item being built. Where the two differ, the design is corrected first.
- **Section 0 of the report, the five principles, is the tiebreaker** in every design discussion. Principles 2 to 5 construct; principle 1 audits the result. Every recommendation weighs the candidate against the five and names the principle that decided.

## Who owns each fact

Each fact has one owner. Every other document points at the owner and does not restate it.

| Owner | Owns |
|---|---|
| [`README.md`](README.md) | what the program is, how it is built, tested and run, and what each document is |
| [`docs/design.md`](docs/design.md) | how the program is arranged: its processes, its types, what each module owns, and the glossary of its names |
| [`docs/plan.md`](docs/plan.md) | the roadmap and where we are; a finished milestone is a row of its table, naming the log entries that argue it |
| [`docs/log.md`](docs/log.md) | the rationale: why the design and the plan say what they say. Never normative |
| [`docs/release.md`](docs/release.md) | what a release runs to be ready |
| [`CHANGES.md`](CHANGES.md) | each release's note, newest first, from the first release on: what the release is and one line a change naming where it is read, restating nothing; the release step writes it and copies it to the release on GitHub |
| `examples/README.md`, where `examples/` exists | the example programs, by topic, with what each shows and how each is run |
| Ernest's `guide/style.md`, installed as `share/doc/ernest/guide/style.md` beside `ern` | the rules an Ernest program is written by, Ernest's own, read from the installation and not copied here |
| the code and its tests | what is built |
| `language_feedback.md`, under `docs/` from its first line | what writing Ernest felt against the principles, a line each, in the shape of Ernest's file of that name, a queue: a line is carried there by copy, the log here cites Ernest's number, and the line then goes; the file goes when it is empty |
| `findings.md`, under `docs/` while a review's findings are open | the findings, each line until a plan item decides it; it goes when every line is done, dropped or planned |

**Proposals.** [`docs/proposals/`](docs/proposals/) holds what is designed, a directory for each: the proposal, its reasons, what other systems do, and its experiments or programs. Each directory's `README.md` says what its files are and which is current.

Until a proposal is decided all of it is tentative, and nothing flows from it into the design, the plan or the log.

A built proposal is kept as the record of its design, its status line saying so, until its milestone's row names the log entries that argue it and nothing else cites the directory; then it goes, after a reading decided with the user of what it holds that no owner has yet, an experiment's finding or a table of what other systems do, which goes first to `docs/design.md` or the log.

A `scratch/` directory inside a proposal's own directory, untracked, is the user's own thinking: no session edits it, commits it or builds on it.

**Where a sentence goes.** Decide the owner before you write. What will be built and when goes in the plan; why goes in the log; a paragraph that does both is split at that line. A decision the user must see goes in the plan, in one sentence, with the design section that states it and the log entry that argues it.

## The repository

- The program is Ernest, written for one floor of `ern`, which the Makefile names, installed from a release archive of Ernest's and never from a checkout, as a user installs it. A gap the program meets in Ernest, a function the library lacks, a refusal, a line the tool should say, goes to Ernest's repository first, a line of its language feedback document, and is fixed there, the archive made again; nothing here works around it meanwhile. `make` builds; `make test` tests; `make run` runs; [`README.md`](README.md)'s *Building* names the rest. Everything the program loads beyond Ernest's own, the standard library and its libraries, stands under `lib/`, which `make lib` fills: each dependency as its release archive unpacks, and each Erlang application the program stands on, a read-only git submodule under `erl/`, pinned and never copied, built by its own `make`.
- Work in the main checkout, on `main`. No worktree and no branch of a session's own: the user reads and edits this checkout.
- A coding job of many steps goes to an agent, so that the discussion with the user goes on while it runs. The agent follows this file, and its report comes back to the user. An untracked file is the user's: `git status --short` is read before agents start and compared after they end, untracked files among it, and an agent is told in one line to leave them. An agent that dies leaves its processes running: they are looked for and killed by their process numbers, never by a pattern.
- The session runs on the user's default model. An agent is given its model and its effort when it is started, on the session's own judgment: the stronger effort for a build from a settled brief whose correctness a test and a diff show, the lesser for a mechanical job. The user is asked to raise the session's model only where one pass must be right with nobody reading along, in one line saying why and when to come back down.
- A commit names its paths, `git commit -F message -- path...`, never a bare `git commit` after `git add`. Read `git status --short` first for entries that are not yours, and leave the index as the user left it. The message says what changed in one or two sentences and points to the log or the plan for why. It carries no attribution line, no co-author and no session link: this file says who works here.

## Before code

- **The design changes first.** An anomaly found while building changes `docs/design.md`, then the log, then the code. Name the design's section a module implements before writing it.
- **A design is discussed in its proposal until the user says it is ready.** Until then bring nothing of it to the plan, the log or the design. At a pause offer another reading back or a harder question: the principles, a real program written against it, the operator's day.

  A proposal, or a plan section written over one, is reported ready only after it has been read against every owner it touches, unasked: the design's sections it changes or cites, each proposal it meets at a seam, read from both sides so that what one requires the other provides and no fact stands twice, and the plan's items for it; the report names the owners read.
- **State a change to the design or the plan and make it; do not ask.** Give the change and its argument, make it, report it under *Design conformance*. Stop and wait only where the answer decides what gets built and a guess would throw the work away: a design question, discussed one at a time, in prose, the argument before the verdict, with a recommendation. Smaller decisions come together, as one numbered list with a recommendation each.

  A session opened to discuss alone writes nothing until the user asks. Then each write to the plan or the log is named in one line before it is made, a "go" covers the piece just discussed and not the topic, and where more rounds are coming the writes are gathered into one commit at the pause.

- **Where a step looks wrong, say so once, hard**: the verdict, the principle that decides, the argument. If the user insists, build it whole, and the log entry records the decision with the argument against it. The code carries no trace of the dissent.
- **A finding is argued only after the log and the program.** The log is searched for the decision a finding may sharpen, and the program that shows it is run in the session; a verdict recommended on a reader's probe alone says so.
- **Leave no decision pending.** A question a step raises is decided in the same turn and recorded in the plan and the log. One that needs the user stands in the plan meanwhile as a named decision in a named milestone, never as "open".

## Design

- **Prefer minimal, direct implementations** over speculative abstraction. A feature enters or stays out by the five principles, and the log names the principle that decided (§0, principle 5).
- **Bring options, not defenses.** When a simplification seems to conflict with a principle, first check whether the principle is being applied too dogmatically.
- **The tools are fast.** A test or a tool that costs more than its work is a defect: measure it, and fix it at its cause or plan it with a date. Every run is timed against its work, and one that costs more is named to the user in the same message.
- **The program is beautiful, inside and out.** Keep no code only to make it go faster; measure first, and where the plain form is fast enough it stays plain.
- **A measurement ends when its number stops deciding anything.** A number that confirms the plain form goes to the log once, and its item closes; following it further is an item of its own, planned with the decision it would change.
- **No fixed sleep, in the code or in a test.** A process waits on what it means: a message, a monitor, a port that answers, a process's end, or a deadline the design states.
- **The program is Ernest.** `foreign` is only what the host alone can do, and nothing is written in Erlang meanwhile: a function the library lacks is written in Ernest or waits, as *Defects and gaps* says.
- **A shim is written with the host's page open.** Where the program wraps a host library, an operation a host function does exactly is a `foreign fn` over it, and where one almost does, Ernest closes the difference around the call; the function's arguments, edge cases and errors are carried into the Ernest contract, and what its page leaves unsaid is tried against the host before the design states it. The prose is the program's own; nothing is copied.

## Defects and gaps

- **No warts.** Never leave an approximation, a silent deviation from the design, or an unstated semantic choice in the code.
- **Fix a known defect when found.** A gap too large to fix now, or a defect not yet diagnosed, goes in the plan with a date and the shape of its fix, never in a comment.
- **Memory that no collection reclaims is a defect, fixed at its cause.** Never fix it by capping a list, a table or a cache.
- **Nothing routes around a defect or a gap of Ernest's.** Where writing Ernest feels against a principle, a workaround, a second way, something invisible, a function the library lacks or a defect of the toolchain, say so at once, add the line to `language_feedback.md` for the user to carry to Ernest, and discuss it before any code goes around it; what needed it says that it waits, in the plan. The program does not fork Ernest and does not work around it.
- **A refusal is a decision, and a workaround in prose is a gap.** A refusal the design states is weighed on the principles in its log entry; one whose only reason is how the code was built was never decided, and is weighed when found. A sentence that teaches a way around the program or Ernest, "the shortest way to", "write it as ... instead", is a gap with its workaround beside it, and goes as the rule above says.
- **A published specification or a general-purpose engine is a library's work**: a pattern language, a data format, a protocol, dates and times. Where the program finds itself writing one, stop; whether it becomes a library of the program's own, a dependency, or an ask of Ernest is decided with the user first.
- **Where the design is silent, add the sentence to the design or reject the input with an error.** Never accept it silently, and state the choice to the user.

## Tests

- **A test lives in the module it tests**, a `let` of type `Test.Case(m)` (Appendix E.24); `test/` holds only a program run end to end, as Ernest modules `ern test` runs. Every section of `docs/design.md` has a test whose comment names it, `// design §2: ...`, a comment and not a doc block, which would put the test on the module's page; and every exported function has one.
- **A test written after the code is a regression test.** Say so, and name what it does not cover.
- **`make test` runs before every commit**, and before the commit that closes a plan item the same from a fresh clone where the item touched the build. Edits to a proposal under discussion are committed at a pause, by their paths.
- **Readers run before a release**, as [`docs/release.md`](docs/release.md) says; a finding is fixed, planned or dropped, and the commit messages say which.

## Writing

- **`docs/design.md` is tight, in a Wirth language report's register.** State the rule; no rationale, no restating. Clear before short. The plan, the log, a proposal and a commit message are plain and short: one point to a sentence, in the order a reader needs it.
- **A paragraph is one turn of the text**, in every document and in a message to the user. A paragraph past about a hundred words is read again for a turn it may hide, and left whole where it holds one thing; one past 150 no reader takes in whole, so `make test` refuses it, and the writer splits it at its turn.
- **An edit to a set a document names reads the whole page first**, a list, a count or the sections that restate it, and changes every place that enumerates the set, the README's and the plan's among them, in the same commit.
- **The spelling is American English**, in every document, name and message.
- **No document or message names who proposed an idea**, or that person's role; it states the argument.

## Done

- **Read the result back before reporting it**, as a reader who knows Ernest would, against the principles and the design, and say what surprised. Decide every surprise: act on it in the same item or leave it with its reason, recorded where its owner keeps it.
- **A step forward sweeps what it leaves behind.** A sentence, a file or a directory that a step makes redundant, a done item's paragraph, which one line naming its log entry replaces until the milestone's row takes it, a built proposal, a decided finding, a citation of what went, goes in the step's own commit, never left for a review to find.
- **Commit only after the checks pass**, on make's own exit status read in a call of its own, never chained after them with `;` and never on a pipe's, which a `grep` of the output would give. A deletion of tracked files is committed by path at once, or stays staged until the test has run. Push only when the user says so, a proposal's pause excepted.
- **Every message that reports an item that touched the design, the plan or an error's text ends with a "Design conformance" section**, and a report of any other item says in one line that the design was not touched: the sections of the design applied; every place the design was silent and what was done, or "none"; every deliberate omission, with the plan item that lifts it; and every line added to `language_feedback.md`, or "none".
- **Stop after each plan item.** Finish it whole, report it, and wait.

**Closing an item.** Each line names a rule above.

1. The design changed first, and every question decided, every gap and needed decision in the plan with its log entry.
2. What writing Ernest felt against a principle in `language_feedback.md`, said at once and discussed before any code went around it.
3. Every section the item built cited by a test, and a test written after the code called a regression test.
4. A new name in `docs/design.md`'s glossary, used as the glossary has it.
5. The result read back, and every surprise decided.
6. `make test` green; the conformance section written; the same commit removes every sentence elsewhere that says the item still waits and sweeps what the item made redundant; then a commit that names its paths.
7. The report to the user, ending with *Design conformance* where it is due, then a stop until the user's word.

## Style

Ernest's `guide/style.md`, the owner table's, is read before writing Ernest in a session, from the installation beside `ern` or a checkout's `guide/`. This program's own names are `docs/design.md`'s glossary, living: a name that comes to recur across modules goes in it in the commit that writes it, and is used as it stands.

