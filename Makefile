# VARIABLES

EXTENSION=similarity
PACKAGE=postgresql-$(EXTENSION)
VERSION=$(shell rpm -q --qf '%{version}' --specfile $(PACKAGE).spec)
PACKAGE_VERSION=$(PACKAGE)-$(VERSION)
RPMSPEC=$(PACKAGE).spec
RPMSOURCEDIR=$(shell rpm -E %_sourcedir)
DISTARCHIVE=$(RPMSOURCEDIR)/$(PACKAGE_VERSION).tar.xz
SOURCES=\
		fstrcmp.c \
		fstrcmp.h \
		$(EXTENSION)_pg.c \
		$(EXTENSION).control \
		$(EXTENSION)--$(VERSION).sql \
		README.md \
		Makefile \
		$(PACKAGE).spec

CXXFLAGS=-I$(shell pg_config --includedir-server)

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
	release-tarzx \
	clean

#==============================================================================
# Compile section

all: $(EXTENSION).so

fstrcmp.o: fstrcmp.c fstrcmp.h
	$(CC) $(CXXFLAGS) -fpic -c $<

$(EXTENSION)_pg.o: $(EXTENSION)_pg.c fstrcmp.h
	$(CC) $(CXXFLAGS) -fpic -c $<

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

release-rpm: release-tarzx
	rpmbuild -ba --clean $(RPMSPEC)

#==============================================================================
# Install section

install:
	install -d $(pglibdir)
	install $(EXTENSION).so $(pglibdir)
	install -d $(pgdocdir)
	install -m 0644 README.md $(pgdocdir)
	install -d $(pgsharedir)/extension/
	install -m 0644 $(EXTENSION).control $(EXTENSION)--$(VERSION).sql $(pgsharedir)/extension
