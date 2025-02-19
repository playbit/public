#!BUILDTOOL toolchain
#!DEP ports/libc
#!DEP ports/libunwind

# SRCS and FLAGS from observing output of:
#   tar -xf zstd-1.5.6.tar.gz && cd zstd-1.5.6
#   CC=/build/toolchain/bin/clang make -C zstd-1.5.6 V=1 ZSTD_LEGACY_SUPPORT=0 lib-mt
#   CC=/build/toolchain/bin/clang make -C zstd-1.5.6/programs V=1 ZSTD_LEGACY_SUPPORT=0
# Other files from observing output of:
#   CC=/build/toolchain/bin/clang make -C lib V=1 ZSTD_LEGACY_SUPPORT=0 \
#     DESTDIR=install install-static install-includes install-pc
#   cat lib/install/usr/local/lib/pkgconfig/libzstd.pc
include ../../tools/playbit.defs.mk

LIBZSTD_VERSION := 1.5.6
CFLAGS_ALL := $(CFLAGS) \
	-O3 \
	-Wall \
	-Wextra \
	-Wcast-qual \
	-Wcast-align \
	-Wshadow \
	-Wstrict-aliasing=1 \
	-Wswitch-enum \
	-Wdeclaration-after-statement \
	-Wstrict-prototypes \
	-Wundef \
	-Wpointer-arith \
	-Wvla \
	-Wformat=2 \
	-Winit-self \
	-Wfloat-equal \
	-Wwrite-strings \
	-Wredundant-decls \
	-Wmissing-prototypes \
	-Wc++-compat \
	-Qunused-arguments \
	-Wa,--noexecstack \
	-DXXH_NAMESPACE=ZSTD_ \
	-DDEBUGLEVEL=0 \
	-DZSTD_LEGACY_SUPPORT=0

CMD_CFLAGS := -DBACKTRACE_ENABLE=0 -DZSTD_LEGACY_SUPPORT=0
CMD_LDFLAGS := $(CFLAGS) -O3 -z noexecstack

# Note: Unconditionally include .S files; guarded by '#if's
LIB_SRCS := \
	lib/common/debug.c \
	lib/common/entropy_common.c \
	lib/common/error_private.c \
	lib/common/fse_decompress.c \
	lib/common/pool.c \
	lib/common/xxhash.c \
	lib/common/zstd_common.c \
	lib/compress/fse_compress.c \
	lib/compress/hist.c \
	lib/compress/huf_compress.c \
	lib/compress/zstd_compress.c \
	lib/compress/zstd_compress_literals.c \
	lib/compress/zstd_compress_sequences.c \
	lib/compress/zstd_compress_superblock.c \
	lib/compress/zstd_double_fast.c \
	lib/compress/zstd_fast.c \
	lib/compress/zstd_lazy.c \
	lib/compress/zstd_ldm.c \
	lib/compress/zstd_opt.c \
	lib/compress/zstdmt_compress.c \
	lib/decompress/huf_decompress.c \
	lib/decompress/huf_decompress_amd64.S \
	lib/decompress/zstd_ddict.c \
	lib/decompress/zstd_decompress.c \
	lib/decompress/zstd_decompress_block.c \
	lib/dictBuilder/cover.c \
	lib/dictBuilder/divsufsort.c \
	lib/dictBuilder/fastcover.c \
	lib/dictBuilder/zdict.c

CMD_SRCS := \
	cmd/benchfn.c \
	cmd/benchzstd.c \
	cmd/datagen.c \
	cmd/dibio.c \
	cmd/fileio.c \
	cmd/fileio_asyncio.c \
	cmd/lorem.c \
	cmd/timefn.c \
	cmd/util.c \
	cmd/zstdcli.c \
	cmd/zstdcli_trace.c

ifneq ($(ARCH),wasm32)
	CFLAGS_ALL += -DZSTD_MULTITHREAD
	CMD_LDFLAGS += -pthread
	LIB_SRCS += lib/common/threading.c
endif

CMD_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(CMD_SRCS)))
LIB_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIB_SRCS)))
PRODUCTS := \
	lib/libzstd.a \
	lib/pkgconfig/libzstd.pc \
	usr/include/zdict.h \
	usr/include/zstd_errors.h \
	usr/include/zstd.h
ifneq ($(ARCH),wasm32)
	PRODUCTS += bin/zstd
endif
PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
	$(Q)[ ! -d $(DESTDIR)/lib/pkgconfig ] || \
		find $(DESTDIR)/lib/pkgconfig -type d -empty -delete
clean: uninstall
	$(Q)rm -rf $(BUILDDIR)


OBJ_DIRS := $(sort $(patsubst %/,%,$(dir $(LIB_OBJS) $(CMD_OBJS))))
$(LIB_OBJS) $(CMD_OBJS): | $(OBJ_DIRS)
$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

$(DESTDIR)/lib/%.a: $(LIB_OBJS)
	$(QLOG) AR $@
	$(Q)mkdir -p "$(@D)"
	$(Q)rm -f "$@"
	$(Q)ar rcs "$@" $^

$(DESTDIR)/lib/pkgconfig/%.pc: lib/%.pc
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/usr/include/%.h: lib/%.h
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/bin/zstd: $(LIB_OBJS) $(CMD_OBJS)
	$(QLOG) LINK $@
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(CMD_LDFLAGS) -o "$@" $^
	$(Q)strip $@

$(BUILDDIR)/cmd/%.c.o: CFLAGS_ALL += $(CMD_CFLAGS)
$(BUILDDIR)/%.c.o: %.c
	$(QLOG) CC $<
	$(Q)$(CC) $(CFLAGS_ALL) -MMD -MP -c -o "$@" $<

$(BUILDDIR)/%.S.o: %.S
	$(QLOG) CC $<
	$(Q)$(CC) $(CFLAGS_ALL) -MMD -MP -c -o "$@" $<

-include $(wildcard $(LIB_OBJS:.o=.d))
-include $(wildcard $(CMD_OBJS:.o=.d))
.PHONY: all clean install uninstall
