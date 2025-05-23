# Makefile for directory with message catalog handling library of GNU gettext
# Copyright (C) 1995-1998, 2000-2003, 2008,2009 Free Software Foundation, Inc.
#

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

PACKAGE = bash
VERSION = 5.2-release

SHELL = /bin/sh

srcdir = .
top_srcdir = ../..
top_builddir = /tmp/bash-5.2.26


prefix = /usr
exec_prefix = ${prefix}
transform = s,x,x,

datarootdir = ${prefix}/share

libdir = /lib
includedir = ${prefix}/include
datadir = ${datarootdir}
localedir = ${datarootdir}/locale

gettextsrcdir = $(datadir)/gettext/intl
aliaspath = $(localedir)
subdir = intl



INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
MKINSTALLDIRS = @MKINSTALLDIRS@
mkinstalldirs = $(SHELL) $(MKINSTALLDIRS)

l = 

AR = ar
CC = /build/toolchain/bin/clang
LIBTOOL = @LIBTOOL@
RANLIB = ranlib
YACC = bison -y -d
YFLAGS = --name-prefix=__gettext

ARFLAGS = cr

LOCAL_DEFS = -DSHELL

DEFS = -DLOCALEDIR=\"$(localedir)\" -DLOCALE_ALIAS_PATH=\"$(aliaspath)\" \
-DLIBDIR=\"$(prefix)/libdata\" -DIN_LIBINTL \
-DENABLE_RELOCATABLE=1 -DIN_LIBRARY -DINSTALLDIR=\"$(libdir)\" -DNO_XMALLOC \
-Dset_relocation_prefix=libintl_set_relocation_prefix \
-Drelocate=libintl_relocate \
-DDEPENDS_ON_LIBICONV=1 -DHAVE_CONFIG_H ${LOCAL_DEFS}
CPPFLAGS = --target=aarch64-playbit
CFLAGS = --target=aarch64-playbit -Wno-deprecated-non-prototype
LDFLAGS = -L/build/distroot-aarch64/lib
LIBS = -ldl 

COMPILE = $(CC) -c $(DEFS) $(INCLUDES) $(CPPFLAGS) $(CFLAGS) $(XCFLAGS)

HEADERS = \
  gmo.h \
  gettextP.h \
  hash-string.h \
  loadinfo.h \
  plural-exp.h \
  eval-plural.h \
  localcharset.h \
  relocatable.h \
  os2compat.h \
  libgnuintl.h.in
SOURCES = \
  bindtextdom.c \
  dcgettext.c \
  dgettext.c \
  gettext.c \
  finddomain.c \
  loadmsgcat.c \
  localealias.c \
  textdomain.c \
  l10nflist.c \
  explodename.c \
  dcigettext.c \
  dcngettext.c \
  dngettext.c \
  ngettext.c \
  plural.y \
  plural-exp.c \
  localcharset.c \
  relocatable.c \
  localename.c \
  log.c \
  osdep.c \
  os2compat.c \
  intl-compat.c
OBJECTS = \
  bindtextdom.$lo \
  dcgettext.$lo \
  dgettext.$lo \
  gettext.$lo \
  finddomain.$lo \
  loadmsgcat.$lo \
  localealias.$lo \
  textdomain.$lo \
  l10nflist.$lo \
  explodename.$lo \
  dcigettext.$lo \
  dcngettext.$lo \
  dngettext.$lo \
  ngettext.$lo \
  plural.$lo \
  plural-exp.$lo \
  localcharset.$lo \
  relocatable.$lo \
  localename.$lo \
  log.$lo \
  osdep.$lo \
  intl-compat.$lo
DISTFILES.common = Makefile.in \
config.charset locale.alias ref-add.sin ref-del.sin $(HEADERS) $(SOURCES)
DISTFILES.generated = plural.c
DISTFILES.normal = VERSION
DISTFILES.gettext = COPYING.LIB-2.0 COPYING.LIB-2.1 libintl.glibc \
Makefile.vms libgnuintl.h.msvc-shared README.woe32 Makefile.msvc
DISTFILES.obsolete = xopen-msg.sed linux-msg.sed po2tbl.sed.in cat-compat.c \
COPYING.LIB-2 gettext.h libgettext.h plural-eval.c libgnuintl.h

all: all-no
all-yes: libintl.$la libintl.h charset.alias ref-add.sed ref-del.sed
all-no: all-no-no
all-no-yes: libgnuintl.$la
all-no-no:

libintl.a libgnuintl.a: $(OBJECTS)
	rm -f $@
	$(AR) $(ARFLAGS) $@ $(OBJECTS)
	$(RANLIB) $@

