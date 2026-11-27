# ernest-httpd — Claude Instructions

ernest-httpd is an Ernest program, the HTTP/1.1 server that serves ernest-lang.org; `README.md` says what it does. It builds against Ernest installed from a release archive, as a user installs it, and never against Ernest's source tree, and what the installation's documents leave opaque or unsaid is a line of `language_feedback.md`, never looked up in Ernest's source.

This file holds what judgment cannot supply: what is the user's, who decides, and what the user wants of the work. Everything else is left to judgment. A document that a job needs is read when the job starts (*Read when the job starts*). The file is the template's, cut from Ernest's own, and *What is the user's* says how it changes.

A mistake adds no rule to this file. It gets an honest account when it happens, and a sentence here only where the user sees it come back.

## Authority

- **The language is Ernest's report and guide**, which the installation holds under `share/doc/ernest/`, and this repository changes neither.
- **The installation is the only Ernest this repository sees.** A session reads `share/doc/ernest/` and `man`, as a user does, and never Ernest's checkout, not when a page is opaque or silent. That is a finding, a line of `language_feedback.md`, and reading the source would destroy it.
- **The design is the normative document of this program**: [`docs/design.md`](docs/design.md). Nothing else in the repository overrides it.
- **Section 0 of the report, the five principles, is the measure** in every design discussion. A recommendation names the principle that decided. The principles guide and are not law: each is weighed with judgment.

## Where a fact lives

Each fact has one owner, and every other document points at it.

- **[`docs/design.md`](docs/design.md)**: how the program is arranged, and the glossary of its names.
- **`docs/log.md`**, or `docs/log/` once split by day: why the design and the plan say what they say. Never normative.
- **[`docs/plan.md`](docs/plan.md)**: what is built next, and where we are.
- **The code and its tests**: what is built.
- **[`CHANGES.md`](CHANGES.md)**: each release's note, newest first.
- **`known_issues.md`**, under `docs/` from its first line: what is known to be wrong or missing and not planned, a line each.
- **`language_feedback.md`**, under `docs/` from its first line: what writing Ernest felt against the principles, a line each, kept as *The work* says.
- **`findings.md`**, under `docs/` while a review's findings are open: the findings, a line each until it is done, dropped or planned.
- **`docs/proposals/`**: what is designed and not decided, a directory for each. Nothing in it is authoritative.

## What is the user's

- Work in the main checkout, on `main`, with no worktree and no branch.
- An untracked file the session did not write is the user's. Do not edit it, commit it or build on it.
- A commit names its paths, `git commit -F message -- path...`, and leaves the index as the user left it. Its message says what changed and points to the log for why. It carries no attribution line.
- Push only when the user says so.
- This file, `docs/agents.md`, `docs/build.md`, `docs/full_review.md`, `docs/release.md`, `tools/docs.ern`, the Makefile and the launcher are the template's, `ernest-template`'s, and change there. A copy takes each again whole: this file but for its title and the sentence under it, the review but for the readers the copy added, the release but for the steps the copy added, the Makefile but for its variables and the targets the copy added, and the launcher under the program's name. A rule found here goes to the template first, by its issue tracker.

## Who decides

- **The design changes first**, then the log, then the code.
- **Where the design is silent on what a user meets, it gains a sentence.** Input is never accepted silently.
- **The user decides the program.** A change to the design, an error's text or the plan that someone could argue with goes to the user first, with a recommendation and its reason. One that nobody would argue with is made and reported.
- **One question at a time**, the argument before the verdict.
- **Where a step looks wrong, say so once, plainly.** The user's own idea is a step too. If the user insists, build it whole.
- **A design stays in its proposal** until the user says it is ready. It is called ready only after it is read against each owner it touches.
- **A session opened to discuss writes nothing** until the user asks.
- **Stop after each item and wait**, unless the user has said to go on.

## The work

