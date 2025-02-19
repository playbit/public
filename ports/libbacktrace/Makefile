#!BUILDTOOL toolchain
#!DEP ports/libc
#!DEP ports/libunwind [transitive]
include ../../tools/playbit.defs.mk

VERSION := 2024.3.8

PRODUCTS := \
	lib/libbacktrace.a \
	lib/pkgconfig/libbacktrace.pc \
	usr/include/backtrace.h

SRCS := \
	atomic.c \
	backtrace.c \
	dwarf.c \
	elf.c \
	fileline.c \
	mmap.c \
	mmapio.c \
	posix.c \
	print.c \
	sort.c \
	state.c

CFLAGS += -funwind-tables

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)
clean-build:
	$(Q)rm -rf $(BUILDDIR)

$(DESTDIR)/lib/libbacktrace.a: $(OBJS)

$(DESTDIR)/usr/include/backtrace.h: backtrace.h
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
