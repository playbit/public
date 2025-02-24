# a simple command-line text editor, clone of pico
#
#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
#!DEP ports/libncurses
include ../../tools/playbit.defs.mk

VERSION := 8.3
PRODUCTS := \
	$(DESTDIR)/bin/nano \
	$(DESTDIR)/etc/nanorc \
	$(DESTDIR)/usr/share/man/man1/nano.1.gz \
	$(addprefix $(DESTDIR)/usr/share/nano/,$(patsubst syntax/%,%,$(wildcard syntax/*.nanorc)))

CFLAGS += \
	-DHAVE_CONFIG_H \
	-DLOCALEDIR=\"/usr/share/locale\" \
	-DSYSCONFDIR=\"/etc\" \
	-I. -Ilib

LDFLAGS += -lncurses -s

SRCS := \
	lib/openat-proc.c \
	lib/basename-lgpl.c \
	lib/btoc32.c \
	lib/btowc.c \
	lib/c32_apply_type_test.c \
	lib/c32_get_type_test.c \
	lib/c32isalnum.c \
	lib/c32isalpha.c \
	lib/c32isblank.c \
	lib/c32iscntrl.c \
	lib/c32isdigit.c \
	lib/c32isgraph.c \
	lib/c32islower.c \
	lib/c32isprint.c \
	lib/c32ispunct.c \
	lib/c32isspace.c \
	lib/c32isupper.c \
	lib/c32isxdigit.c \
	lib/c32tolower.c \
	lib/canonicalize-lgpl.c \
	lib/chdir-long.c \
	lib/cloexec.c \
	lib/dirname-lgpl.c \
	lib/stripslash.c \
	lib/error.c \
	lib/exitfail.c \
	lib/fcntl.c \
	lib/fd-hook.c \
	lib/filenamecat-lgpl.c \
	lib/float.c \
	lib/free.c \
	lib/futimens.c \
	lib/getopt.c \
	lib/getopt1.c \
	lib/getprogname.c \
	lib/gettime.c \
	lib/malloc/dynarray_at_failure.c \
	lib/malloc/dynarray_emplace_enlarge.c \
	lib/malloc/dynarray_finalize.c \
	lib/malloc/dynarray_resize.c \
	lib/malloc/dynarray_resize_clear.c \
	lib/malloc/scratch_buffer_grow.c \
	lib/malloc/scratch_buffer_grow_preserve.c \
	lib/malloc/scratch_buffer_set_array_size.c \
	lib/glob.c \
	lib/globfree.c \
	lib/glob_pattern_p.c \
	lib/hard-locale.c \
	lib/localcharset.c \
	lib/glthread/lock.c \
	lib/malloca.c \
	lib/math.c \
	lib/mbrtoc32.c \
	lib/mbrtowc.c \
	lib/mbsrtoc32s.c \
	lib/mbsrtowcs.c \
	lib/mbszero.c \
	lib/memchr.c \
	lib/nl_langinfo.c \
	lib/glthread/once.c \
	lib/openat-die.c \
	lib/printf-frexp.c \
	lib/printf-frexpl.c \
	lib/rawmemchr.c \
	lib/regex.c \
	lib/save-cwd.c \
	lib/setlocale_null.c \
	lib/setlocale-lock.c \
	lib/setlocale_null-unlocked.c \
	lib/sig-handler.c \
	lib/stat-time.c \
	lib/stdlib.c \
	lib/strnlen1.c \
	lib/tempname.c \
	lib/glthread/threadlib.c \
	lib/timespec.c \
	lib/unicase/tolower.c \
	lib/unictype/ctype_alnum.c \
	lib/unictype/ctype_alpha.c \
	lib/unictype/ctype_blank.c \
	lib/unictype/ctype_cntrl.c \
	lib/unictype/ctype_digit.c \
	lib/unictype/ctype_graph.c \
	lib/unictype/ctype_lower.c \
	lib/unictype/ctype_print.c \
	lib/unictype/ctype_punct.c \
	lib/unictype/ctype_space.c \
	lib/unictype/ctype_upper.c \
	lib/unictype/ctype_xdigit.c \
	lib/unistd.c \
	lib/unistr/u32-chr.c \
	lib/unistr/u32-cpy.c \
	lib/unistr/u32-pcpy.c \
	lib/unistr/u32-strcat.c \
	lib/unistr/u32-strlen.c \
	lib/uniwidth/width.c \
	lib/utimens.c \
	lib/vsnzprintf.c \
	lib/wctype-h.c \
	lib/wmempcpy.c \
	lib/xsize.c \
	lib/asnprintf.c \
	lib/mbsrtoc32s-state.c \
	lib/mbsrtowcs-state.c \
	lib/printf-args.c \
	lib/printf-parse.c \
	lib/snprintf.c \
	lib/strcasestr.c \
	lib/vasnprintf.c \
	lib/vsnprintf.c \
	src/browser.c \
	src/chars.c \
	src/color.c \
	src/cut.c \
	src/files.c \
	src/global.c \
	src/help.c \
	src/history.c \
	src/move.c \
	src/nano.c \
	src/prompt.c \
	src/rcfile.c \
	src/search.c \
	src/text.c \
	src/utils.c \
	src/winio.c \

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
clean:
	rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/bin/nano: $(OBJS)

$(OBJS): config.h libc-config.h
config.h: config-$(ARCH).h
	cp $< $@
libc-config.h: libc-config-$(ARCH).h
	cp $< $@

$(DESTDIR)/usr/share/nano/%: syntax/%
	$(QLOG) "INSTALL $@"
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/etc/%: %
	$(QLOG) "INSTALL $@"
	$(Q)install -D -m0644 $< $@

.PHONY: all clean
include ../../tools/playbit.rules.mk
