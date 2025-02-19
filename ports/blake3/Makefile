#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

VERSION := 1.5.1
PRODUCTS := \
	lib/libblake3.a \
	usr/include/blake3.h

LIB_SRCS := \
	blake3.c \
	blake3_dispatch.c \
	blake3_portable.c

ifeq ($(ARCH),x86_64)
	CFLAGS += -msse2 -msse4.1 -mavx2 -mavx512f -mavx512vl
	LIB_SRCS += \
		blake3_avx2_x86-64_unix.S \
		blake3_avx512_x86-64_unix.S \
		blake3_sse2_x86-64_unix.S \
		blake3_sse41_x86-64_unix.S
else ifeq ($(ARCH),aarch64)
	CFLAGS += -ftree-vectorize -Wno-unused
	LIB_SRCS += blake3_neon.c
else
	CFLAGS += -DBLAKE3_NO_AVX2 -DBLAKE3_NO_AVX512 -DBLAKE3_NO_SSE2 -DBLAKE3_NO_SSE41
endif

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
LIB_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIB_SRCS)))
ALL_OBJS += $(LIB_OBJS)

all: $(PRODUCTS)
install: $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libblake3.a: $(LIB_OBJS)

# ---- test ----

TEST_SRCS := test.c $(LIB_SRCS)
TEST_CFLAGS := -fsanitize=address,undefined -g -DBLAKE3_TESTING
TEST_LDFLAGS := -fsanitize=address,undefined
TEST_OBJS := $(addprefix $(BUILDDIR)/test.,$(patsubst %,%.o,$(TEST_SRCS)))
ALL_OBJS += $(TEST_OBJS)

test: $(TEST_OBJS)
	$(CC) $(LDFLAGS) $(TEST_LDFLAGS) -o $(BUILDDIR)/test $^
	python test.py $(BUILDDIR)/test && echo OK
	@# Note: on aarch64 it is expected to see many lines of "Testing 0x00000000"

$(BUILDDIR)/test.%.o: %
	$(QLOG) CC $<
	$(Q)$(CC) -MP $(COMPILE_DEPFLAGS) $(CFLAGS) $(TEST_CFLAGS) -c -o "$@" $<

include ../../tools/playbit.rules.mk
.PHONY: all clean install test
