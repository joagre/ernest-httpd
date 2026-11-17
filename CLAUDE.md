# ernest-httpd — Claude Instructions

ernest-httpd is an Ernest program, the HTTP/1.1 server that serves ernest-lang.org; `README.md` says what it does. It builds against Ernest installed from a release archive, as a user installs it, and never against Ernest's source tree, and what the installation's documents leave opaque or unsaid is a line of `language_feedback.md`, never looked up in Ernest's source.

This file is the way of working, cut from Ernest's own. It is the template's, and *The repository* says how it changes.

## Authority

- **The language is Ernest's report and guide**, which the installation holds under `share/doc/ernest/`, and this repository changes neither. What the toolchain does is the report's §11; what the standard library offers, its Appendix E; what a library of Ernest's offers, its Appendix G.
- **The installation is the only Ernest this repository sees.** A session reads `share/doc/ernest/` and `man`, as a user does, and never Ernest's checkout, not when a page is opaque, badly described or silent. That is the finding, a line of `language_feedback.md` carried to Ernest, and reading the source would destroy it.
- **The design is the normative document of this program**: [`docs/design.md`](docs/design.md), with the plan item being built. Where the two differ, the design is corrected first.
- **Section 0 of the report, the five principles, is the measure in every design discussion.** Principles 2 to 5 construct, and principle 1 audits the result: where following them yields code that surprises, principle 1 overrides (§0). Every recommendation weighs the candidate against the five and names the principle that decided. The principles guide and are not law: each is weighed with judgment, and one applied too dogmatically yields (*Design*).

## Who owns each fact

Each fact has one owner. Every other document points at the owner and does not restate it.

| Owner | Owns |
|---|---|
| [`docs/README.md`](docs/README.md) | what each other document under `docs/` is, and each document it lists from outside `docs/`; each of them owns its subject |
| [`docs/design.md`](docs/design.md) | how the program is arranged: its processes, its types, what each module owns, and the glossary of its names |
| [`docs/plan.md`](docs/plan.md) | the roadmap and where we are |
| [`docs/log.md`](docs/log.md) | the rationale: why the design and the plan say what they say. Never normative |
| [`CHANGES.md`](CHANGES.md) | each release's note, newest first; [`docs/release.md`](docs/release.md) says how it is written, and `tools/docs.ern` holds its form |
| `deploy/README.md`, where `deploy/` exists | the operator's steps, from a machine to the smoke test passing, with the files of `deploy/` as each is installed |
| `examples/README.md`, where `examples/` exists | the example programs, by topic, with what each shows and how each is run |
| the code and its tests | what is built |
| `language_feedback.md`, under `docs/` from its first line | what writing Ernest felt against the principles, a queue of lines; *Defects and gaps* says how a line is written and when it goes |
| `findings.md`, under `docs/` while a review's findings are open | the findings, each line until a plan item decides it; it goes when every line is done, dropped or planned |

**Proposals.** `docs/proposals/` holds what is designed, a directory for each: the proposal, its reasons, what other systems do, and its experiments or programs. Each directory's `README.md` says what its files are and which is current.

Until a proposal is decided all of it is tentative.

A proposal refused or not taken up stays, its README's status line saying which. A built one stays as the record of its design until its milestone's release, its status line saying so.

Before that release, an item of the milestone that built the proposal reads it for what it holds that no owner has yet, in a reading decided with the user, and that goes to `docs/design.md` or the log. The same item removes the directory, once the milestone's row names the log entries that argue it and nothing else cites the directory.

**Where a sentence goes.** Decide the owner before you write. What will be built and when goes in the plan, and why goes in the log; a paragraph that does both is split at that line. A decision the user must see goes in the plan, in one sentence, with the design section that states it and the log entry that argues it. A finished milestone is a row of the plan's table, naming the log entries that argue it.

## The repository