libintl.la libgnuintl.la: $(OBJECTS)
	$(LIBTOOL) --mode=link \
	  $(CC) $(CPPFLAGS) $(CFLAGS) $(XCFLAGS) $(LDFLAGS) -o $@ \
	  $(OBJECTS)  $(LIBS) \
	  -version-info $(LTV_CURRENT):$(LTV_REVISION):$(LTV_AGE) \
	  -rpath $(libdir) \
	  -no-undefined

# Libtool's library version information for libintl.
# Before making a gettext release, the gettext maintainer must change this
# according to the libtool documentation, section "Library interface versions".
# Maintainers of other packages that include the intl directory must *not*
# change these values.
LTV_CURRENT=5
LTV_REVISION=0
LTV_AGE=3

.SUFFIXES:
.SUFFIXES: .c .y .o .lo .sin .sed

.c.o:
	$(COMPILE) $<

.y.c:
	$(YACC) $(YFLAGS) --output $@ $<
	rm -f $*.h

bindtextdom.lo: $(srcdir)/bindtextdom.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/bindtextdom.c
dcgettext.lo: $(srcdir)/dcgettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/dcgettext.c
dgettext.lo: $(srcdir)/dgettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/dgettext.c
gettext.lo: $(srcdir)/gettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/gettext.c
finddomain.lo: $(srcdir)/finddomain.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/finddomain.c
loadmsgcat.lo: $(srcdir)/loadmsgcat.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/loadmsgcat.c
localealias.lo: $(srcdir)/localealias.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/localealias.c
textdomain.lo: $(srcdir)/textdomain.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/textdomain.c
l10nflist.lo: $(srcdir)/l10nflist.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/l10nflist.c
explodename.lo: $(srcdir)/explodename.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/explodename.c
dcigettext.lo: $(srcdir)/dcigettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/dcigettext.c
dcngettext.lo: $(srcdir)/dcngettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/dcngettext.c
dngettext.lo: $(srcdir)/dngettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/dngettext.c
ngettext.lo: $(srcdir)/ngettext.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/ngettext.c
plural.lo: $(srcdir)/plural.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/plural.c
plural-exp.lo: $(srcdir)/plural-exp.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/plural-exp.c
localcharset.lo: $(srcdir)/localcharset.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/localcharset.c
relocatable.lo: $(srcdir)/relocatable.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/relocatable.c
localename.lo: $(srcdir)/localename.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/localename.c
log.lo: $(srcdir)/log.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/log.c
osdep.lo: $(srcdir)/osdep.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/osdep.c
intl-compat.lo: $(srcdir)/intl-compat.c
	$(LIBTOOL) --mode=compile $(COMPILE) $(srcdir)/intl-compat.c

ref-add.sed: $(srcdir)/ref-add.sin
	sed -e '/^#/d' -e 's/@''PACKAGE''@/@PACKAGE@/g' $(srcdir)/ref-add.sin > t-ref-add.sed
	mv t-ref-add.sed ref-add.sed
ref-del.sed: $(srcdir)/ref-del.sin
	sed -e '/^#/d' -e 's/@''PACKAGE''@/@PACKAGE@/g' $(srcdir)/ref-del.sin > t-ref-del.sed
	mv t-ref-del.sed ref-del.sed

INCLUDES = -I. -I$(srcdir) -I${top_builddir} -I${top_srcdir}

libgnuintl.h: $(srcdir)/libgnuintl.h.in
	cp $(srcdir)/libgnuintl.h.in libgnuintl.h

libintl.h: libgnuintl.h
	cmp libgnuintl.h libintl.h || cp libgnuintl.h libintl.h

charset.alias: $(srcdir)/config.charset
	$(SHELL) $(srcdir)/config.charset 'aarch64-unknown-linux-musl' > t-$@
	mv t-$@ $@

check: all

