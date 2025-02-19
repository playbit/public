#!BOOTSTRAP
#!DEP ports/libc [transitive]
#!DEP ports/libunwind
include ../../tools/playbit.defs.mk

MAKE_VERSION := 4.4.1

CFLAGS_ALL := \
	$(CFLAGS) -flto=thin \
	-I. -Ilib -I$(ARCH) \
	-Wno-string-compare \
	-DNDEBUG \
	-DHAVE_CONFIG_H \
	-DLIBDIR=\"/lib\" \
	-DLOCALEDIR=\"/share/locale\" \
	-DINCLUDEDIR=\"/usr/include\"

LDFLAGS_ALL := --target=$(ARCH)-playbit -O2
# LDFLAGS_ALL += -static

SRCS := \
	ar.c \
	arscan.c \
	commands.c \
	default.c \
	dir.c \
	expand.c \
	file.c \
	function.c \
	getopt.c \
	getopt1.c \
	hash.c \
	implicit.c \
	job.c \
	load.c \
	loadapi.c \
	main.c \
	misc.c \
	output.c \
	posixos.c \
	read.c \
	remake.c \
	remote-stub.c \
	rule.c \
	shuffle.c \
	signame.c \
	strcache.c \
	variable.c \
	version.c \
	vpath.c \
	lib/concat-filename.c \
	lib/findprog-in.c \
	lib/fnmatch.c \
	lib/glob.c

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))
PRODUCTS := $(DESTDIR)/bin/make $(DESTDIR)/usr/share/man/man1/make.1.gz

all: $(PRODUCTS)

clean:
	rm -rf $(BUILDDIR) $(PRODUCTS)

upgrade:
	bash upgrade-make.sh

$(DESTDIR)/bin/make: $(OBJS)
	@echo "LINK $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(LDFLAGS_ALL) -o "$@" $^
	$(Q)strip "$@"

$(BUILDDIR)/%.c.o: %.c
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o "$@" $<

$(DESTDIR)/usr/share/man/man1/%.1.gz: %.1
	@echo "COPY $< -> $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)gzip -kc -9 "$<" > "$@"
	$(Q)chmod 0644 "$@"

OBJ_DIRS := $(sort $(patsubst %/,%,$(dir $(OBJS))))
$(OBJS): | $(OBJ_DIRS)
$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

.PHONY: all clean upgrade