- The program is Ernest, written for one floor of `ern`, which the Makefile names. That `ern` is installed from a release archive of Ernest's, as a user installs it, and never from a checkout.
- `make` builds, `make test` tests and `make run` runs; [`README.md`](README.md)'s *Building* names the rest.
- Everything the program loads beyond Ernest's own, the standard library and its libraries, stands under `lib/`. `make lib` fills it with each dependency, as its release archive unpacks, and with each Erlang application the program stands on. Such an application is a read-only git submodule under `erl/`, pinned and never copied, built by its own `make`.
- This file, `docs/agents.md`, `tools/docs.ern` and `docs/full_review.md` are the template's, `ernest-template`'s, and change there. A copy takes each again whole: this file but for its title and the sentence under it, and the review but for the readers the copy added. A good rule found here goes to the template first, by its issue tracker, or, for an application built in Ernest's clean room, by a message to Ernest's session. From the template it goes to the other copies, and to Ernest's own file where it applies there.
- Work in the main checkout, on `main`, with no worktree and no branch of a session's own: the user reads and edits this checkout. The one exception is the fresh clone that `make test` runs in, a plan item's (*Tests*), a release's or a review's.
- The session is for design, reasoning and coordination, and code is written by agents. The session diagnoses, writes each brief, reads each diff back and decides. The session itself makes an edit that adds no function and no test: a sentence, a one-line fix or a version, since a short dependent chain costs more through an agent.
- An independent reader, a job the discussion should not wait for, and work that can run side by side go to agents too. An agent has one job, and its report is a claim: the session reads its diff and runs the check before reporting the work done.
- Before a session starts its first agent it reads [`docs/agents.md`](docs/agents.md): what a brief holds, the model and the effort each job gets, and what is checked before agents start and after they end.
- An untracked file the session did not write is the user's: no session edits it, commits it or builds on it.
- Every session runs on the stronger model, since the design, the weighing against the five principles and the read-back have no test to catch their errors. Its agents run on the models `docs/agents.md` names.
- The session keeps conclusions in its context and not working material. It takes an agent's report from its file and a test's exit status and failures, and reads no file just to follow along.
- Where one pass must be right with nobody reading along, a design's section or a large read-back, the user is asked to raise the session's effort, in one line saying why and when to come back down.
- Context is most of what a session costs, so sessions stay short and the thinking stays strong. One item, one session: `/clear` follows the item's report to the user, and the plan, the log, the commit and a scratch file hold what matters. Each suggestion of `/clear` gives, word for word, the message to send after it. A large session is finished or compacted before a long break, since the next message past the cache's life rebuilds it.
- Where a check that costs cycles and one that costs tokens would find the same thing, the one that costs cycles runs: a full test run, a probe or a make target before a reader or a rework.
- A commit names its paths, `git commit -F message -- path...`, never a bare `git commit` after `git add`. The user stages their own work while a session runs: read `git status --short` first for entries that are not yours, and leave the index as the user left it, but for a new file of the session's own and a deletion (*Tests*, *Done*). The message says what changed in one or two sentences and points to the log or the plan for why, restating neither. It carries no attribution line, no co-author and no session link: this file says who works here.

## Before code

- **The design changes first.** An anomaly found while building changes `docs/design.md`, then the log, then the code. Name the design's section a module implements before writing it.
- **A design is discussed in its proposal until the user says it is ready.** Until then bring nothing of it to the plan, the log or the design. At a pause offer another reading back or a harder question: the principles, a real program written against it, the operator's day.

  A proposal, or a plan section written over one, is reported ready only after it has been read, unasked, against every owner it touches: the design's sections it changes or cites, the plan's items for it, and each proposal it meets at a seam. A seam is read from both sides, so that what one requires the other provides and no fact stands twice. The report to the user names the owners read.
- **A no-brainer is stated and made; everything else is discussed first.** A change to the design or the plan that nobody would argue about once it is read is made, with its argument, and reported under *Design conformance*. Any other, a wider rule than the one agreed, another error's text or a finding of the session's own among them, is brought to the user before it is written, with a recommendation and its reason, and discussed carefully.

  A design question is discussed one at a time, in prose, the argument before the verdict, with a recommendation. Smaller decisions come as a numbered list, with a recommendation each.

  A session opened to discuss alone writes nothing until the user asks. Then each write to the plan or the log is named in one line before it is made. A "go" covers the piece just discussed and not the topic. Where more rounds are coming, the writes are gathered into one commit at a pause, the end of a topic and not each verdict, by their paths. A proposal's commit is pushed then.
