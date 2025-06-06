#
# Simple Makefile for the support programs.
#
# documentation support: man2html
# testing support: printenv recho zecho xcase
#
# bashbug.sh lives here (created by configure), but bashbug is created by
# the top-level makefile
#
# Currently only man2html is built
#
# Copyright (C) 1998-2021 Free Software Foundation, Inc.

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

#
# Boilerplate
#
topdir = ..
srcdir = .

BUILD_DIR = /tmp/bash-5.2.26

RM	= rm -f
SHELL	= /bin/sh
CC = /build/toolchain/bin/clang
CC_FOR_BUILD = $(CC)

EXEEXT = 

#
# Compiler options:
#
PROFILE_FLAGS = 

CFLAGS = --target=aarch64-playbit -Wno-deprecated-non-prototype
CFLAGS_FOR_BUILD = --target=aarch64-playbit -Wno-deprecated-non-prototype
BASE_CFLAGS_FOR_BUILD = --target=aarch64-playbit -Wno-deprecated-non-prototype
CPPFLAGS = --target=aarch64-playbit
CPPFLAGS_FOR_BUILD = --target=aarch64-playbit
LOCAL_CFLAGS = 
STYLE_CFLAGS = 
DEFS = -DHAVE_CONFIG_H
LOCAL_DEFS = -DSHELL

LIBS = -ldl 
LIBS_FOR_BUILD = ${LIBS}		# XXX

LOCAL_LDFLAGS = -rdynamic
LDFLAGS = -L/build/distroot-aarch64/lib $(LOCAL_LDFLAGS)
LDFLAGS_FOR_BUILD = $(LDFLAGS) $(LOCAL_LDFLAGS) $(CFLAGS_FOR_BUILD)

INCLUDES = -I${BUILD_DIR} -I${topdir}

BASE_CCFLAGS = ${PROFILE_FLAGS} $(DEFS) $(LOCAL_DEFS) $(SYSTEM_FLAGS) \
	  ${INCLUDES} $(STYLE_CFLAGS) $(LOCAL_CFLAGS)

CCFLAGS = $(BASE_CCFLAGS) $(CPPFLAGS) $(CFLAGS)
CCFLAGS_FOR_BUILD = $(BASE_CCFLAGS) $(CPPFLAGS_FOR_BUILD) $(CFLAGS_FOR_BUILD)

SRC1 =	man2html.c
OBJ1 =	man2html.o

.c.o:
	$(RM) $@
	$(CC_FOR_BUILD) -c $(CCFLAGS_FOR_BUILD) $<

all: man2html$(EXEEXT)

man2html$(EXEEXT): $(OBJ1)
	$(CC_FOR_BUILD) $(LDFLAGS_FOR_BUILD) $(OBJ1) -o $@ ${LIBS_FOR_BUILD}

clean:
	$(RM) man2html$(EXEEXT) $(OBJ1)

distclean maintainer-clean mostlyclean: clean
	$(RM) bash.pc bashbug.sh

man2html.o: man2html.c
