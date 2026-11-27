# The program's build and tests: one Makefile, the targets of every
# application begun from ernest-template, beside any a copy adds of its own.
# The variables an application edits stand first; the rest is the same
# everywhere but for those targets.
#
#   make          builds: lib/ filled, and the program compiled after each
#                 package package.conf names
#   make test     in a checkout: the layout, the tests of every module, test/
#                 where it exists, make examples where there is a program to
#                 build, and then the documents, the design's citations, and
#                 the project's history kept out of the comments and what a
#                 user reads
#   make examples each program of examples/ built and run, what it writes
#                 under build/examples/
#   make run      runs the program through its launcher with the arguments
#                 RUN_ARGS names, after the targets RUN_NEEDS names, none by
#                 default
#   make smoke    the smoke test against the deployed site whose canonical
#                 host HOST names, make smoke HOST=ernest-lang.org, the
#                 checks deploy/config.json takes
#   make lib      fills lib/: each package package.conf names unpacked there
#                 from its archive by ern unpack, and then, in a checkout and
#                 wherever erl/ stands, each Erlang application under erl/
#                 built by its own make
#   make xterm    fills the example site's xterm/: each archive XTERM names
#                 fetched by curl and then unpacked where its script is not
#                 there
#   make doc      the module pages, CommonMark under build/, and the manual
#                 pages, roff beside each module's compiled form
#   make format   lays every module out
#   make release  the archive, build/NAME-VERSION.tar.gz, and its checksum
#                 beside it: its refusals first, then make test and make doc;
#                 a library's carries the module pages under docs/modules/ and
#                 the manual pages under docs/man/man3/
#   make install  builds, then installs under PREFIX, /usr/local by default,
#                 from a checkout or an unpacked archive alike: the launcher
#                 in bin/, build/'s modules, package.conf, lib/'s packages and
#                 the program's own Erlang in lib/NAME/, and the documents in
#                 share/doc/NAME/
#   make uninstall  removes from PREFIX what make install put there, and then
#                 share/doc, share, lib and bin under it, each where it is
#                 empty
#   make clean    removes what the build wrote, and each package ern unpack
#                 wrote under lib/ beside its archive; it leaves the archives,
#                 the links under lib/, and what each Erlang application under
#                 erl/ built

NAME        = ernest_httpd
# The program's own Erlang applications, each a submodule under erl/ of its
# own name, in build order.
ERL_DEPS    =
# The example site's terminal, xterm.js and its fit addon, each by the URL
# of its npm archive, pinned; make xterm copies what the shell page loads
# into examples/site/root/xterm/, which git ignores.
XTERM       = https://registry.npmjs.org/@xterm/xterm/-/xterm-5.5.0.tgz \
              https://registry.npmjs.org/@xterm/addon-fit/-/addon-fit-0.10.0.tgz
# What each program of examples/ writes, named by make examples: the suffix of
# the one path it is given.
EXAMPLE_SUFFIX =
# What the build writes under examples/, each directory: examples/build and
# any the program's own targets write, which git ignores, make clean removes
# and the documents leave out: here the site's xterm/, which make xterm fills.
EXAMPLES_MADE = examples/build examples/site/root/xterm
# The configuration make run serves.
CONFIG     ?= examples/site/config.json
# The arguments make run gives the launcher, and the targets it builds first:
# the configuration, the site's terminal and its access log's directory.
RUN_ARGS    = $(CONFIG)
RUN_NEEDS   = xterm build/examples/site

# The ern on PATH, or ERN=path/to/ern, whose directory then stands first on
# PATH for every target, so that whatever names ern by its name, a test or an
# example's shell, runs that one too; a file not called ern is not reached so.
ERN        ?= ern
export PATH := $(if $(findstring /,$(ERN)),$(abspath $(dir $(ERN))):)$(PATH)
# Where make install puts the program and make uninstall removes it from.
PREFIX     ?= /usr/local