- **One issue at a time, or a few.** A round of findings, a build's brief and a message to the user each take one issue, or a few that belong together, never everything at once. What waits stands in the findings file or the plan meanwhile.
- **Once a build has started, the sentences it builds to do not change until it is back.**
- **Where a step looks wrong, say so once, hard**: the verdict, the principle that decides, the argument. A plan's item, the user's own idea and a suggestion of the session's own are steps too: before work starts on one, say whether it is worth doing, and say no where it is not. If the user insists, build it whole, and the log entry records the decision with the argument against it. The code carries no trace of the dissent.
- **A finding is argued only after the log and the program.** The log is searched for the decision a finding may sharpen, and the program that shows it is run in the session. A verdict recommended on a reader's probe alone says so. A batch of findings that changes what the program refuses, prints or exits with is run over the repository's own programs and tests, once a batch before it is decided.
- **Leave no decision pending.** A question that waits for the user stands in the plan as a named decision in a named milestone, never as "open".

## Design

- **Prefer minimal, direct implementations** over speculative abstraction. A feature enters or stays out by the five principles, and the log names the principle that decided (§0, principle 5).
- **Bring options, not defenses.** When a simplification seems to conflict with a principle, first check whether the principle is being applied too dogmatically. Then bring the ways the simplification could be made, not a defense of what stands.
- **A defense names its attacker.** A rule or a check against a hostile or broken input says who can make that input and what they could do without it. Where they could already do more, it is a robustness fix: one guard at the cause, one sentence, and no rule for each place.
- **The tools are fast.** A test or a tool that costs more than its work is a defect: measure it. Every run is timed against its work, and one that costs more is named to the user in the same message.
- **The program is lean.** Memory counts as much as time. A run and each resource it opens hold only what their work needs. What would be held in every run for a rare case is a cost every run pays, and is weighed as one.
- **The program is beautiful, inside and out.** Keep no code only to make it go faster. Measure first, and where the plain form is fast enough it stays plain.
- **A measurement ends when its number stops deciding anything.** A number that confirms the plain form goes to the log once, and its item closes. Following it further is an item of its own, planned with the decision it would change.
- **No fixed sleep, in the code or in a test.** A process waits on what it means: a message, a monitor, a port that answers, a process's end, or a deadline the design states.
- **The program is Ernest.** `foreign` is only what the host alone can do, and nothing is written in Erlang meanwhile. A function the library lacks is written in Ernest where Ernest can express it, and waits where only the host can, as *Defects and gaps* says.
- **A shim is written with the host's page open.** Where the program wraps a host library, an operation a host function does exactly is a `foreign fn` over it. Where one almost does, Ernest closes the difference around the call. The function's arguments, edge cases and errors are carried into the Ernest contract, and what its page leaves unsaid is tried against the host before the design states it. The prose is the program's own; nothing is copied.

## Defects and gaps

- **No warts.** Never leave an approximation, a silent deviation from the design, or an unstated semantic choice in the code.
- **Nothing routes around a defect or a gap**, the program's own or Ernest's. Code that meets one does not work around it, and does not hide it by choosing another example. A sentence that teaches a way around the program or Ernest, "the shortest way to", "write it as ... instead", is such a gap with its workaround beside it. Stop and say so: the gap takes its path, the next rule's.
- **A gap has one path.** It is said to the user at once. A defect of the program's own is fixed when found. One too large to fix now, or not yet diagnosed, goes in the plan with the date it was found and the shape of its fix, never in a comment.

  A gap the program meets in Ernest is fixed in Ernest, in its next release. What writing Ernest felt against a principle is such a gap: a workaround, a second way, something invisible, a function the library lacks, a form the code repeats at site after site, a refusal, a line the tool should say or a defect of the toolchain. It is a line of `language_feedback.md`, written as a change request: the finding, the program that shows it, the principle, and the ask.

  One gap of Ernest's does not wait. A function the library lacks, which Ernest can express over what the library has, is written in the program, and its line names it. It goes when a release brings the library's own. Every other gap waits: what needed the line stands in the plan, and nothing here goes around it.

  The user carries a line to Ernest by its issue tracker. For an application built in Ernest's clean room, the session carries it by a message to Ernest's session. Ernest's verdict comes with its next release, which the session installs and checks each verdict against. A line the release answers goes, the log citing Ernest's number. One not answered, or not agreed with, stays, the verdict and the reason beneath it. The file goes when it is empty.
