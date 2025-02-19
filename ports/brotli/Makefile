#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

BROTLI_VERSION := 1.1.0
CFLAGS += -DBROTLI_HAVE_LOG2=1 -DOS_LINUX -Iinclude
# Note: we define OS_LINUX even for wasm32 since wasm32-playbit has endian.h

LIBCOMMON_SRCS := \
	common/constants.c \
	common/context.c \
	common/dictionary.c \
	common/platform.c \
	common/shared_dictionary.c \
	common/transform.c

LIBDEC_SRCS := \
	dec/bit_reader.c \
	dec/decode.c \
	dec/huffman.c \
	dec/state.c

LIBENC_SRCS := \
	enc/backward_references.c \
	enc/backward_references_hq.c \
	enc/bit_cost.c \
	enc/block_splitter.c \
	enc/brotli_bit_stream.c \
	enc/cluster.c \
	enc/command.c \
	enc/compound_dictionary.c \
	enc/compress_fragment.c \
	enc/compress_fragment_two_pass.c \
	enc/dictionary_hash.c \
	enc/encode.c \
	enc/encoder_dict.c \
	enc/entropy_encode.c \
	enc/fast_log.c \
	enc/histogram.c \
	enc/literal_cost.c \
	enc/memory.c \
	enc/metablock.c \
	enc/static_dict.c \
	enc/utf8_util.c

CMD_SRCS := tools/brotli.c

PRODUCTS := \
	lib/libbrotlicommon.a \
	lib/libbrotlidec.a \
	lib/libbrotlienc.a \
	lib/pkgconfig/libbrotlicommon.pc \
	lib/pkgconfig/libbrotlidec.pc \
	lib/pkgconfig/libbrotlienc.pc \
	usr/include/brotli/decode.h \
	usr/include/brotli/encode.h \
	usr/include/brotli/port.h \
	usr/include/brotli/shared_dictionary.h \
	usr/include/brotli/types.h

ifneq ($(ARCH),wasm32)
	PRODUCTS += bin/brotli
endif

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
LIBCOMMON_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIBCOMMON_SRCS)))
LIBDEC_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIBDEC_SRCS)))
LIBENC_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIBENC_SRCS)))
CMD_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(CMD_SRCS)))
ALL_OBJS := $(LIBCOMMON_OBJS) $(LIBDEC_OBJS) $(LIBENC_OBJS) $(CMD_OBJS)

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/bin/brotli: $(CMD_OBJS) $(DESTDIR)/lib/libbrotlicommon.a $(DESTDIR)/lib/libbrotlidec.a $(DESTDIR)/lib/libbrotlienc.a
$(DESTDIR)/lib/libbrotlicommon.a: $(LIBCOMMON_OBJS)
$(DESTDIR)/lib/libbrotlidec.a: $(LIBDEC_OBJS)
$(DESTDIR)/lib/libbrotlienc.a: $(LIBENC_OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
