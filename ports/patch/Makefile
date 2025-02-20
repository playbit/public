#!BOOTSTRAP
#!BUILDTOOL src/cc if HERMETIC
#!BUILDTOOL ports/libc if HERMETIC
#!BUILDTOOL ports/busybox if HERMETIC
#!DEP src/kernel-headers if HERMETIC
#
#!BUILDTOOL ports/make
#!DEP ports/libc [transitive]
include ../../tools/playbit.defs.mk

VERSION := 2.7.6
PRODUCTS := \
	$(DESTDIR)/bin/patch \
	$(DESTDIR)/usr/share/man/man1/patch.1.gz

CFLAGS += \
	-flto=thin \
	-I. -Ilib \
	-DNDEBUG \
	-DENABLE_MERGE \
	-DHAVE_CONFIG_H \
	-include config.h \
	-Wno-implicit-const-int-float-conversion \
	-Wno-string-plus-int \
	-Wno-constant-logical-operand

SRCS := \
	inp.c \
	merge.c \
	patch.c \
	pch.c \
	safe.c \
	util.c \
	version.c \
	lib/argmatch.c \
	lib/asnprintf.c \
	lib/backup-find.c \
	lib/backupfile.c \
	lib/basename-lgpl.c \
	lib/basename.c \
	lib/bitrotate.c \
	lib/c-ctype.c \
	lib/c-strcasecmp.c \
	lib/c-strncasecmp.c \
	lib/canonicalize-lgpl.c \
	lib/chdir-long.c \
	lib/chmodat.c \
	lib/chownat.c \
	lib/cloexec.c \
	lib/dirname-lgpl.c \
	lib/dirname.c \
	lib/dup-safer-flag.c \
	lib/dup-safer.c \
	lib/error.c \
	lib/exitfail.c \
	lib/fchownat.c \
	lib/fcntl.c \
	lib/fd-hook.c \
	lib/fd-safer-flag.c \
	lib/fd-safer.c \
	lib/filenamecat-lgpl.c \
	lib/full-write.c \
	lib/getopt.c \
	lib/getopt1.c \
	lib/getprogname.c \
	lib/gettime.c \
	lib/gl_linked_list.c \
	lib/gl_list.c \
	lib/gl_xlist.c \
	lib/group-member.c \
	lib/hard-locale.c \
	lib/hash.c \
	lib/localcharset.c \
	lib/localtime-buffer.c \
	lib/malloca.c \
	lib/mktime.c \
	lib/nstrftime.c \
	lib/openat-die.c \
	lib/openat-proc.c \
	lib/opendir-safer.c \
	lib/parse-datetime.c \
	lib/pipe-safer.c \
	lib/printf-args.c \
	lib/printf-parse.c \
	lib/progname.c \
	lib/quotearg.c \
	lib/renameat2.c \
	lib/safe-write.c \
	lib/save-cwd.c \
	lib/stat-time.c \
	lib/statat.c \
	lib/stripslash.c \
	lib/tempname.c \
	lib/time_rz.c \
	lib/timespec.c \
	lib/unistd.c \
	lib/utimens.c \
	lib/vasnprintf.c \
	lib/verror.c \
	lib/wctype-h.c \
	lib/xasprintf.c \
	lib/xmalloc.c \
	lib/xmemdup0.c \
	lib/xsize.c \
	lib/xstrndup.c \
	lib/xvasprintf.c \

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
clean:
	rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/bin/patch: $(OBJS)

.PHONY: all clean
include ../../tools/playbit.rules.mk
