#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
#!DEP ports/openssl [transitive]
#!DEP ports/libev [transitive]
#!DEP ports/libz [transitive]
#!DEP ports/libcares [transitive]
#
# Upgrade note: lib/CMakeLists.txt is a good source of information
include ../../tools/playbit.defs.mk

NGHTTP2_VERSION := 1.61.0
CFLAGS += \
	-I. -Iinclude -fvisibility=hidden \
	-DHAVE_CONFIG_H -DBUILDING_NGHTTP2 -DNGHTTP2_STATICLIB

SRCS := \
	nghttp2_pq.c nghttp2_map.c nghttp2_queue.c \
	nghttp2_frame.c \
	nghttp2_buf.c \
	nghttp2_stream.c nghttp2_outbound_item.c \
	nghttp2_session.c nghttp2_submit.c \
	nghttp2_helper.c \
	nghttp2_alpn.c \
	nghttp2_hd.c nghttp2_hd_huffman.c nghttp2_hd_huffman_data.c \
	nghttp2_version.c \
	nghttp2_priority_spec.c \
	nghttp2_option.c \
	nghttp2_callbacks.c \
	nghttp2_mem.c \
	nghttp2_http.c \
	nghttp2_rcbuf.c \
	nghttp2_extpri.c \
	nghttp2_ratelim.c \
	nghttp2_time.c \
	nghttp2_debug.c \
	sfparse.c

PRODUCTS := \
	lib/libnghttp2.a \
	lib/pkgconfig/libnghttp2.pc \
	usr/include/nghttp2/nghttp2.h \
	usr/include/nghttp2/nghttp2ver.h

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libnghttp2.a: $(OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
