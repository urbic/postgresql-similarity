PSQL=psql
TEST_DB=hll_regress

SQL=$(wildcard *.sql)
OUT:=$(SQL:%.sql=%.out)

PSQLOPTS=-X --echo-all -P null=NULL
PGOPTIONS=--client-min-messages=warning

all: $(OUT)
	@find . -maxdepth 1 -name '*.diff' -print -quit > failures
	@if test -s failures; then \
		echo ERROR: `ls -1 *.diff | wc -l` / `ls -1 *.sql | wc -l` tests failed; \
		echo; \
		cat *.diff; \
		exit 1; \
	else \
		rm failures; \
		echo `ls -1 *.out | wc -l` / `ls -1 *.sql | wc -l` tests passed; \
	fi

clean:
	rm -f binary.dat *.out *.diff

%.out:	%.sql %.ref
	@echo -n $*
	@if test -f ../testdata/$*.csv; then \
		PGOPTIONS=$(PGOPTIONS) $(PSQL) $(PSQLOPTS) $(TEST_DB) -f $*.sql < ../testdata/$*.csv > $*.out 2>&1; \
	else \
		PGOPTIONS=$(PGOPTIONS) $(PSQL) $(PSQLOPTS) $(TEST_DB) -f $*.sql > $*.out 2>&1; \
	fi
	@diff -u $*.ref $*.out >> $*.diff || status=1
	@if test -s $*.diff; then \
		echo " .. FAIL"; \
	else \
		echo " .. PASS"; \
		rm -f $*.diff; \
	fi
