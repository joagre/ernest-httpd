# The program's build and tests: one Makefile, the targets of every
# application begun from ernest-template and two of this program's own, make
# xterm, for its example site, and make smoke, for the deployed site. The
# variables an application edits stand first.
#
#   make          builds: the floor checked, lib/ filled, each dependency and
#                 then the program compiled
#   make test     the layout, the tests of every module, the documents and
#                 the design's citations, test/ where it exists, and each
#                 program of examples/ where there is one, built and run
#   make run      runs the example site through the launcher, or the
#                 configuration CONFIG names, CONFIG=path make run
#   make smoke    the smoke test against the deployed site whose canonical
#                 host HOST names, make smoke HOST=ernest-lang.org, the
#                 checks deploy/config.json takes
#   make lib      fills lib/: each dependency fetched and unpacked where it is
#                 not there, and each Erlang application under erl/ built by
#                 its own make and linked
#   make xterm    fills the example site's xterm/: each archive XTERM names
#                 fetched and unpacked where its script is not there
#   make doc      the documentation of every module, as CommonMark under build/
#   make man      the pages copied into docs/man/, which a library's release
#                 commits, its index the directory's README; this program,
#                 not a library, commits none
#   make format   lays every module out
#   make release  the archive, build/NAME-VERSION.tar.gz, tests first
#   make install  installs what stands built under PREFIX, /usr/local by
#                 default, from a checkout or an unpacked archive alike:
#                 the launcher in bin/, build/'s and lib/'s in lib/NAME/,
#                 and the documents in share/doc/NAME/, deploy/ and
#                 examples/ among them
#   make uninstall  removes from PREFIX what make install put there, and the
#                 directories it made where they are empty
#   make clean    removes what the build, make lib and make xterm wrote

NAME        = ernest_httpd
ERN_VERSION = 0.9
DEPS        =
ERL_DEPS    =
# The example site's terminal, xterm.js and its fit addon, each by the URL
# of its npm archive, pinned, as DEPS names a dependency; make xterm copies
# what the shell page loads into examples/site/root/xterm/, which git
# ignores.
XTERM       = https://registry.npmjs.org/@xterm/xterm/-/xterm-5.5.0.tgz \
              https://registry.npmjs.org/@xterm/addon-fit/-/addon-fit-0.10.0.tgz
# What each program of examples/ writes, named by make test: the suffix of
# the one path it is given.
EXAMPLE_SUFFIX =
# The configuration make run serves.
CONFIG     ?= examples/site/config.json

# The ern on PATH, or ERN=path/to/ern.
ERN        ?= ern
# Where make install puts the program and make uninstall removes it from.
PREFIX     ?= /usr/local

