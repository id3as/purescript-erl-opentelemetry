.PHONY: all test erl ci clean cleandist

PS_SRC = src
TEST_SRC = test

PS_SOURCEFILES = $(shell find ${PS_SRC} -type f -name \*.purs)
PS_ERL_FFI = $(shell find ${PS_SRC} -type f -name \*.erl)
PS_TEST_SOURCEFILES = $(shell find ${TEST_SRC} -type f -name \*.purs)
PS_TEST_ERL_FFI = $(shell find ${TEST_SRC} -type f -name \*.erl)


.DEFAULT_GOAL := erl

all: erl docs

ci: all test

output/.complete: .spago $(PS_SOURCEFILES) $(PS_ERL_FFI)
	spago build
	touch output/.complete

testoutput/.complete: .spago $(PS_SOURCEFILES) $(PS_ERL_FFI) $(PS_TEST_SOURCEFILES) $(PS_TEST_ERL_FFI)
	# Should be able to just use the below, but spago does not pass the testouput directory through to the purs backend
	# spago -x test.dhall build --purs-args "-o testoutput"
	# Start of workaround ------------------------------------
	spago -x test.dhall sources | xargs purs compile -o testoutput --codegen corefn
	purerl -o testoutput
	# End  of workaround -------------------------------------
	touch testoutput/.complete

.spago: spago.dhall test.dhall packages.dhall
	spago install
	spago -x test.dhall install
	touch .spago

erl: output/.complete
	rebar3 as dist_profile compile

test: testoutput/.complete
	rebar3 as test_profile compile
	erl -pa ebin -pa _build/test_profile/lib/*/ebin -noshell -eval '(test_main@ps:main())()' -eval 'init:stop()'

clean:
	rebar3 as dist_profile clean
	rebar3 as test_profile clean
	rm -rf output testoutput

distclean: clean
	rm -rf .spago _build