# Ernest's own libraries stand on every job's load path, and so does each
# package package.conf names, under lib/, for every job started here (report
# §11.9). The program's own Erlang applications stand under erl/, each with
# its ebin and the priv the host finds beside it, which ern test and ern run
# take through --libs-dir erl; ern build and ern doc read no application.
RUN_LIBS      = $(if $(ERL_DEPS),--libs-dir erl)
# The programs of examples/; what else stands under it is data, not built.
EXAMPLES      = $(wildcard examples/*.ern)
VERSION       = $(shell cat VERSION)
# Git on the checkout, read as whoever runs make, whose checkout it need not
# be, which git refuses unless told it is safe.
GIT           = git -c safe.directory=$(CURDIR)
# The documents make release and make install take, the user's alone:
# README.md, LICENSE, THIRD_PARTY_LICENSES, ACKNOWLEDGMENTS.md, CHANGES.md and
# docs/design.md, each where it exists, and the files under examples/,
# deploy/ and assets/, whose pictures the documents may show. Of those three,
# a checkout gives the files git tracks, so that no untracked file goes in.
# An unpacked archive gives every file there but those under each directory
# EXAMPLES_MADE names.
DOCS          = $(strip \
                $(wildcard README.md LICENSE THIRD_PARTY_LICENSES ACKNOWLEDGMENTS.md \
                    CHANGES.md docs/design.md) \
                $(if $(wildcard .git),\
                    $(shell $(GIT) ls-files examples deploy assets),\
                    $(shell find examples deploy assets -type f \
                        $(foreach dir,$(EXAMPLES_MADE),! -path '$(dir)/*') 2>/dev/null)))
# The sources make release takes: the files git tracks under src/, since a
# release is made in a checkout alone, where make test runs. Elsewhere git
# is not asked, since make expands the recipe before make test refuses.
SOURCES       = $(if $(wildcard .git),$(shell $(GIT) ls-files src))
# An installation's own directories under PREFIX, beside its launcher.
TREE          = $(PREFIX)/lib/$(NAME)
DOC_DIR       = $(PREFIX)/share/doc/$(NAME)

.PHONY: all lib build test examples run doc format release install uninstall clean

all: lib build

# ern unpack names each archive that is not under lib/, and the URL to
# download it from where package.conf gives one (report §11.9). The Erlang
# applications are built in a checkout, where .git stands, and wherever erl/
# stands; an unpacked archive has neither, and holds their modules in its
# own ebin/.
lib:
	@mkdir -p lib
	$(ERN) unpack
	@test ! -e .git && test ! -d erl || for app in $(ERL_DEPS); do \
	    test -f erl/$$app/Makefile || \
	        { echo "erl/$$app is empty: git submodule update --init"; exit 1; }; \
	    $(MAKE) -C erl/$$app || exit 1; \
	done

# This program's own targets, make xterm and make smoke.
.PHONY: xterm smoke

# Each archive of XTERM, where its package's script is not in the site's
# xterm/, fetched by curl into a file under build/, NAME-VERSION.tgz, and
# only then unpacked under build/, a fetch that fails said with its URL
# before anything is unpacked (design §13); and its license, as
# NAME.js.LICENSE.txt, its stylesheets, css/*.css, and last its script,
# lib/NAME.js, copied there; NAME is the archive's name without its version.
# The archive and what it unpacked to are then removed, since nothing reads
# them after.
xterm:
	@mkdir -p examples/site/root/xterm build
	@for url in $(XTERM); do \
	    archive=$$(basename $$url .tgz); \
	    name=$${archive%-*}; \
	    test -f examples/site/root/xterm/$$name.js && continue; \
	    dir=build/$$archive; \
	    echo "fetching $$url"; \
	    curl -fsSL -o $$dir.tgz "$$url" || \
	        { rm -f $$dir.tgz; echo "make xterm: cannot fetch $$url"; exit 1; }; \
	    rm -rf $$dir && mkdir -p $$dir && tar -xzf $$dir.tgz -C $$dir || exit 1; \
	    cp $$dir/package/LICENSE examples/site/root/xterm/$$name.js.LICENSE.txt || exit 1; \
	    for file in $$dir/package/css/*.css $$dir/package/lib/$$name.js; do \
	        test -f $$file || continue; \
	        cp $$file examples/site/root/xterm/ || exit 1; \
	    done; \
	    rm -rf $$dir $$dir.tgz; \
	done

# ern build refuses an ern earlier than the release package.conf names, and
# builds each package it names, in their order, before the program (report
# §11.9). It comes after lib, under make -j too, so that the packages stand
# under lib/ when it starts.
build: lib
	$(ERN) build src

# It runs in a checkout alone, since the checker of the documents stands
# under tools/, which an archive does not carry. The documents come last,
# since one may name what the examples wrote.
test: all
	@test -d tools || \
	    { echo "make test runs in a checkout of $(NAME), and this directory has no tools/"; exit 1; }
	$(strip $(ERN) format --check src tools $(wildcard test) $(if $(EXAMPLES),examples))
	$(strip $(ERN) test $(RUN_LIBS) build)
	$(ERN) build --source-root tools --build-root tools/build tools
	$(ERN) test tools/build
	@if test -d test; then \
	    $(ERN) build --source-root test --build-root test/build --load-path build test && \
	    $(ERN) test --load-path build $(RUN_LIBS) test/build; \
	fi
	@if test -n "$(EXAMPLES)"; then $(MAKE) --no-print-directory examples; fi
	$(ERN) run tools/build/docs.erc

# Each program of examples/ built with the program on its load path, then run
# with one argument, build/examples/NAME followed by EXAMPLE_SUFFIX, which it
# writes; a program that ends with a status other than 0 fails the target.
examples: all
	@test -n "$(EXAMPLES)" || { echo "no program under examples/: nothing to build"; exit 1; }
	$(ERN) build --source-root examples --build-root examples/build --load-path build examples
	@mkdir -p build/examples
	@for program in examples/build/*.erc; do \
	    name=$$(basename $$program .erc); \
	    $(ERN) run --load-path build $(RUN_LIBS) $$program \
	        build/examples/$$name$(EXAMPLE_SUFFIX) || exit 1; \
	    echo "examples/$$name.ern wrote build/examples/$$name$(EXAMPLE_SUFFIX)"; \
	done

run: all $(RUN_NEEDS)
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to run"; exit 1; }
	$(strip bin/$(NAME) $(RUN_ARGS))

# The directory of the example site's access log, made before make run, since
# the configuration's access-log stands in a directory that exists.
build/examples/site:
	mkdir -p $@

# The smoke test, design §13: Smoke's own compiled form run with the host
# and the deployed configuration as its arguments, since ern run's --main
# names a function of the file's own module alone. A missing HOST is
# refused before the build.
smoke: $(if $(HOST),all)
	@test -n "$(HOST)" || { echo "HOST is required: make smoke HOST=ernest-lang.org"; exit 1; }
	$(ERN) run $(RUN_LIBS) build/smoke.erc $(HOST) deploy/config.json

# The module pages, a CommonMark document for each module under build/ and
# their index, build/index.md, and then the manual pages, each in roff beside
# its module's compiled form, build/Ernest.Name.3ern for the module Name
# (report §11.4).
doc: all
	$(ERN) doc src
	$(ERN) doc --man src

format:
	$(strip $(ERN) format src tools $(wildcard test) $(if $(EXAMPLES),examples))

# The files under $(1) that the find test $(2) selects, copied into $(3) at
# their paths under $(1), links copied through. A path that holds a -, which
# no module's path does, is passed over: the staging directory and the
# archive of make release.
copied = (cd $(1) && find . -path '*-*' -prune -o $(2) -print | tar chf - -T -) | \
	    tar xf - -C $(3)

# The compiled modules of the package $(1), its build/, copied into $(2)/build
# at their paths. Every copy of the compiled modules is made so, the program's
# and each package's, into the archive and into the installation.
ercs = if test -d $(1)/build; then \
	    mkdir -p $(2)/build && \
	    $(call copied,$(1)/build,-name '*.erc',$(2)/build) || exit 1; \
	fi

# The packages under lib/ copied into $(1)/lib, each as report §11.9 has a
# package: its package.conf, VERSION, src/, ebin/ and priv/, each where it
# stands, and the compiled modules of its build/, links copied through.
# Nothing else of it is copied: no name that begins with a dot, .git/ among
# them, no archive and no lib/ of its own.
packages = for dir in lib/*/; do \
	    test -d "$$dir" || continue; \
	    dir=$${dir%/}; \
	    mkdir -p $(1)/$$dir || exit 1; \
	    for part in package.conf VERSION src ebin priv; do \
	        test ! -e $$dir/$$part || cp -RL $$dir/$$part $(1)/$$dir/ || exit 1; \
	    done; \
	    $(call ercs,$$dir,$(1)/$$dir); \
	done

# Another application's priv/ under erl/ refused, before anything is written,
# since the host finds a package's priv/ only for the application named NAME.
privs = for app in $(ERL_DEPS); do \
	    test ! -e erl/$$app/priv || test $$app = $(NAME) || \
	        { echo "erl/$$app has a priv/, which the host finds here only for the" \
	            "application $(NAME): make $$app a package"; exit 1; }; \
	done

# The program's own Erlang copied into $(1) as a package holds it (report
# §11.9): from erl/, every application's ebin in one ebin/, and the priv/ of
# the application named NAME beside it, where the host finds it by the
# directory's name, privs having refused another's. Where there is no erl/,
# an unpacked archive's, its ebin/ and priv/ as they stand.
erlang = if test -n "$(ERL_DEPS)" && test -d erl; then \
	    for app in $(ERL_DEPS); do \
	        mkdir -p $(1)/ebin && cp -RL erl/$$app/ebin/. $(1)/ebin/ || exit 1; \
	        test $$app = $(NAME) && test -e erl/$$app/priv || continue; \
	        cp -RL erl/$$app/priv $(1)/priv || exit 1; \
	    done; \
	else \
	    for part in ebin priv; do \
	        test ! -d $$part || cp -RL $$part $(1)/$$part || exit 1; \
	    done; \
	fi

# The archive unpacks to NAME-VERSION/, a package as report §11.9 has one, so
# that ern unpack takes it: package.conf and VERSION, the launcher where
# there is one, the sources of SOURCES and the compiled modules, the program's
# own Erlang at its top, the packages under lib/, the documents of DOCS, and
# the Makefile, so that make, make run and make install run in it; every
# member a directory or a regular file. One shape for an application and a
# library, so that any archive can be a dependency. Its checksum stands
# beside it, for `sha256sum -c`.
#
# Its refusals come first, before make test and make doc run, under make -j
# too: a development build of ern, whose version text has -dev or +commit
# after the version (report §11.7); in a checkout, a tracked file changed and
# not committed, or a file the archive would carry that git does not track,
# ignored or not: one under src/, whose module ern build would compile, a
# document of DOCS, package.conf, VERSION, the Makefile, the launcher, and
# the ebin/ and priv/ at the top where ERL_DEPS is empty; and another
# application's priv/ under erl/.
#
# A library's archive carries its pages too, from build/, the one copy a
# checkout holds: the module pages under docs/modules/ at their paths, with
# the index as its README, and the manual pages under docs/man/man3/, where
# man -M docs/man finds them. Neither the staging directory nor what the
# examples wrote is among them. An application's archive carries neither.
release:
	@version=$$($(ERN) --version) || exit 1; \
	case $$version in *-dev|*+*) \
	    echo "a release is not made with a development build of ern," \
	        "and this is ern $${version#ern }"; \
	    exit 1 ;; \
	esac
	@if test -e .git; then \
	    changed=$$($(GIT) status --porcelain --untracked-files=no) && \
	    untracked=$$($(GIT) ls-files --others -- src $(DOCS) Makefile VERSION package.conf \
	        bin/$(NAME) $(if $(ERL_DEPS),,ebin priv)) || exit 1; \
	    if test -n "$$changed$$untracked"; then \
	        echo "a release is made from committed files alone, and these are not:"; \
	        test -z "$$changed" || printf '%s\n' "$$changed" | cut -c4-; \
	        test -z "$$untracked" || printf '%s\n' "$$untracked"; \
	        exit 1; \
	    fi; \
	fi
	@$(privs)
	@$(MAKE) --no-print-directory test doc
	rm -rf build/$(NAME)-$(VERSION) && mkdir -p build/$(NAME)-$(VERSION)
	@$(call ercs,.,build/$(NAME)-$(VERSION))
	@$(call packages,build/$(NAME)-$(VERSION))
	@$(call erlang,build/$(NAME)-$(VERSION))
	if test -x bin/$(NAME); then mkdir -p build/$(NAME)-$(VERSION)/bin && \
	    cp bin/$(NAME) build/$(NAME)-$(VERSION)/bin/; fi
	tar chf - $(SOURCES) $(DOCS) Makefile VERSION package.conf | \
	    tar xf - -C build/$(NAME)-$(VERSION)
	@if test ! -x bin/$(NAME); then \
	    pages=build/$(NAME)-$(VERSION)/docs; \
	    mkdir -p $$pages/modules $$pages/man/man3 && \
	    $(call copied,build,-path ./examples -prune -o -name '*.md' ! -path ./index.md,$$pages/modules) && \
	    cp build/index.md $$pages/modules/README.md || exit 1; \
	    for page in $$(cd build && find . -path '*-*' -prune -o -path ./examples -prune -o \
	            -name '*.3ern' -print); do \
	        cp build/$$page $$pages/man/man3/ || exit 1; \
	    done; \
	fi
	tar -czf build/$(NAME)-$(VERSION).tar.gz -C build $(NAME)-$(VERSION)
	cd build && sha256sum $(NAME)-$(VERSION).tar.gz > $(NAME)-$(VERSION).tar.gz.sha256
	rm -rf build/$(NAME)-$(VERSION)