# We must not install the libintl.h/libintl.a files if we are on a
# system which has the GNU gettext() function in its C library or in a
# separate library.
# If you want to use the one which comes with this version of the
# package, you have to use `configure --with-included-gettext'.
install: install-exec install-data
install-exec: all
	if { test "$(PACKAGE)" = "gettext-runtime" || test "$(PACKAGE)" = "gettext-tools"; } \
	   && test 'no' = yes; then \
	  $(mkinstalldirs) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir); \
	  $(INSTALL_DATA) libintl.h $(DESTDIR)$(includedir)/libintl.h; \
	  $(LIBTOOL) --mode=install \
	    $(INSTALL_DATA) libintl.$la $(DESTDIR)$(libdir)/libintl.$la; \
	  if test "@RELOCATABLE@" = yes; then \
	    dependencies=`sed -n -e 's,^dependency_libs=\(.*\),\1,p' < $(DESTDIR)$(libdir)/libintl.la | sed -e "s,^',," -e "s,'\$$,,"`; \
	    if test -n "$dependencies"; then \
	      rm -f $(DESTDIR)$(libdir)/libintl.la; \
	    fi; \
	  fi; \
	else \
	  : ; \
	fi
	if test "$(PACKAGE)" = "gettext-tools" \
	   && test 'no' = no; then \
	  $(mkinstalldirs) $(DESTDIR)$(libdir); \
	  $(LIBTOOL) --mode=install \
	    $(INSTALL_DATA) libgnuintl.$la $(DESTDIR)$(libdir)/libgnuintl.$la; \
	  rm -f $(DESTDIR)$(libdir)/preloadable_libintl.so; \
	  $(INSTALL_DATA) $(DESTDIR)$(libdir)/libgnuintl.so $(DESTDIR)$(libdir)/preloadable_libintl.so; \
	  $(LIBTOOL) --mode=uninstall \
	    rm -f $(DESTDIR)$(libdir)/libgnuintl.$la; \
	else \
	  : ; \
	fi
	if test 'no' = yes; then \
	  $(mkinstalldirs) $(DESTDIR)$(localedir); \
	  test -f $(DESTDIR)$(localedir)/locale.alias \
	    && orig=$(DESTDIR)$(localedir)/locale.alias \
	    || orig=$(srcdir)/locale.alias; \
	  temp=$(DESTDIR)$(localedir)/t-locale.alias; \
	  dest=$(DESTDIR)$(localedir)/locale.alias; \
	  sed -f ref-add.sed $$orig > $$temp; \
	  $(INSTALL_DATA) $$temp $$dest; \
	  rm -f $$temp; \
	else \
	  : ; \
	fi
install-data: all
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
	  $(INSTALL_DATA) VERSION $(DESTDIR)$(gettextsrcdir)/VERSION; \
	  $(INSTALL_DATA) ChangeLog.inst $(DESTDIR)$(gettextsrcdir)/ChangeLog; \
	  dists="COPYING.LIB-2.0 COPYING.LIB-2.1 $(DISTFILES.common)"; \
	  for file in $$dists; do \
	    $(INSTALL_DATA) $(srcdir)/$$file \
			    $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	  chmod a+x $(DESTDIR)$(gettextsrcdir)/config.charset; \
	  dists="$(DISTFILES.generated)"; \
	  for file in $$dists; do \
	    if test -f $$file; then dir=.; else dir=$(srcdir); fi; \
	    $(INSTALL_DATA) $$dir/$$file \
			    $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	  dists="$(DISTFILES.obsolete)"; \
	  for file in $$dists; do \
	    rm -f $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	else \
	  : ; \
	fi

install-strip: install

installdirs:
	if { test "$(PACKAGE)" = "gettext-runtime" || test "$(PACKAGE)" = "gettext-tools"; } \
	   && test 'no' = yes; then \
	  $(mkinstalldirs) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir); \
	else \
	  : ; \
	fi
	if test "$(PACKAGE)" = "gettext-tools" \
	   && test 'no' = no; then \
	  $(mkinstalldirs) $(DESTDIR)$(libdir); \
	else \
	  : ; \
	fi
	if test 'no' = yes; then \
	  test no != no || $(mkinstalldirs) $(DESTDIR)$(libdir); \
	  $(mkinstalldirs) $(DESTDIR)$(localedir); \
	else \
	  : ; \
	fi
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  $(mkinstalldirs) $(DESTDIR)$(gettextsrcdir); \
	else \
	  : ; \
	fi

# Define this as empty until I found a useful application.
installcheck:

uninstall:
	if { test "$(PACKAGE)" = "gettext-runtime" || test "$(PACKAGE)" = "gettext-tools"; } \
	   && test 'no' = yes; then \
	  rm -f $(DESTDIR)$(includedir)/libintl.h; \
	  $(LIBTOOL) --mode=uninstall \
	    rm -f $(DESTDIR)$(libdir)/libintl.$la; \
	else \
	  : ; \
	fi
	if test "$(PACKAGE)" = "gettext-tools" \
	   && test 'no' = no; then \
	  rm -f $(DESTDIR)$(libdir)/preloadable_libintl.so; \
	else \
	  : ; \
	fi
	if test 'no' = yes; then \
	  if test -f $(DESTDIR)$(prefix)/libdata/charset.alias; then \
	    temp=$(DESTDIR)$(prefix)/libdata/t-charset.alias; \
	    dest=$(DESTDIR)$(prefix)/libdata/charset.alias; \
	    sed -f ref-del.sed $$dest > $$temp; \
	    if grep '^# Packages using this file: $$' $$temp > /dev/null; then \
	      rm -f $$dest; \
	    else \
	      $(INSTALL_DATA) $$temp $$dest; \
	    fi; \
	    rm -f $$temp; \
	  fi; \
	  if test -f $(DESTDIR)$(localedir)/locale.alias; then \
	    temp=$(DESTDIR)$(localedir)/t-locale.alias; \
	    dest=$(DESTDIR)$(localedir)/locale.alias; \
	    sed -f ref-del.sed $$dest > $$temp; \
	    if grep '^# Packages using this file: $$' $$temp > /dev/null; then \
	      rm -f $$dest; \
	    else \
	      $(INSTALL_DATA) $$temp $$dest; \
	    fi; \
	    rm -f $$temp; \
	  fi; \
	else \
	  : ; \
	fi
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  for file in VERSION ChangeLog COPYING.LIB-2.0 COPYING.LIB-2.1 $(DISTFILES.common) $(DISTFILES.generated); do \
	    rm -f $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	else \
	  : ; \
	fi

info dvi ps pdf html:

$(OBJECTS): ${top_builddir}/config.h libgnuintl.h
bindtextdom.$lo dcgettext.$lo dcigettext.$lo dcngettext.$lo dgettext.$lo dngettext.$lo finddomain.$lo gettext.$lo intl-compat.$lo loadmsgcat.$lo localealias.$lo ngettext.$lo textdomain.$lo: $(srcdir)/gettextP.h $(srcdir)/gmo.h $(srcdir)/loadinfo.h
dcigettext.$lo loadmsgcat.$lo: $(srcdir)/hash-string.h
explodename.$lo l10nflist.$lo: $(srcdir)/loadinfo.h
dcigettext.$lo loadmsgcat.$lo plural.$lo plural-exp.$lo: $(srcdir)/plural-exp.h
dcigettext.$lo: $(srcdir)/eval-plural.h
localcharset.$lo: $(srcdir)/localcharset.h
localealias.$lo localcharset.$lo relocatable.$lo: $(srcdir)/relocatable.h

tags: TAGS

TAGS: $(HEADERS) $(SOURCES)
	here=`pwd`; cd $(srcdir) && etags -o $$here/TAGS $(HEADERS) $(SOURCES)

ctags: CTAGS

CTAGS: $(HEADERS) $(SOURCES)
	here=`pwd`; cd $(srcdir) && ctags -o $$here/CTAGS $(HEADERS) $(SOURCES)

id: ID

ID: $(HEADERS) $(SOURCES)
	here=`pwd`; cd $(srcdir) && mkid -f$$here/ID $(HEADERS) $(SOURCES)


mostlyclean:
	rm -f *.a *.la *.o *.obj *.lo core core.*
	rm -f libgnuintl.h libintl.h charset.alias ref-add.sed ref-del.sed
	rm -f -r .libs _libs

clean: mostlyclean

distclean: clean
	rm -f Makefile ID TAGS
	if test "$(PACKAGE)" = "gettext-runtime" || test "$(PACKAGE)" = "gettext-tools"; then \
	  rm -f ChangeLog.inst $(DISTFILES.normal); \
	else \
	  : ; \
	fi

maintainer-clean: distclean
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."


# GNU gettext needs not contain the file `VERSION' but contains some
# other files which should not be distributed in other packages.
distdir = ../$(PACKAGE)-$(VERSION)/$(subdir)
dist distdir: Makefile
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  : ; \
	else \
	  if test "$(PACKAGE)" = "gettext-runtime"; then \
	    additional="$(DISTFILES.gettext)"; \
	  else \
	    additional="$(DISTFILES.normal)"; \
	  fi; \
	  $(MAKE) $(DISTFILES.common) $(DISTFILES.generated) $$additional; \
	  for file in ChangeLog $(DISTFILES.common) $(DISTFILES.generated) $$additional; do \
	    if test -f $$file; then dir=.; else dir=$(srcdir); fi; \
	    cp -p $$dir/$$file $(distdir); \
	  done; \
	fi

Makefile: $(srcdir)/Makefile.in $(top_builddir)/config.status
	cd $(top_builddir) && $(SHELL) ./config.status
# This would be more efficient, but doesn't work any more with autoconf-2.57,
# when AC_CONFIG_FILES([intl/Makefile:somedir/Makefile.in]) is used.
#	cd $(top_builddir) && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