# Ernest's own libraries stand on every job's load path; everything else
# beyond the standard library stands under lib/: a dependency's build, and an
# Erlang application's ebin, whose priv/ the host finds beside it. The load
# path is lib/*/build for the modules and --libs-dir lib for the applications,
# here and in the launcher. ern build and ern doc read no application and take
# LOAD_PATH; ern test and ern run take RUN_LOAD_PATH.
LOAD_PATH     = $(addprefix --load-path ,$(shell ls -d lib/*/build 2>/dev/null))
RUN_LOAD_PATH = $(LOAD_PATH) --libs-dir lib
DEP_DIRS      = $(addprefix lib/,$(notdir $(basename $(basename $(DEPS)))))
VERSION       = $(shell cat VERSION)
# The programs of examples/; a site under it is data, and is not built.
EXAMPLES      = $(wildcard examples/*.ern)
# What the build and make xterm write under examples/, which git ignores,
# make clean removes and the documents leave out.
EXAMPLES_MADE = examples/build examples/site/root/xterm
# The documents make install and make release take: README.md, LICENSE,
# CHANGES.md, CLAUDE.md, and under docs/, deploy/ and examples/ the files git
# tracks in a checkout, so that no untracked file goes in, read as whoever installs,
# whose checkout it need not be, which git refuses unless told it is safe; or
# in an unpacked archive every file there but EXAMPLES_MADE's, which make
# release wrote with those.
DOCS          = README.md LICENSE CHANGES.md CLAUDE.md \
                $(if $(wildcard .git),\
                    $(shell git -c safe.directory=$(CURDIR) ls-files docs deploy examples),\
                    $(shell find docs deploy examples -type f \
                        $(foreach dir,$(EXAMPLES_MADE),! -path '$(dir)/*') 2>/dev/null))
# An installation's own directories under PREFIX, beside its launcher.
TREE          = $(PREFIX)/lib/$(NAME)
DOC_DIR       = $(PREFIX)/share/doc/$(NAME)

.PHONY: all version lib xterm build test run smoke doc man format release install uninstall \
        clean

all: version lib build

# The program is written for one floor of ern (report §8.7); a development
# build of the floor passes.
version:
	@command -v $(ERN) >/dev/null 2>&1 || \
	    { echo "no ern on PATH: ERN=path/to/ern make, or put Ernest's bin on PATH"; exit 1; }
	@found=$$($(ERN) --version) && \
	case "$$found" in "ern $(ERN_VERSION)."*) ;; \
	    *) echo "ern $(ERN_VERSION) expected, $$found found"; exit 1 ;; esac

lib:
	@mkdir -p lib
	@for url in $(DEPS); do \
	    dir=lib/$$(basename $$url .tar.gz); \
	    test -d $$dir && continue; \
	    echo "fetching $$url" && curl -fsSL "$$url" | tar -xzf - -C lib || exit 1; \
	done
	@for app in $(ERL_DEPS); do \
	    test -f erl/$$app/Makefile || \
	        { echo "erl/$$app is empty: git submodule update --init"; exit 1; }; \
	    $(MAKE) -C erl/$$app || exit 1; \
	    mkdir -p lib/$$app && \
	    for part in ebin priv; do \
	        test -e erl/$$app/$$part || continue; \
	        test -e lib/$$app/$$part || ln -s ../../erl/$$app/$$part lib/$$app/$$part; \
	    done; \
	done

# Each archive of XTERM, where its package's script is not in the site's
# xterm/, fetched and unpacked under build/, and its license, as
# NAME.js.LICENSE.txt, its stylesheets, css/*.css, and last its script,
# lib/NAME.js, copied there; NAME is the archive's name without its version.
# The unpacked archive is then removed, so that make man finds none of its
# pages.
xterm:
	@mkdir -p examples/site/root/xterm
	@for url in $(XTERM); do \
	    archive=$$(basename $$url .tgz); \
	    name=$${archive%-*}; \
	    test -f examples/site/root/xterm/$$name.js && continue; \
	    dir=build/$$archive; \
	    rm -rf $$dir && mkdir -p $$dir && \
	    echo "fetching $$url" && curl -fsSL "$$url" | tar -xzf - -C $$dir || exit 1; \
	    cp $$dir/package/LICENSE examples/site/root/xterm/$$name.js.LICENSE.txt || exit 1; \
	    for file in $$dir/package/css/*.css $$dir/package/lib/$$name.js; do \
	        test -f $$file || continue; \
	        cp $$file examples/site/root/xterm/ || exit 1; \
	    done; \
	    rm -rf $$dir; \
	done

# Each dependency is built by this ern from its source, in the order DEPS
# lists them, a dependency before what needs it; then the program.
build:
	@for dir in $(DEP_DIRS); do \
	    $(ERN) build --source-root $$dir/src --build-root $$dir/build $(LOAD_PATH) \
	        $$dir/src || exit 1; \
	done
	$(ERN) build --source-root src --build-root build $(LOAD_PATH) src

test: all
	$(ERN) format --check src tools $(wildcard test) $(if $(EXAMPLES),examples)
	$(ERN) test $(RUN_LOAD_PATH) build
	$(ERN) build --source-root tools --build-root tools/build tools
	$(ERN) test tools/build
	$(ERN) run tools/build/docs.erc
	@if test -d test; then \
	    $(ERN) build --source-root test --build-root test/build --load-path build \
	        $(LOAD_PATH) test && \
	    $(ERN) test --load-path build $(RUN_LOAD_PATH) test/build; \
	fi
	@if test -n "$(EXAMPLES)"; then \
	    $(ERN) build --source-root examples --build-root examples/build --load-path build \
	        $(LOAD_PATH) examples && \
	    mkdir -p build/examples && \
	    for program in examples/build/*.erc; do \
	        name=$$(basename $$program .erc); \
	        $(ERN) run --load-path build $(RUN_LOAD_PATH) $$program \
	            build/examples/$$name$(EXAMPLE_SUFFIX) || exit 1; \
	        echo "examples/$$name.ern wrote build/examples/$$name$(EXAMPLE_SUFFIX)"; \
	    done; \
	fi

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
	$(ERN) run $(RUN_LOAD_PATH) build/smoke.erc $(HOST) deploy/config.json

doc: all
	$(ERN) doc --source-root src --build-root build $(LOAD_PATH) src

# The pages ern doc wrote under build/, mirrored into docs/man/ as Ernest's
# make man mirrors its own; the release archive's staging directory is left
# out, and the index becomes the README.
man: doc
	@rm -rf docs/man && mkdir -p docs/man
	@cd build && find . -name '*.md' ! -name index.md ! -path './$(NAME)-*/*' | \
	    tar cf - -T - | (cd ../docs/man && tar xf -)
	@cp build/index.md docs/man/README.md

format:
	$(ERN) format src tools $(wildcard test) $(if $(EXAMPLES),examples)

# The archive unpacks to NAME-VERSION/: the launcher where there is one, the
# source and the compiled modules, lib/ with each link copied through, the
# documents of DOCS, the README, the license, deploy/ and examples/ among
# them, the third parties' licenses where there are any, and the Makefile
# with VERSION, so that make install and make run run in it. One shape
# for an application and a library, so that any archive can be a
# dependency.
release: test
	@case "$$($(ERN) --version)" in \
	    *-dev) echo "a release is not made with a development build of ern"; exit 1 ;; esac
	rm -rf build/$(NAME)-$(VERSION) && mkdir -p build/$(NAME)-$(VERSION)
	cp -R src build/$(NAME)-$(VERSION)/src
	mkdir -p build/$(NAME)-$(VERSION)/build && \
	    find build -path build/$(NAME)-$(VERSION) -prune -o -name '*.erc' -print | \
	    cpio -pdm --quiet build/$(NAME)-$(VERSION)/
	test -d lib && cp -RL lib build/$(NAME)-$(VERSION)/lib || true
	test -x bin/$(NAME) && mkdir -p build/$(NAME)-$(VERSION)/bin && \
	    cp bin/$(NAME) build/$(NAME)-$(VERSION)/bin/ || true
	tar cf - $(DOCS) Makefile VERSION | \
	    tar xf - -C build/$(NAME)-$(VERSION)
	test -f THIRD_PARTY_LICENSES && cp THIRD_PARTY_LICENSES build/$(NAME)-$(VERSION)/ || true
	tar -czf build/$(NAME)-$(VERSION).tar.gz -C build $(NAME)-$(VERSION)
	rm -rf build/$(NAME)-$(VERSION)

# What stands built, installed as design §13 lays it out: an installation
# already there replaced whole, so that no module of an older one is left,
# and a launcher there of another program's refused. Nothing is built here,
# so that an archive installs as it was compiled.
install:
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to install"; exit 1; }
	@test -f build/$(NAME).erc || { echo "build/$(NAME).erc is not there: make builds it"; exit 1; }
	@test -d $(TREE) || test ! -e $(PREFIX)/bin/$(NAME) || \
	    { echo "$(PREFIX)/bin/$(NAME) is there already and is not this program's"; exit 1; }
	rm -rf $(TREE) $(DOC_DIR)
	mkdir -p $(PREFIX)/bin $(TREE) $(DOC_DIR)
	cp bin/$(NAME) $(PREFIX)/bin/$(NAME)
	find build -name '*.erc' ! -path 'build/$(NAME)-*/*' | tar cf - -T - | tar xf - -C $(TREE)
	test ! -d lib || cp -RL lib $(TREE)/lib
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

clean:
	rm -rf build tools/build test/build lib $(EXAMPLES_MADE)
