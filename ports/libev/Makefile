#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

LIBEV_VERSION := 4.33
CFLAGS += -DHAVE_CONFIG_H -Iinclude -I. -DEV_USE_LINUXAIO=0 \
	-Wno-extern-initializer -Wno-unused-value
SRCS := ev.c event.c

PRODUCTS := \
	lib/libev.a \
	lib/pkgconfig/libev.pc \
	usr/include/ev.h \
	usr/include/ev++.h \
	usr/include/event.h \
	usr/share/man/man3/ev.3.gz

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libev.a: $(OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
