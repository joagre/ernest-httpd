# The program's build and tests: one Makefile, the targets of every
# application begun from ernest-template and two of this program's own, make
# xterm, for its example site, and make smoke, for the deployed site. The
# variables an application edits stand first.
#
#   make          builds: lib/ filled, and the program compiled after each
#                 package package.conf names
#   make test     the layout, the tests of every module, test/ where it exists,
#                 make examples where there is a program to build, and then
#                 the documents, the design's citations, and the project's
#                 history kept out of the comments and what a user reads
#   make examples each program of examples/ built and run, what it writes
#                 under build/examples/
#   make run      runs the example site through the launcher, or the
#                 configuration CONFIG names, CONFIG=path make run
#   make smoke    the smoke test against the deployed site whose canonical
#                 host HOST names, make smoke HOST=ernest-lang.org, the
#                 checks deploy/config.json takes
#   make lib      fills lib/: each package package.conf names unpacked there
#                 from its archive by ern unpack, and then each Erlang
#                 application under erl/ built by its own make
#   make xterm    fills the example site's xterm/: each archive XTERM names
#                 fetched by curl and then unpacked where its script is not
#                 there
#   make doc      the documentation of every module, as CommonMark under build/
#   make format   lays every module out
#   make release  the archive, build/NAME-VERSION.tar.gz, and its checksum
#                 beside it, a development build of ern refused first and
#                 the tests run next; a library's carries the pages of
#                 make doc under docs/man/
#   make install  installs what stands built under PREFIX, /usr/local by
#                 default, from a checkout or an unpacked archive alike:
#                 the launcher in bin/, build/'s, package.conf, lib/'s and
#                 the program's own Erlang in lib/NAME/, and the documents
#                 in share/doc/NAME/, deploy/ and examples/ among them
#   make uninstall  removes from PREFIX what make install put there, and the
#                 directories it made where they are empty
#   make clean    removes what the build, make lib and make xterm wrote, and
#                 leaves the archives and the links put under lib/

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
# The configuration make run serves.
CONFIG     ?= examples/site/config.json

# The ern on PATH, or ERN=path/to/ern, whose directory then stands first on
# PATH for every target, so that whatever names ern by its name, a test or an
# example's shell, runs that one too; a file not called ern is not reached so
# (design §13).
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
# What the build and make xterm write under examples/, which git ignores,
# make clean removes and the documents leave out.
EXAMPLES_MADE = examples/build examples/site/root/xterm
# The documents make install and make release take, the user's alone:
# README.md, LICENSE, THIRD_PARTY_LICENSES, CHANGES.md and docs/design.md,
# each where it exists, and under examples/, deploy/ and assets/, the
# repository's pictures, the files git tracks in a checkout, so
# that no untracked file goes in, read as whoever installs, whose checkout
# it need not be, which git refuses unless told it is safe; or in an
# unpacked archive every file there but EXAMPLES_MADE's, which make release
# wrote with those.
DOCS          = $(wildcard README.md LICENSE THIRD_PARTY_LICENSES CHANGES.md docs/design.md) \
                $(if $(wildcard .git),\
                    $(shell git -c safe.directory=$(CURDIR) ls-files \
                        examples deploy assets),\
                    $(shell find examples deploy assets -type f \
                        $(foreach dir,$(EXAMPLES_MADE),! -path '$(dir)/*') 2>/dev/null))
# The sources make release takes: the files git tracks under src/ in a
# checkout, so that no untracked file goes in, read as DOCS is; or in an
# unpacked archive every file there.
SOURCES       = $(if $(wildcard .git),\
                    $(shell git -c safe.directory=$(CURDIR) ls-files src),\
                    $(shell find src -type f))
# An installation's own directories under PREFIX, beside its launcher.
TREE          = $(PREFIX)/lib/$(NAME)
DOC_DIR       = $(PREFIX)/share/doc/$(NAME)

.PHONY: all lib xterm build test examples run smoke doc format release install uninstall clean

all: lib build

# ern unpack names each archive that is not under lib/, and the URL to
# download it from where package.conf gives one (report §11.9).
lib:
	@mkdir -p lib
	$(ERN) unpack
	@for app in $(ERL_DEPS); do \
	    test -f erl/$$app/Makefile || \
	        { echo "erl/$$app is empty: git submodule update --init"; exit 1; }; \
	    $(MAKE) -C erl/$$app || exit 1; \
	done

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
# §11.9).
build:
	$(ERN) build src

# The documents come last, since one may name what the examples wrote.
test: all
	$(ERN) format --check src tools $(wildcard test) $(if $(EXAMPLES),examples)
	$(ERN) test $(RUN_LIBS) build
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

# The directory of the example site's access log is made first, since the
# configuration's access-log stands in a directory that exists.
run: all xterm
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to run"; exit 1; }
	@mkdir -p build/examples/site
	bin/$(NAME) $(CONFIG)

# The smoke test, design §13: Smoke's own compiled form run with the host
# and the deployed configuration as its arguments, since ern run's --main
# names a function of the file's own module alone. A missing HOST is
# refused before the build.
smoke: $(if $(HOST),all)
	@test -n "$(HOST)" || { echo "HOST is required: make smoke HOST=ernest-lang.org"; exit 1; }
	$(ERN) run $(RUN_LIBS) build/smoke.erc $(HOST) deploy/config.json

