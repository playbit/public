# Skeleton Makefile for the GNU malloc code
#
# Copyright (C) 1996-2021 Free Software Foundation, Inc.

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

srcdir = .

topdir = ../..
BUILD_DIR = /tmp/bash-5.2.26

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644

CC = /build/toolchain/bin/clang
RANLIB = ranlib
AR = ar
ARFLAGS = cr
RM = rm -f
CP = cp
MV = mv

SHELL = /bin/sh

PROFILE_FLAGS = 

CFLAGS = --target=aarch64-playbit -Wno-deprecated-non-prototype
LOCAL_CFLAGS = 
STYLE_CFLAGS = 
CPPFLAGS = --target=aarch64-playbit
LDFLAGS = -L/build/distroot-aarch64/lib

DEFS = -DHAVE_CONFIG_H
LOCAL_DEFS = -DSHELL

LIBBUILD = ${BUILD_DIR}/lib

BASHINCDIR = ${topdir}/include

INTL_LIBSRC = ${topdir}/lib/intl
INTL_BUILDDIR = ${LIBBUILD}/intl
INTL_INC = 
LIBINTL_H = 

INCLUDES = -I. -I../.. -I$(topdir) -I$(BASHINCDIR) -I$(topdir)/lib $(INTL_INC)

CCFLAGS = ${PROFILE_FLAGS} ${INCLUDES} $(DEFS) $(LOCAL_DEFS) $(LOCAL_CFLAGS) \
	  $(CFLAGS) $(MALLOC_CFLAGS) $(STYLE_CFLAGS) $(CPPFLAGS)

.c.o:
	$(CC) $(CCFLAGS) -c $<

.s.o:
	$(CC) $(CCFLAGS) -c $<

MALLOC_SOURCE = malloc.c
STUB_SOURCE = stub.c

ALLOCA_SOURCE = alloca.c
ALLOCA_OBJECT = alloca.o

MALLOC_SRC = 
MALLOC = @MALLOC@
ALLOCA = 

MALLOC_OBJS = malloc.o $(ALLOCA) trace.o stats.o table.o watch.o
STUB_OBJS = $(ALLOCA) stub.o

.PHONY:		malloc stubmalloc

all:		malloc

malloc: ${MALLOC_OBJS}
	${RM} libmalloc.a
	${AR} ${ARFLAGS} libmalloc.a ${MALLOC_OBJS}
	-test -n "$(RANLIB)" && $(RANLIB) libmalloc.a

stubmalloc: ${STUB_OBJS}
	${RM} libmalloc.a
	${AR} ${ARFLAGS} libmalloc.a ${STUB_OBJS}
	-test -n "$(RANLIB)" && $(RANLIB) libmalloc.a

alloca: ${ALLOCA}
	${RM} libmalloc.a
	${AR} ${ARFLAGS} libmalloc.a ${ALLOCA}
	-test -n "$(RANLIB)" && $(RANLIB) libmalloc.a

alloca.o:	$(srcdir)/$(ALLOCA_SOURCE)
	$(CC) $(CCFLAGS) -c $(srcdir)/$(ALLOCA_SOURCE)
	@- if test "$(ALLOCA_OBJECT)" != alloca.o ; then \
		mv $(ALLOCA_OBJECT) alloca.o >/dev/null 2>&1 ; \
	fi

mostlyclean clean:
	$(RM) *.o libmalloc.a

distclean realclean maintainer-clean: clean
	$(RM) Makefile

alloca.o: $(BUILD_DIR)/config.h
malloc.o: $(BUILD_DIR)/config.h $(topdir)/bashtypes.h getpagesize.h
xmalloc.o: $(BUILD_DIR)/config.h $(BASHINCDIR)/ansi_stdlib.h
trace.o: ${BUILD_DIR}/config.h
stats.o: ${BUILD_DIR}/config.h
table.o: ${BUILD_DIR}/config.h
watch.o: ${BUILD_DIR}/config.h

malloc.o: ${srcdir}/imalloc.h ${srcdir}/mstats.h
malloc.o: ${srcdir}/table.h ${srcdir}/watch.h
stats.o: ${srcdir}/imalloc.h ${srcdir}/mstats.h
trace.o: ${srcdir}/imalloc.h
table.o: ${srcdir}/imalloc.h ${srcdir}/table.h
watch.o: ${srcdir}/imalloc.h ${srcdir}/watch.h

malloc.o: ${topdir}/bashintl.h ${LIBINTL_H} ${BASHINCDIR}/gettext.h
stats.o: ${topdir}/bashintl.h ${LIBINTL_H} ${BASHINCDIR}/gettext.h
trace.o: ${topdir}/bashintl.h ${LIBINTL_H} ${BASHINCDIR}/gettext.h
table.o: ${topdir}/bashintl.h ${LIBINTL_H} ${BASHINCDIR}/gettext.h
watch.o: ${topdir}/bashintl.h ${LIBINTL_H} ${BASHINCDIR}/gettext.h

# Rules for deficient makes, like SunOS and Solaris
stub.o: stub.c
malloc.o: malloc.c
table.o: table.c
trace.o: trace.c
stats.o: stats.c
watch.o: watch.c
