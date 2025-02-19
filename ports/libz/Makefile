#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

VERSION := 1.3.1

PRODUCTS := \
	lib/libz.a \
	lib/pkgconfig/zlib.pc \
	usr/include/zlib.h \
	usr/include/zconf.h

SRCS := \
	adler32.c \
	compress.c \
	crc32.c \
	deflate.c \
	gzclose.c \
	gzlib.c \
	gzread.c \
	gzwrite.c \
	infback.c \
	inffast.c \
	inflate.c \
	inftrees.c \
	trees.c \
	uncompr.c \
	zutil.c

CFLAGS += -Iinclude -O3 -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libz.a: $(OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