- **The session designs, reads and decides, and agents write the code.** A question about what Ernest or the code does is the session's own: it reads, and runs what the reading leaves open. [`docs/agents.md`](docs/agents.md) says how an agent is briefed, and is read before the first agent starts.
- **The program is Ernest, written for the release `package.conf` names**, the least it builds with. Until 1.0 a later release may refuse it, and the program then rises to that release. That `ern` is installed from an archive of Ernest's, a release or a candidate for one, as a user installs it, and never from a checkout. A commit that needs a release not yet published is pushed only once it is. What the program loads beyond Ernest's own is a package `package.conf` names, under `lib/`, which `make lib` fills, or an Erlang application under `erl/`.
- **Nothing routes around a defect or a gap**, the program's own or Ernest's. A defect of the program's that a first user meets is fixed when found, or is an item of the plan. A gap in Ernest is said to the user at once and is a line of `language_feedback.md`: the finding, the program that shows it, the principle and the ask. Nothing is written around it meanwhile, but for a function the library lacks that Ernest can express over what the library has: it is written in the program, and its line names it.
- **A line of `language_feedback.md` is carried to Ernest as an issue**, which the session files by the form of Ernest's tracker that fits it, Defect or Feedback. The issue holds the line whole, the program in it, and the line shrinks to a pointer naming the issue's number until the issue closes. A security hole is never an issue, and goes as Ernest's `SECURITY.md` says. A line whose issue a release answers goes, the log citing the number, and one whose verdict is not agreed with stays, the verdict and the reason beneath it, and is answered on the issue.
- **What a first user meets is built first.** It is asked of each item when it is written and before it starts. A corner that must be built on purpose to be met gets its line in `known_issues.md`, and becomes an item when the user takes it up.
- **Nothing is left for its size or its difficulty.** What is left is what no first user meets, and it has its line in the known issues.
- **The log is searched before a finding is argued**, for the decision the finding may sharpen or reverse.
- **Work in proportion.** Read the code before running anything. What the reading shows to be deterministic is verified once, and only what is intermittent is run again. The checks an item gets are sized to what it changes.
- **A published specification or a general-purpose engine is a library's work.** A program that finds itself writing one stops, and the user decides whether it becomes a library, a dependency or an ask of Ernest.
- **`make test` runs before a commit.** Commit only after it passes, on make's own exit status. A new file is staged first, since the documents' test reads tracked files alone.
- **Every section of the design has a test** whose comment names it, `// design §2: ...`. A test lives in the module it tests, and `test/` holds only modules of tests that run the program end to end.
- **The plan holds no stale sentence and no open question.** A step sweeps what it makes redundant in its own commit, and a question that waits for the user is a named decision in a milestone.

## What the user wants of the program

These are taste.

- Sound first, then the simplest thing that holds it.
- Minimal and direct, with no speculative abstraction.
- The program follows Ernest's semantics. What it promises beyond them needs a reason.
- Lean: a run holds only what its work needs, and memory that no collection reclaims is a defect.
- No fixed sleep and no busy loop: a process waits on what it means.
- A hole in a guarantee is answered first by a narrower promise, and by a mechanism only where the narrow one is not worth making.

## Honest reports

- **Read the result back before reporting it.** An agent's report is a claim: read its diff and run its check.
- **Say what was done, what was not, and what remains**, each specific enough to act on or to drop. A failure is reported with its output.
- **A report on an item that touched the design** names the sections applied and each place where the design was silent.

## Writing

- **The design is tight**: the rule, no rationale, nothing said twice, one rule to a sentence.
- **Every other document is plain and short**, a message to the user among them.
- **American English.** No document names who proposed an idea.

## Read when the job starts

| The job | Read first |
|---|---|
| Starting an agent | [`docs/agents.md`](docs/agents.md) |
| Writing Ernest | Ernest's `guide/style.md`, installed as `share/doc/ernest/guide/style.md` beside `ern` |
| Building, testing, running | [`README.md`](README.md)'s *Building*, its *Running* where there is one, and [`docs/build.md`](docs/build.md) |
| A release | [`docs/release.md`](docs/release.md) |
| A review of the whole repository | [`docs/full_review.md`](docs/full_review.md) |
| Any other document | [`docs/README.md`](docs/README.md), which says what each one is |