# Whether $(TREE) is an installation of the program: a directory that is
# empty, or one that holds package.conf.
installation = { test -d $(TREE) && test -z "$$(ls -A $(TREE))" || test -f $(TREE)/package.conf; }

# What $(TREE) holds but its package.conf removed, so that the rm -rf after
# it removes package.conf last and $(TREE) is an installation at every step.
emptied = test ! -d $(TREE) || test -L $(TREE) || \
	find $(TREE) -mindepth 1 -maxdepth 1 ! -name package.conf -exec rm -rf {} +

# What make builds, installed: an installation already there replaced
# whole, so that no module of an older one is left. Before anything under
# PREFIX is removed or written, it refuses a lib/NAME there that is not an
# installation, empty or holding package.conf, and, where there is no
# lib/NAME, a launcher of another program's. It removes the launcher first
# and package.conf last, and copies package.conf first, so that lib/NAME is
# an installation at every step and an install cut short leaves one the next
# install replaces. The installation is a package, as the archive is, which
# the launcher names its root package. It depends on all: under the ern that
# built the modules, ern build compiles nothing again, so that an archive
# installs as it was compiled, and under another ern it builds them again
# from the sources the archive carries.
install: all
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to install"; exit 1; }
	@test -f build/$(NAME).erc || \
	    { echo "build/$(NAME).erc is not there: make builds it from src/$(NAME).ern"; exit 1; }
	@if test -e $(TREE) || test -L $(TREE); then \
	    $(installation) || \
	        { echo "$(TREE) is there already and holds no installation of $(NAME)"; exit 1; }; \
	else \
	    test ! -e $(PREFIX)/bin/$(NAME) || \
	        { echo "$(PREFIX)/bin/$(NAME) is there already and is not this program's"; exit 1; }; \
	fi
	@$(privs)
	rm -f $(PREFIX)/bin/$(NAME)
	@$(emptied)
	rm -rf $(TREE) $(DOC_DIR)
	mkdir -p $(PREFIX)/bin $(TREE) $(DOC_DIR)
	cp package.conf $(TREE)/package.conf
	cp bin/$(NAME) $(PREFIX)/bin/$(NAME)
	@$(call ercs,.,$(TREE))
	@$(call packages,$(TREE))
	@$(call erlang,$(TREE))
	tar cf - $(DOCS) | tar xf - -C $(DOC_DIR)