- **A function over the library's types is weighed before it is written.** A private function whose type names no type of the program's own is read against the admission rules of the report's Appendix E.0, as the installation holds them. Where a rule admits it, it is a function the library lacks: it is written in the program and its line is written, as the gap's path says. Where none admits it, it stays the program's, and no line is written. The reading is a first cut, and the verdict is Ernest's.
- **A refusal is a decision.** One the design states was decided, and its log entry weighs it on the principles. One whose only reason is how the code was built was never decided: when found, it is brought to the user and weighed.
- **Memory that no collection reclaims is a defect, fixed at its cause.** Never fix it by capping a list, a table or a cache.
- **A published specification or a general-purpose engine is a library's work**: a pattern language, a data format, a protocol, dates and times. Where the program finds itself writing one, stop. Whether it becomes a library of the program's own, a dependency, or an ask of Ernest is decided with the user first.
- **Where the design is silent on what a user meets, add a sentence to the design**: one that says what the input means, or one that says it is refused, with its error. Never accept the input silently. A corner no user meets gets a test and no sentence.

## Tests

- **A test lives in the module it tests**, a `let` of type `Test.Case(m)` (Appendix E.24). `test/` holds only a program run end to end, as Ernest modules `ern test` runs. Every section of `docs/design.md` has a test whose comment names it, `// design §2: ...`, and every exported function has a test. The comment is no doc block, which would put the test on the module's page.
- **A test written after the code is a regression test.** Its comment says so and names what it does not cover.
- **A flake is tested under what it was seen under**, its load or its machine. A green run under anything else says nothing of it, and a cause not found is reported as not found.
- **A flake is hunted for two hours at most**, under what it was seen under, and the hunt ends at its first sighting. One that does not show is closed as not reproducible, its log entry naming the test and what it wrote, and is opened again where it shows again. Where a probe makes the failure at will, it shows the cause and the fix, and no hunt follows. Where none can, the hunt runs to its third sighting, and the hunt after the fix runs three times the runs one sighting took.
- **A timing test that fails under another session's load is run again, not hunted.** A timing test is one whose failing assertion compares a measured time, or a ratio of measured times. The failure's text is read first: a test whose wait ran out of its deadline is no timing test but a flake, whatever the load. When a timing test fails, the session reads the machine's load. Where another session made the load, the failure is said to the user with the load, and the test runs again on a quiet machine. Where it passes there, a log line naming the test and the load closes it, and no hunt follows. Any other test that fails under that load is a flake, and the rules above hold.
- **A long run's first step is checked alone.** A step a long run rests on, a pull or a build, is checked in a call of its own before the run starts.
- **`make test` runs before every commit.** Where a plan item touched the build, it runs from a fresh clone as well, after the item's closing commit and before the report to the user.
- **A new file is staged with `git add` before its check runs**, since the documents' test reads tracked files alone.
- **Readers run before a release**, as [`docs/release.md`](docs/release.md) says. A finding is fixed, planned or dropped, and the commit messages say which. The full review's readers read every area whole, on the user's word, as [`docs/full_review.md`](docs/full_review.md) says.

## Writing

