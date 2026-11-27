# The build

How the Makefile, the launcher, the archive and the installation are arranged, the same in every application begun from `ernest-template`. It is the template's, and changes there; the report's sections cited are Ernest's.

## The Makefile

One Makefile at the top. The variables an application edits stand first, and the rest is the same in every application, its targets among it: `all`, `lib`, `build`, `test`, `examples`, `run`, `doc`, `format`, `release`, `install`, `uninstall` and `clean`, beside any a copy adds of its own. There is no light run and no full run, since an application's whole suite runs in seconds, and where one day it does not, that is a defect of the tests to measure.

**The load path.** The libraries of Ernest's own stand on every job's load path by the toolchain's own rule (§11.1, §11.2). The packages `package.conf` names stand under `lib/`, which is the manifest's alone, and every job started in the package, or given it by `--package-dir`, puts them on the load path (§11.9). The program's own Erlang applications stand under `erl/`, each built there by its own `make` with its `ebin` and its `priv`, and `--libs-dir erl` puts them on the load path of `ern test` and `ern run`. The Makefile writes no package's path.

`ERL_DEPS` is in build order. `ern build` orders the packages itself, each after those its manifest names.

**The build.** `all` fills `lib/` by `ern unpack`, builds each Erlang application `ERL_DEPS` names by its own `make`, in a checkout and wherever `erl/` stands, and then runs `ern build src`. That builds each package's `src/` into its own `build/` with the consumer's own `ern`, and then the program's `src/`. `build` follows `lib`, under `make -j` too.

**The least release.** `package.conf`'s `ernest` is the least release the program is written for, and `ern build` refuses an earlier `ern` in its own words (§11.9). Until Ernest's 1.0 a later release may refuse the program, until the program rises to it. A development build passes where its three numbers do, since the applications are written against Ernest's unreleased builds to drive the language.

**The pages.** `doc` writes the module pages, CommonMark, under `build/doc/` with their index, `build/doc/index.md`, and then the manual pages, roff, under `build/man/`, each at its module's path, by `ern doc`'s `--doc-root` (§11.4).

**Test.** `test` runs in a checkout alone, since the checker of the documents stands under `tools/`, which an archive does not carry, and refuses elsewhere. It builds a dependent too, in a temporary directory it removes: a `package.conf` that names the program, `lib/<name>` linked to the checkout, and one module, so that a module of the program that a dependent's `ern build` refuses fails the program's own `test` (§11.9). It names each package under the checkout's `lib/` too, by its directory and its `VERSION`, linked there, since a dependent names every package the program does.

**The examples.** A program of `examples/` is an `.ern` file at its top, and what else stands under it is data. `examples` builds each into `examples/build/` with the program on its load path, and runs it with one argument, `build/examples/<program>` followed by `EXAMPLE_SUFFIX`, the path it writes; a status other than 0 fails it. `test` runs `examples`, where there is a program, before its check of the documents, since a document may name what an example wrote. `EXAMPLES_MADE`, among the variables an application edits, names each directory the build writes under `examples/`, `examples/build/` and any a copy adds; `clean` removes each, and the documents an unpacked archive carries leave each out.

**Run.** `run` builds the program and then each target `RUN_NEEDS` names, and runs the launcher with the arguments `RUN_ARGS` names; both are among the variables an application edits, and empty by default. A library has nothing to run, and `run` says so.

**Clean.** `clean` removes what the build wrote, `stage/` among it, and each package `ern unpack` wrote under `lib/` where its archive stands beside it, with `ern unpack`'s lock. It leaves the archives, a link or a directory put under `lib/` by hand, and what each Erlang application under `erl/` built.

## The launcher

`bin/<name>` runs `ern run` on the module its own name names, with its root as the run's root package, `--package-dir`, and the program's own Erlang on the load path: its root's `ebin/` by `--load-path`, and its `erl/` by `--libs-dir`, each where it stands. It first follows the path it is run by through its links, by `realpath`, so that a link to it runs it as the file itself does, under the file's name. Its root is `../lib/<name>/` where the module's compiled form stands there, beside an installed launcher, and `..` otherwise, a checkout or an unpacked archive: one file for the three.

It runs the `ern` on `PATH`, or the one `ERN` names, and before the run refuses, with status 127, one it cannot find or that is not an executable file. It forwards a leading `--config-dir dir`, the one option an operator gives, and refuses a `--config-dir` with nothing after it; everything after them goes to the program. The working directory stays the caller's.

## The archive