# What make install put under PREFIX removed: the launcher, lib/NAME and
# share/doc/NAME, once lib/NAME is found an installation, empty or holding
# package.conf, and nothing of a lib/NAME that is not one. The launcher goes
# first and package.conf last, as make install removes them. Then share/doc,
# share, lib and bin under PREFIX go, deepest first, each where it is empty,
# whoever made it; PREFIX itself stays.
uninstall:
	@test -e $(TREE) || test -L $(TREE) || \
	    { echo "no installation of $(NAME) under $(PREFIX)"; exit 1; }
	@$(installation) || \
	    { echo "$(TREE) holds no installation of $(NAME)"; exit 1; }
	rm -f $(PREFIX)/bin/$(NAME)
	@$(emptied)
	rm -rf $(TREE) $(DOC_DIR)
	@for dir in $(PREFIX)/share/doc $(PREFIX)/share $(PREFIX)/lib $(PREFIX)/bin; do \
	    rmdir $$dir 2>/dev/null || true; \
	done

# What the build, make doc and make examples wrote goes, and so does each
# package ern unpack wrote under lib/, a directory beside its archive, as
# lib/leaf beside lib/leaf-1.2.0.tar.gz, and the lock lib/.unpack. The
# archives stay, and so do a link under lib/ and a directory there with no
# archive beside it, as an unpacked archive's packages are. What each Erlang
# application under erl/ built stays too, for its own make clean to remove.
clean:
	rm -rf build tools/build test/build $(EXAMPLES_MADE)
	@for dir in lib/*/; do \
	    dir=$${dir%/}; \
	    test -d "$$dir" && test ! -L "$$dir" || continue; \
	    for archive in "$$dir"-*.tar.gz; do \
	        test -f "$$archive" || continue; \
	        echo "rm -rf $$dir"; rm -rf "$$dir"; break; \
	    done; \
	done
	rm -f lib/.unpack