- **`docs/design.md` is tight, in a Wirth language report's register.** State the rule; no rationale, no restating. Clear before short.
- **User-facing text has no project timeline.** The README, the manual pages and every text the program prints name no milestone, no plan item and no date of the project's history. They say what the program is at the release they ship with. The one exception is a library's `since` line, the release a part arrived in. The history is `CHANGES.md`'s, the log's and the plan's.
- **A comment names no milestone, plan item, review finding or date**, since each points into a document that deletes it. It cites the design's section, and the log entry by its title where the history matters. A regression test still says it is one.
- **Every document but `docs/design.md` is plain and short**, the plan, the log, a proposal, a commit message, a message to the user and this file among them. One point to a sentence, in the order a reader needs it.
- **A paragraph is one turn of the text**, in every document and in a message to the user. A paragraph past about a hundred words is read again for a turn it may hide, and left whole where it holds one thing. Past 150 words a paragraph always hides a turn, since no reader takes it in whole. `make test` refuses it, the log, a proposal and a manual page aside, and the writer finds the turn and splits there before the commit.
- **An edit to a set that documents name changes every place that holds it.** Such a set stands in more than one place: a list, a count, a section that restates it. An edit to the set reads the whole page first and changes every such place, the README's and the plan's among them, in the same commit.
- **A log that nears 250 KB is split by day**: `docs/log/`, a file a day, its `README.md` the index, since GitHub stops rendering a file near 300 KB and says nothing. The template's tool and this file name `docs/log.md`, so the session tells the user first, and the split waits for the template's change.
- **The spelling is American English**, in every document, name and message.
- **No document or message names who proposed an idea**, or that person's role; it states the argument.

## Done

In this file "the report" alone is Ernest's, the language's. The session's is "the report to the user", and an agent's is "its report".

- **Read the result back before reporting it.** The session reads each diff as its agent returns it (*The repository*). At an item's close it reads what the item made as a reader who knows Ernest would, against the principles and the design, and says what surprised.

  The reading at an item's close runs two searches over the Ernest the item wrote, each over the sources with its count, never by the feel of one site. One looks for a form the code repeats, which is a line of `language_feedback.md` with its count. The other looks for a private function whose type names no type of the program's own (*Defects and gaps*).

  Decide every surprise: act on it in the same item or leave it with its reason, and record it where its owner keeps it. One that needs the user goes to the user with a recommendation in the same report to the user.
- **Hard work is done, and stupid work is not.** Nothing is left, or recommended left, for its size or its difficulty: where it is right it is done in the item, or planned. Work is left only where it would hold nothing, decide nothing and remove nothing, and the reason given is that one, never the cost.
- **A report to the user names each thing that remains**, specific enough to act on or to drop, and says nothing where there is none.
- **A step forward sweeps what it leaves behind.** What a step makes redundant goes in the step's own commit, never left for a review to find: a sentence, a file or a directory, a decided finding, a citation of what went. Every sentence elsewhere that says the item still waits goes too. A done item's paragraph goes, one line naming its log entry in its place until the milestone's row takes it.
- **Commit only after the checks pass**, on make's own exit status read in a call of its own, never chained after them and never on a pipe's, which a `grep` of the output would give. A deletion of tracked files is staged with `git rm` before its check runs, and committed with the item. Push only when the user says so, a proposal's pause excepted (*Before code*).
- **Every message that reports an item that touched the design, the plan or an error's text ends with a "Design conformance" section**: the sections of the design applied; every place the design was silent and what was done, or "none"; every deliberate omission, with the plan item that lifts it; and every line added to `language_feedback.md`, or "none". A message that reports any other item says in one line that the design was not touched.
- **Stop after each plan item.** Finish it whole, report it, and wait. The next step the report to the user names is the plan's next item, in the order the plan gives.

**Closing an item.** Each line names a rule of this file.

1. The design first (*Before code*).
2. Every question decided, every defect not fixed in the plan, and every gap of Ernest's in `language_feedback.md` (*Before code*, *Defects and gaps*).
3. Every section built cited by a test, and a test written after the code called a regression test (*Tests*).
4. A new name in `docs/design.md`'s glossary (*Style*).
5. The result read back, and every surprise decided (*Done*).
6. `make test` green (*Tests*).
7. One commit by its paths, sweeping what the item made redundant (*The repository*, *Done*).
8. The report to the user, ending with *Design conformance* where it is due, then a stop until the user's word; a push only on that word (*Done*).

## Style

Ernest's `guide/style.md`, installed as `share/doc/ernest/guide/style.md` beside `ern`, holds the rules an Ernest program is written by. It is Ernest's own, read from the installation and not copied here. It is read before any Ernest is written, by a session and by an agent, whose brief says so.

This program's own names are `docs/design.md`'s glossary, living: a name that comes to recur across modules goes in it in the commit that writes it, and is used as it stands.
