MODULE_big=similarity
OBJS=\
	similarity_pg.o \
	fstrcmp.o \
	$(NULL)

EXTENSION=similarity
DATA=\
	$(EXTENSION)--1.0.sql \
	$(NULL)

EXTRA_CLEAN+=-r $(RPM_BUILD_ROOT)

PG_CPPFLAGS+=-fPIC
fstrcmp.o: override CFLAGS+=-std=c99

ifdef DEBUG
COPT+=-O0
CXXFLAGS+=-g -O0
endif

SHLIB_LINK+=-licuuc

REGRESS=1

ifndef PG_CONFIG
PG_CONFIG=pg_config
endif

PGXS:=$(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
