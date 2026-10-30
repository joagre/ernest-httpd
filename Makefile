# The program's build and tests: one Makefile, the same targets in every
# application begun from ernest-template. The four variables an application
# edits stand first; the rest is the same everywhere.
#
#   make          builds: the floor checked, lib/ filled, each dependency and
#                 then the program compiled
#   make test     the layout, the tests of every module, the documents and
#                 the design's citations, test/ where it exists, and each
#                 program of examples/ where it exists, built and run
#   make run      runs the program through its launcher
#   make lib      fills lib/: each dependency fetched and unpacked where it is
#                 not there, and each Erlang application under erl/ built by
#                 its own make and linked
#   make doc      the documentation of every module, as CommonMark under build/
#   make man      the pages copied into docs/man/, which a library's release
#                 commits, its index the directory's README
#   make format   lays every module out
#   make release  the archive, build/NAME-VERSION.tar.gz, tests first
#   make clean    removes what the build and make lib wrote

NAME        = ernest_httpd
ERN_VERSION = 0.6
DEPS        =
ERL_DEPS    =
# What each program of examples/ writes, named by make test: the suffix of
# the one path it is given.
EXAMPLE_SUFFIX =

# The ern on PATH, or ERN=path/to/ern.
ERN        ?= ern

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

.PHONY: all version lib build test run doc man format release clean

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

# Each dependency is built by this ern from its source, in the order DEPS
# lists them, a dependency before what needs it; then the program.
build:
	@for dir in $(DEP_DIRS); do \
	    $(ERN) build --source-root $$dir/src --build-root $$dir/build $(LOAD_PATH) \
	        $$dir/src || exit 1; \
	done
	$(ERN) build --source-root src --build-root build $(LOAD_PATH) src

test: all
	$(ERN) format --check src tools $(wildcard test) $(wildcard examples)
	$(ERN) test $(RUN_LOAD_PATH) build
	$(ERN) build --source-root tools --build-root tools/build tools
	$(ERN) test tools/build
	$(ERN) run tools/build/docs.erc
	@if test -d test; then \
	    $(ERN) build --source-root test --build-root test/build --load-path build \
	        $(LOAD_PATH) test && \
	    $(ERN) test --load-path build $(RUN_LOAD_PATH) test/build; \
	fi
	@if test -d examples; then \
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

run: all
	@test -x bin/$(NAME) || { echo "$(NAME) is a library: nothing to run"; exit 1; }
	bin/$(NAME)

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
	$(ERN) format src tools $(wildcard test) $(wildcard examples)

# The archive unpacks to NAME-VERSION/: the launcher where there is one, the
# source and the compiled modules, lib/ with each link copied through, the
# README and the licenses, the third parties' where there are any. One shape
# for an application and a library, so
# that any archive can be a dependency.
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
	cp README.md LICENSE build/$(NAME)-$(VERSION)/
	test -f THIRD_PARTY_LICENSES && cp THIRD_PARTY_LICENSES build/$(NAME)-$(VERSION)/ || true
	tar -czf build/$(NAME)-$(VERSION).tar.gz -C build $(NAME)-$(VERSION)
	rm -rf build/$(NAME)-$(VERSION)

clean:
	rm -rf build tools/build test/build examples/build lib
