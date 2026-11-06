# The full review

Four readers, each over the whole of its area. Between them they read the documents, the log and the proposals aside, and all the code. It is expensive and runs seldom. What every release runs is [`release.md`](release.md)'s.

## When it runs

Only when the user says so. No milestone, plan item or release starts one of itself.

It does not run while `findings.md` stands, a release's findings or a review's.

## How it runs

- `make test` passes from a fresh clone before a reader starts, as [`release.md`](release.md)'s first step has it.
- Each reader is a session of its own, on the stronger model, as `CLAUDE.md` says of a review's reader. It is given its brief and the files it reads, and nothing that argues for them, such as the log or another reader's list.
- A reader edits nothing in the repository. It builds and tries the program in a clone of the commit, in a scratch directory of its own, with the `ern` the Makefile names.
- The readers read one commit, which the findings name, and run side by side.
- Each reader hands in a numbered list, most serious first. A finding gives its place, a file and line or a section; a short quote; what is wrong; a program or a command that shows it, where there is one; and a one-line fix. Defects stand apart from matters of clarity.
- What a reader finds of Ernest's, and not of the program's, stands apart from both: a page of the installation that is opaque or silent, a function the library lacks, a message it did not understand, a place the language made the code harder than it should be.
- A reader hands its list back as text and writes it to a file under the review's session's scratchpad, as `CLAUDE.md` says of an agent.

## The readers

A reader's letter names its findings: C12 is the code reader's twelfth.

- **K, the cold reader.** Reads `README.md`, and of what it links only what a user of the program reads: the manual pages, `examples/` and `deploy/README.md`, where they exist. It reads no working document.

  "You know Ernest from its guide, and not this program. Build the program and use it as the README says: run it, or, where it is a library, call it from a program of your own. Report every step that failed or that you had to guess, every message you did not understand, everything you wanted and could not find, and every claim of the page that the program did not keep."
- **C, the code reader.** Reads `src/`, `test/`, `examples/`, `tools/` and the files of `deploy/` whole, where they exist, with the Makefile and the launcher, against `docs/design.md`, the report's §0, Appendix E.0's shape rules and the installed `guide/style.md`.

  "Report defects, every section of the design the code does not keep, code that no section states, comments that no longer hold, code that could be shorter and clearer, every name that does not say what its value or its work is, every `foreign fn` whose work Ernest could do, and every test that would pass with what it tests broken."
- **D, the documents reader.** Reads every tracked Markdown document but the log, the proposals and the pages `make man` wrote under `docs/man/`.

  "Read each document against the design and the code it describes. Report every statement that is false or stale, every fact restated outside its owner or owned by no document (`CLAUDE.md`'s *Who owns each fact*), and every list that lives in two places."
- **S, the security reader**, where the program takes input from a party other than whoever runs it: a socket, a request, a file another wrote. Reads the code that input reaches, with the design's sections for it.

  "Report each place where untrusted input reaches something it should not, with an input that shows it." Real exposures stand apart from hardening.

A copy of the template adds below these the readers its program alone needs, and changes nothing above them.

## The findings

- The lists become `findings.md` beside this file, a line per finding, each naming its reader's letter and number. Each reader's whole list is kept below the lines, since a line is too short to fix from.
- What a reader found of Ernest's becomes lines of `language_feedback.md`, carried to Ernest as `CLAUDE.md`'s *Defects and gaps* says.
- A finding against what the template gives, `CLAUDE.md`, `tools/docs.ern` or this file, goes to the template, as `CLAUDE.md`'s *The repository* says of a rule.
- Every other line is sorted as [`release.md`](release.md)'s findings are.
- The log gains an entry for the review: its date and commit, and how many findings took each decision.
