#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
include ../../playbit.defs.mk

VERSION := 2.6.8
CFLAGS += -W -Wall -Wno-unused-parameter -I..
NO_STRIP := 1

PRODUCTS := \
	bin/mdb_stat  usr/share/man/man1/mdb_stat.1.gz \
	bin/mdb_copy  usr/share/man/man1/mdb_copy.1.gz \
	bin/mdb_dump  usr/share/man/man1/mdb_dump.1.gz \
	bin/mdb_load  usr/share/man/man1/mdb_load.1.gz \
	bin/mdb_drop  usr/share/man/man1/mdb_drop.1.gz \

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/liblmdb.a: ../mdb.c ../midl.c ../lmdb.h
	$(MAKE) -C .. $@

$(DESTDIR)/bin/mdb_%: CFLAGS += -I.. -Wno-implicit-fallthrough
$(DESTDIR)/bin/mdb_stat: mdb_stat.c $(DESTDIR)/lib/liblmdb.a
$(DESTDIR)/bin/mdb_copy: mdb_copy.c $(DESTDIR)/lib/liblmdb.a
$(DESTDIR)/bin/mdb_dump: mdb_dump.c $(DESTDIR)/lib/liblmdb.a
$(DESTDIR)/bin/mdb_load: mdb_load.c $(DESTDIR)/lib/liblmdb.a
$(DESTDIR)/bin/mdb_drop: mdb_drop.c $(DESTDIR)/lib/liblmdb.a

include ../../playbit.rules.mk
.PHONY: all clean install
