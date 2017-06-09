# VARIABLES

EXTENSION=similarity
PACKAGE=postgresql-$(EXTENSION)
VERSION=$(shell rpm -q --qf '%{version}' --specfile $(PACKAGE).spec)
PACKAGE_VERSION=$(PACKAGE)-$(VERSION)
RPMSPEC=$(PACKAGE).spec
RPMSOURCEDIR=$(shell rpm -E %_sourcedir)
#DISTARCHIVE=$(RPMSOURCEDIR)/$(PACKAGE_VERSION).tar.xz
DISTARCHIVE=$(PACKAGE_VERSION).tar.xz
SRCDIR=src
SOURCES=\
		$(SRCDIR)/fstrcmp.c \
		$(SRCDIR)/fstrcmp.h \
		$(SRCDIR)/$(EXTENSION)_pg.c \
		$(SRCDIR)/$(EXTENSION).control \
		$(SRCDIR)/$(EXTENSION).sql \
		README.md \
		LICENSE \
		Makefile \
		$(PACKAGE).spec

CXXFLAGS=-I$(shell pg_config --includedir-server) $(shell pg_config --cflags) $(shell pg_config --cflags_sl)

export DESTDIR

pgsharedir?=$(DESTDIR)$(shell pg_config --sharedir)
pglibdir?=$(DESTDIR)$(shell pg_config --libdir)
pgdocdir?=$(DESTDIR)$(shell pg_config --docdir)/../$(PACKAGE)

#=============================================================================
# PHONY targets

.PHONY: \
	all \
	test \
	install \
	release-rpm \
	release-tarxz \
	clean

#==============================================================================
# Compile section

all: $(EXTENSION).so

fstrcmp.o: $(SRCDIR)/fstrcmp.c $(SRCDIR)/fstrcmp.h
	$(CC) $(CXXFLAGS) -c $<

$(EXTENSION)_pg.o: $(SRCDIR)/$(EXTENSION)_pg.c $(SRCDIR)/fstrcmp.h
	$(CC) $(CXXFLAGS) -c $<

$(EXTENSION).so: fstrcmp.o $(EXTENSION)_pg.o
	$(CC) $(CXXFLAGS) -shared -Wl,-soname,$(EXTENSION) -licuuc -o $@ $^

#==============================================================================
# Test section

test:

#==============================================================================
# Distribution section

release-tarxz: $(DISTARCHIVE)

$(DISTARCHIVE): $(SOURCES)
	@mkdir -p DISTROOT/
	@ln -fs .. DISTROOT/$(PACKAGE)
	@tar -C DISTROOT -cvJf $@ $(patsubst %,$(PACKAGE)/%,$(SOURCES))
	@$(RM) DISTROOT/$(PACKAGE)
	@rmdir DISTROOT

#==============================================================================
# Distribution section

clean:
	@$(RM) *.o *.so

distclean:
	$(RM) $(PACKAGE).tar.xz

release-rpm: release-tarxz
	rpmbuild -ba --clean $(RPMSPEC)

#==============================================================================
# Install section

install:
	install -d $(pglibdir)
	install $(EXTENSION).so $(pglibdir)
	install -d $(pgdocdir)
	install -m 0644 README.md LICENSE $(pgdocdir)
	install -d $(pgsharedir)/extension/
	install -m 0644 $(SRCDIR)/$(EXTENSION).control $(pgsharedir)/extension
	install -m 0644 $(SRCDIR)/$(EXTENSION).sql $(pgsharedir)/extension/$(EXTENSION)--$(VERSION).sql
