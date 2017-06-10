MODULE_big=similarity
OBJS=similarity_pg.o fstrcmp.o
DOCS=README.md LICENSE
REGRESS=1

EXTENSION=similarity
PACKAGE=postgresql-$(EXTENSION)
PACKAGE_SUMMARY='PostgreSQL extension that calculates similarity between two strings'
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

### OBS infrastructure

.PHONY: release obs-build obs-checkin

DISTRIBUTION?=openSUSE_Leap_42.2
DISTRIBUTION_BUILD_OPTS=$(if $(or $(findstring Fedora,$(DISTRIBUTION)),$(findstring Mageia,$(DISTRIBUTION))),--noverify,)
OBS_HOME=obs-home
OBS_FILES=\
	$(PACKAGE)-$(EXTVERSION).tar.xz \
	$(PACKAGE).changes \
	$(PACKAGE).spec \
	$(PACKAGE).dsc \
	debian.changelog \
	debian.compat \
	debian.copyright \
	debian.control \
	debian.rules \
	$(NULL)

release: $(PACKAGE)-$(EXTVERSION).tar.xz

$(PACKAGE)-$(EXTVERSION).tar.xz: $(shell git ls-files)
	@STASHID=$(shell git stash create); \
	git archive -v --prefix $(@:.tar.xz=/) -o $@ $${STASHID:-HEAD}

obs-checkin: $(OBS_FILES:%=$(OBS_HOME)/%)
	@pushd $(OBS_HOME); osc ar $(OBS_FILES); osc vc; osc ci; popd

obs-build: $(patsubst obs/%,$(OBS_HOME)/%,$(wildcard obs/*)) $(OBS_HOME)/$(PACKAGE)-$(EXTVERSION).tar.xz
	@pushd $(OBS_HOME); osc ar $(OBS_FILES); osc build $(DISTRIBUTION_BUILD_OPTS) $(DISTRIBUTION); popd

$(OBS_HOME)/%: obs/% | $(OBS_HOME)
	@m4 \
		-D__OBS_PACKAGE_NAME__=$(PACKAGE) \
		-D__OBS_PACKAGE_VERSION__=$(EXTVERSION) \
		-D__OBS_PACKAGE_SUMMARY__=$(PACKAGE_SUMMARY) \
		$< > $@

$(OBS_HOME)/$(PACKAGE)-$(EXTVERSION).tar.xz: $(PACKAGE)-$(EXTVERSION).tar.xz | $(OBS_HOME)
	@cp $< $@

$(OBS_HOME)/debian.copyright: LICENSE | $(OBS_HOME)
	@cp $< $@

$(OBS_HOME):
	@osc checkout -o $@ home:concyclic $(PACKAGE)