doc: all
	$(ERN) doc src

format:
	$(ERN) format src tools $(wildcard test) $(if $(EXAMPLES),examples)

# The packages under lib/ copied into $(1)/lib, each directory with its links
# copied through, and neither an archive nor a name that begins with a dot.
packages = for dir in lib/*/; do \
	    test -d "$$dir" || continue; \
	    mkdir -p $(1)/lib && cp -RL "$${dir%/}" $(1)/lib/ || exit 1; \
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
# own Erlang at its top, the packages under lib/, the documents of DOCS, the
# README, the license, deploy/ and examples/ among them, and the Makefile, so
# that make install and make run run in it; every member a directory or a
# regular file. A library's carries its pages as well: those ern doc wrote
# under build/, the one copy a checkout holds, mirrored into docs/man/ with
# the index as its README, and neither the staging directory nor what the
# examples wrote among them. One shape for an application and a library, so
# that any archive can be a dependency. Its checksum stands beside it, for
# `sha256sum -c`. A development build of ern is refused first, before the
# tests and the documents run (design §13).
release:
	@case "$$($(ERN) --version)" in \
	    *-dev|*+*) echo "a release is not made with a development build of ern"; exit 1 ;; esac
	@$(MAKE) --no-print-directory test doc
	@$(privs)
	rm -rf build/$(NAME)-$(VERSION) && mkdir -p build/$(NAME)-$(VERSION)
	mkdir -p build/$(NAME)-$(VERSION)/build && \
	    find build -path build/$(NAME)-$(VERSION) -prune -o -name '*.erc' -print | \
	    cpio -pdm --quiet build/$(NAME)-$(VERSION)/
	@$(call packages,build/$(NAME)-$(VERSION))
	@$(call erlang,build/$(NAME)-$(VERSION))
	test -x bin/$(NAME) && mkdir -p build/$(NAME)-$(VERSION)/bin && \
	    cp bin/$(NAME) build/$(NAME)-$(VERSION)/bin/ || true
	tar chf - $(SOURCES) $(DOCS) Makefile VERSION package.conf | \
	    tar xf - -C build/$(NAME)-$(VERSION)
	test -x bin/$(NAME) || { mkdir -p build/$(NAME)-$(VERSION)/docs/man && cd build && \
	    find . -name '*.md' ! -name index.md ! -path './$(NAME)-*/*' ! -path './examples/*' | \
	    tar cf - -T - | tar xf - -C $(NAME)-$(VERSION)/docs/man && \
	    cp index.md $(NAME)-$(VERSION)/docs/man/README.md; }
	tar -czf build/$(NAME)-$(VERSION).tar.gz -C build $(NAME)-$(VERSION)
	cd build && sha256sum $(NAME)-$(VERSION).tar.gz > $(NAME)-$(VERSION).tar.gz.sha256
	rm -rf build/$(NAME)-$(VERSION)

# What stands built, installed as design §13 lays it out: an installation
# already there replaced whole, so that no module of an older one is left,
# and a launcher there of another program's refused, each refusal before
# anything is removed. The installation is a package, as the archive is,
# which the launcher names its root package. Nothing is built here, so that
# an archive installs as it was compiled.
install:
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to install"; exit 1; }
	@test -f build/$(NAME).erc || { echo "build/$(NAME).erc is not there: make builds it"; exit 1; }
	@test -d $(TREE) || test ! -e $(PREFIX)/bin/$(NAME) || \
	    { echo "$(PREFIX)/bin/$(NAME) is there already and is not this program's"; exit 1; }
	@$(privs)
	rm -rf $(TREE) $(DOC_DIR)
	mkdir -p $(PREFIX)/bin $(TREE) $(DOC_DIR)
	cp bin/$(NAME) $(PREFIX)/bin/$(NAME)
	find build -name '*.erc' ! -path 'build/$(NAME)-*/*' | tar cf - -T - | tar xf - -C $(TREE)
	cp package.conf $(TREE)/package.conf
	@$(call packages,$(TREE))
	@$(call erlang,$(TREE))
	tar cf - $(DOCS) | tar xf - -C $(DOC_DIR)

# What make install put under PREFIX, and nothing else: the launcher, the
# installation's two directories, and then share/doc, share, lib and bin
# under PREFIX, deepest first, each where it is empty, whoever made it; one
# that is not stays, and so does PREFIX itself.
uninstall:
	@test -d $(TREE) || { echo "no installation of $(NAME) under $(PREFIX)"; exit 1; }
	rm -f $(PREFIX)/bin/$(NAME)
	rm -rf $(TREE) $(DOC_DIR)
	@for dir in $(PREFIX)/share/doc $(PREFIX)/share $(PREFIX)/lib $(PREFIX)/bin; do \
	    rmdir $$dir 2>/dev/null || true; \
	done

# The packages ern unpack wrote under lib/ go, each a directory, and so does
# its lock; an archive and a link put there stay.
clean:
	rm -rf build tools/build test/build $(EXAMPLES_MADE)
	test ! -d lib || find lib -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
	rm -f lib/.unpack