`release` refuses first, before it runs `test` and `doc`, under `make -j` too: a development build of `ern`, whose version text has `-dev` or `+<commit>` after the version (§11.7); in a checkout, a tracked file not committed, or a file it carries that git does not track, ignored or not; another application's `priv/`; and a path `ERL_PRIV` names that leaves `priv/`, absolute or through `..`. Once `test` has built `erl/`, and before it stages, it refuses an empty `ERL_PRIV` where the application of the program's name has a `priv/`, one that names a path where it has none, and a path it names that the build did not make.

It then stages the archive's tree in `stage/<name>-<version>/`, outside every build root, so that a release cut short leaves nothing `test` runs, and writes `build/<name>-<version>.tar.gz`, a package as §11.9 has one: `package.conf` and `VERSION`, the launcher where there is one, the files git tracks under `src/`, the compiled modules, the program's own Erlang, each package under `lib/`, the user's documents, and the `Makefile`, so that `make`, `make run` and `make install` run in the unpacked archive. One shape for an application and a library, so that any archive can be a dependency, and `ern unpack` takes it: one directory named as the archive, each member a directory or a regular file, each link copied through.

Every module stands at `src/<name>.ern` or under `src/<name>/`, so that the archive can be a dependency: under a dependent's `lib/` the package is named, and the dependent's `ern build` refuses a module of it at any other namespace (§11.9). The program's own build holds no such rule, so `test` builds a dependent to hold it.

A package under `lib/` travels as §11.9 has one: its `package.conf`, `VERSION`, `src/`, `ebin/` and `priv/`, and the compiled modules of its `build/`, and nothing else of it.

The program's own Erlang stands at the archive's top, as a package's does: every application's `.beam` files in one `ebin/`, and beside it, of the `priv/` of the application of the program's name, what `ERL_PRIV` names and nothing else, each at its path there, where the host finds it by the name of the directory that holds it. `ERL_PRIV`, among the variables an application edits, names files or directories under that `priv/`, and `.` names the whole. It is read in a checkout and wherever `erl/` stands, and an unpacked archive's `priv/` is carried as it stands. `release` and `install` refuse another application's `priv/`, which no one would find there; such an application is a package of its own.

An archive carries the user's documents alone, each where it exists: `README.md`, `LICENSE`, `THIRD_PARTY_LICENSES`, `ACKNOWLEDGMENTS.md`, `CHANGES.md`, `docs/design.md`, `examples/`, `deploy/` and `assets/`, whose pictures the documents may show. The way of working stays in the repository: `CLAUDE.md`, the plan, the log, this page, `docs/release.md`, `docs/full_review.md` and `docs/agents.md`. `release` writes the archive's checksum beside it, `build/<name>-<version>.tar.gz.sha256`, and the two are published together.

A library's archive also carries its pages, from `build/doc/` and `build/man/`, the one copy a checkout holds: the module pages under `docs/modules/` at their paths, their index as the README, and the manual pages under `docs/man/man3/`, one directory, where `man -M` finds them. A dependent's `lib/` then holds the pages of the release it stands on. An application's archive carries neither.

## The installation

`install`, from a checkout or an unpacked archive, builds and then puts what stands built under `PREFIX`, `/usr/local` by default, as Ernest's own `make install` does: the launcher in `bin/`; the compiled modules, `package.conf`, the packages under `lib/` and the program's own Erlang under `lib/<name>/`, laid out as the archive lays them; and the documents under `share/doc/<name>/`, each at its path in the archive, so that the README's links resolve there. It puts no manual page.

Under the `ern` that built the modules, `install`'s build compiles nothing again, so that an archive installs as it was compiled; under another, it builds them again from the sources the archive carries (§11.2). Before anything under `PREFIX` is removed or written, it refuses `ERL_PRIV` as `release` does, a `lib/<name>` there that is no installation, one neither empty nor holding `package.conf`, and, where there is no `lib/<name>`, a launcher of another program's. It removes the launcher first and `package.conf` last, and copies `package.conf` first, so that an install cut short leaves an installation the next one replaces. It replaces an installation already there whole.

`uninstall` refuses the same `lib/<name>`, removes exactly what `install` put there, then `share/doc`, `share`, `lib` and `bin` under `PREFIX`, each where it is empty, and never `PREFIX` itself. A library has no launcher and nothing to install.

An installed program runs under the `ern` that built it, and §11.2 refuses it under another. The source travels so that a consumer, and `install` under another `ern`, builds the modules again, and the compiled modules so that an operator of the same release runs the application as it is. The `lib/` that travels serves the operator, for whom the archive is whole; a consumer names every package in its own `package.conf`.
