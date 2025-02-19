#!BUILDTOOL toolchain
#!BUILDTOOL ports/pkgconf
#!DEP ports/libc
#!DEP ports/readline
include ../../tools/playbit.defs.mk

VERSION := 3.45.1

PRODUCTS := \
	$(DESTDIR)/lib/libsqlite3.a \
	$(DESTDIR)/lib/pkgconfig/sqlite3.pc \
	$(DESTDIR)/usr/include/sqlite3.h \
	$(DESTDIR)/bin/sqlite3

LIB_SRCS := sqlite3.c
CMD_SRCS := shell.c
CMD_LIBS := $(shell pkg-config --libs readline)

LIB_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIB_SRCS)))
CMD_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(CMD_SRCS)))
ALL_OBJS := $(CMD_OBJS) $(LIB_OBJS)

CFLAGS += \
	-DSQLITE_ENABLE_COLUMN_METADATA \
	-DSQLITE_SECURE_DELETE \
	-DSQLITE_ENABLE_UNLOCK_NOTIFY \
	-DSQLITE_USE_URI \
	-DSQLITE_ENABLE_DBSTAT_VTAB

# Enable SQL math functions (using libm, which is built into musl and wasi)
CFLAGS += -DSQLITE_ENABLE_MATH_FUNCTIONS

# Include support for full-text search (https://www.sqlite.org/fts5.html)
# CFLAGS += -DSQLITE_ENABLE_FTS3_PARENTHESIS
# CFLAGS += -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5

# Include support for R-tree (https://www.sqlite.org/rtree.html)
# CFLAGS += -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_GEOPOLY

ifeq ($(ARCH),wasm32)
	# Disable loadable extensions (no dl in wasi)
	CFLAGS += -DSQLITE_OMIT_LOAD_EXTENSION=1
else
	CFLAGS += -D_REENTRANT=1 -DSQLITE_THREADSAFE=1
endif

all: $(PRODUCTS)
clean:
	rm -f $(PRODUCTS) $(ALL_OBJS)

$(CMD_OBJS): CFLAGS += -DHAVE_READLINE=1
$(DESTDIR)/bin/sqlite3: LDFLAGS += $(CMD_LIBS)
$(DESTDIR)/bin/sqlite3: $(CMD_OBJS) $(LIB_OBJS)
$(DESTDIR)/lib/libsqlite3.a: $(LIB_OBJS)

$(DESTDIR)/lib/pkgconfig/sqlite3.pc: sqlite3.pc.in
	$(QLOG) INSTALL $@
	$(Q)mkdir -p $(@D)
	$(Q)sed -i \
		-e 's/@VERSION@/$(VERSION)/g' \
		-e 's/@LIBS@/$(CMD_LIBS)/g' \
		$< > $@

include ../../tools/playbit.rules.mk
.PHONY: all clean
