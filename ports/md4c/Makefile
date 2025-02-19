# Markdown parser library with a SAX-like callback-based interface
# https://github.com/mity/md4c
# license: MIT
#
#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

VERSION := 0.5.2

PRODUCTS := \
	$(DESTDIR)/lib/libmd4c.a \
	$(DESTDIR)/usr/include/md4c.h \
	$(DESTDIR)/lib/pkgconfig/md4c.pc
SRCS := md4c.c
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
clean:
	rm -f $(PRODUCTS) $(OBJS)

$(DESTDIR)/lib/libmd4c.a: $(OBJS)

$(DESTDIR)/lib/pkgconfig/md4c.pc: md4c.pc.in
	$(QLOG) INSTALL $@
	$(Q)mkdir -p $(@D)
	$(Q)sed -i -e 's/@VERSION@/$(VERSION)/g' $< > $@

include ../../tools/playbit.rules.mk
.PHONY: all clean
