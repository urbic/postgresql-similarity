# VARIABLES

VERSION=1.0
PACKAGE=postgresql92-fstrcmp
PACKAGE_VERSION=$(PACKAGE)-$(VERSION)
RPMSPEC=$(PACKAGE).spec
RPMSOURCEDIR=$(shell rpm -E %_sourcedir)
DISTARCHIVE=$(RPMSOURCEDIR)/$(PACKAGE).tar.xz
SOURCES=\
		fstrcmp.c \
		fstrcmp.h \
		fstrcmp_pg.c \
		fstrcmp.sql \
		uninstall_fstrcmp.sql \
		README.fstrcmp \
		Makefile \
		$(PACKAGE).spec

CXXFLAGS=-I$(shell pg_config --includedir-server)

export DESTDIR

pgsharedir?=$(DESTDIR)$(shell pg_config --sharedir)
pglibdir?=$(DESTDIR)$(shell pg_config --libdir)
pgdocdir?=$(DESTDIR)$(shell pg_config --docdir)-fstrcmp

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

all: fstrcmp.so

fstrcmp.o: fstrcmp.c fstrcmp.h
	$(CC) $(CXXFLAGS) -fpic -c $<

fstrcmp_pg.o: fstrcmp_pg.c fstrcmp.h
	$(CC) $(CXXFLAGS) -fpic -c $<

fstrcmp.so: fstrcmp.o fstrcmp_pg.o
	$(CC) $(CXXFLAGS) -shared -licuuc -o $@ $^

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
	install fstrcmp.so $(pglibdir)
	install -d $(pgdocdir)
	install -m 0644 README.fstrcmp $(pgdocdir)
	install -d $(pgsharedir)/fstrcmp/
	install -m 0644 fstrcmp.sql uninstall_fstrcmp.sql $(pgsharedir)/fstrcmp/
