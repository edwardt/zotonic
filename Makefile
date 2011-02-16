ERL          ?= erl
ERLC          = erlc
EBIN_DIRS    := $(wildcard deps/*/ebin)
APP          := zotonic
PARSER        =src/erlydtl/erlydtl_parser

all: gen_smtp z_logger mochiweb webmachine erlang-oauth module-deps priv-module-deps $(PARSER).erl erl ebin/$(APP).app 

erl:
	@$(ERL) -pa $(EBIN_DIRS) -pa ebin -noinput +B \
	  -eval 'case make:all() of up_to_date -> halt(0); error -> halt(1) end.'

$(PARSER).erl: $(PARSER).yrl
	$(ERLC) -o src/erlydtl src/erlydtl/erlydtl_parser.yrl

gen_smtp:
	cd deps/gen_smtp && $(MAKE)

z_logger:
	cd deps/z_logger && $(MAKE)

mochiweb:
	cd deps/mochiweb && $(MAKE)

webmachine:
	cd deps/webmachine && $(MAKE)

erlang-oauth:
	cd deps/erlang-oauth && $(MAKE)

module-deps:
	if [ "`find modules/ -name Makefile`" != "" ]; then for f in "`ls modules/*/Makefile`"; do echo $$f; $(MAKE) -C `dirname $$f`; done; fi

priv-module-deps:
	if [ "`find priv/modules/ -name Makefile`" != "" ]; then for f in "`ls priv/modules/*/Makefile`"; do echo $$f; $(MAKE) -C `dirname $$f`; done; fi

docs:
	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'

clean: 
	@echo "removing:"
	(cd deps/gen_smtp; $(MAKE) clean)
	(cd deps/z_logger; $(MAKE) clean)
	(cd deps/mochiweb; $(MAKE) clean)
	(cd deps/webmachine; $(MAKE) clean)
	(cd deps/erlang-oauth; $(MAKE) clean)
	if [ "`find modules/ -name Makefile`" != "" ]; then for f in "`ls modules/*/Makefile`"; do echo $$f; $(MAKE) -C `dirname $$f` clean; done; fi
	if [ "`find priv/modules/ -name Makefile`" != "" ]; then for f in "`ls priv/modules/*/Makefile`"; do echo $$f; $(MAKE) -C `dirname $$f` clean; done; fi
	rm -f ebin/*.beam ebin/*.app
	rm -f erl_crash.dump $(PARSER).erl
	rm -f priv/log/*

ebin/$(APP).app:
	cp src/$(APP).app $@

