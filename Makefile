MODULE_big=similarity
OBJS=similarity_pg.o fstrcmp.o
DOCS=README.md LICENSE
REGRESS=1

EXTENSION=similarity
EXTVERSION=1.0
DATA=\
	$(EXTENSION)--$(EXTVERSION).sql \
	$(NULL)

EXTRA_CLEAN+=-r $(RPM_BUILD_ROOT)

PG_CPPFLAGS+=-fPIC
fstrcmp.o: override CFLAGS+=-std=c99

ifdef DEBUG
COPT+=-O0
CXXFLAGS+=-g -O0
endif

SHLIB_LINK+=-Wl,-soname,$(EXTENSION) -licuuc


PG_CONFIG?=pg_config
PGXS:=$(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

release:
	@STASHID=$$(git stash create); \
	git archive -v --prefix postgresql-$(EXTENSION)-$(EXTVERSION)/ -o postgresql-$(EXTENSION)-$(EXTVERSION).tar.xz $${STASHID:-HEAD}
