#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

VERSION := 2.6.8
CFLAGS += -W -Wall -Wno-unused -Wno-unused-parameter
SRCS := mdb.c midl.c

PRODUCTS := \
	lib/liblmdb.a \
	usr/include/lmdb.h \

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/liblmdb.a: $(OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install
