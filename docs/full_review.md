# The full review

The template's four readers, and any a copy adds below them, each over the whole of its area. Between them they read the documents, the log and the proposals aside, and all the code. It is expensive and runs seldom. What every release runs is [`release.md`](release.md)'s.

## When it runs

Only when the user says so. No milestone, plan item or release starts one of itself.

It does not run while `findings.md` stands, a release's findings or a review's.

## How it runs

- `make test` passes from a fresh clone before a reader starts: `git clone`, with `--recursive` where there is an `erl/`, then `make test`, in a directory of its own.
- Each reader is an agent of its own, on the model [`agents.md`](agents.md) gives its kind of reader: C and S read the code, K and D the documents. It is given its brief and the files it reads, and nothing that argues for them, such as the log or another reader's list.
- A reader is handed `CLAUDE.md` as every agent is. Its brief stands in place of it and says so in one line, and the one rule of it a reader keeps is to leave untracked files alone. The cold reader has read nothing but what its brief names: neither the log, the plan, a proposal, the code nor another reader's list.
- A reader edits nothing in the repository. It builds and tries the program in a clone of the commit, in a scratch directory of its own, with the `ern` the Makefile names.
- The readers read one commit, which the findings name, and run side by side.
- Each reader hands in a numbered list, most serious first. A finding gives its place, a file and line or a section; a short quote; what is wrong; a program or a command that shows it, where there is one; and a one-line fix. Defects stand apart from matters of clarity.
- What a reader finds of Ernest's, and not of the program's, stands apart from both: a page of the installation that is opaque or silent, a message it did not understand, a refusal, a defect of the toolchain, and each place the language made the code harder than it should be: a workaround, a second way, something invisible, a function the library lacks, and a form the code repeats at site after site, with its count.
- A reader hands its list back as text and writes it to a file under the review's session's scratchpad, as [`agents.md`](agents.md) says of an agent.

## The readers

A reader's letter names its findings: C12 is the code reader's twelfth.

- **K, the cold reader.** Reads `README.md`, and of what it links only what a user of the program reads: the manual pages `make doc` writes under `build/`, `examples/` and `deploy/README.md`, where they exist. It reads no working document.

  "You know Ernest from its guide, and not this program. Build the program and use it as the README says: run it, or, where it is a library, call it from a program of your own. Report every step that failed or that you had to guess, every message you did not understand, everything you wanted and could not find, and every claim of the page that the program did not keep."
- **C, the code reader.** Reads `src/`, `test/`, `examples/`, `tools/` and the files of `deploy/` whole, where they exist, with the Makefile and the launcher, against `docs/design.md`, the report's §0, Appendix E.0's shape rules and the installed `guide/style.md`.

  "Report defects, every section of the design the code does not keep, code that no section states, comments that no longer hold, code that could be shorter and clearer, every name that does not say what its value or its work is, every `foreign fn` whose work Ernest could do, and every test that would pass with what it tests broken."
- **D, the documents reader.** Reads every tracked Markdown document but the log and the proposals.

  "Read each document against the design and the code it describes. Report every statement that is false or stale, every fact restated outside its owner or owned by no document (`CLAUDE.md`'s *Where a fact lives*), and every list that lives in two places."
- **S, the security reader**, where the program takes input from a party other than whoever runs it: a socket, a request, a file another wrote. Reads the code that input reaches, with the design's sections for it.

  "Report each place where untrusted input reaches something it should not, with an input that shows it." Real exposures stand apart from hardening.

A copy of the template adds below these the readers its program alone needs, and changes nothing above them.

- **L, the live shell reader.** Reads what a visitor's session stands on: the design's §10 to §14, `src/web_socket.ern`, `src/shell.ern`, `src/sessions.ern`, `src/session.ern` and `src/client.ern`, and of `deploy/` the image, the shell's start, the wrapper, the unit and step 7 of its `README.md`. It tries the session on localhost, and the container where podman stands, and nothing against the deployed site. What it could not run, it says. It reads the code.

  "A visitor types what they like and the session's program runs it: that is the shell's work and no finding. Report each way a visitor gets past what the shell grants: out of the container, into another visitor's session by its cookie or its socket, past a cap or a deadline, or to something that outlives the session, a container, a process or memory. Give what shows it. A limit the design states and no flag or check holds counts." Real exposures stand apart from hardening.

## The findings

- The lists become `findings.md` beside this file, a line per finding, each naming its reader's letter and number. Each reader's whole list is kept below the lines, since a line is too short to fix from.
- What a reader found of Ernest's becomes lines of `language_feedback.md`, carried to Ernest as `CLAUDE.md`'s *The work* says.
- A finding against what the template gives, `CLAUDE.md`, `docs/agents.md`, `tools/docs.ern` or this file, goes to the template, as `CLAUDE.md`'s *What is the user's* says of a rule.
- Every other line is sorted before anything is built. A defect is fixed or planned in a milestone; clarity is fixed where it is cheap, and otherwise dropped. A line stands in `findings.md` until it is done, dropped or planned, and the commit messages say which.
- A fix that is a sentence is the session's, and one that is code or a test an agent's, as `CLAUDE.md`'s *The work* has it. An agent runs the program or the command a finding gives before it makes the fix, and hands back a line whose program does not show the defect.
- A decision among the lines is argued as `CLAUDE.md`'s *Who decides* says. A name a reader lists is decided after the word is searched across the design, the code and the pages, never from its module alone.
- The log gains an entry for the review: its date and commit, and how many findings took each decision.
