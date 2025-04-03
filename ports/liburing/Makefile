#!BUILDTOOL toolchain
#!DEP ports/libc
#!DEP src/kernel-headers if HERMETIC
include ../../tools/playbit.defs.mk

LIBURING_VERSION := 2.9

PRODUCTS := \
	lib/liburing.a \
	lib/pkgconfig/liburing.pc \
	usr/share/man/man7/io_uring.7.gz \
	usr/include/liburing.h \
	usr/include/liburing/barrier.h \
	usr/include/liburing/io_uring_version.h \
	usr/include/liburing/io_uring.h \
	usr/include/liburing/compat.h

SRCS := \
	queue.c \
	register.c \
	setup.c \
	syscall.c \
	version.c \

ifeq ($(ASAN),1)
	SRCS   += sanitize.c
	CFLAGS += -DCONFIG_USE_SANITIZER
	CFLAGS += -I$(shell dirname "$$(dirname "$$(cc -print-libgcc-file-name)")")/include
endif

CFLAGS += \
	-O3 \
	-Iinclude \
	-Wall -Wextra -Wno-unused-parameter \
	-ffile-prefix-map="=/$(SUBDIR)/" \
	-fno-stack-protector \
	-D_GNU_SOURCE \
	-D_LARGEFILE_SOURCE \
	-D_FILE_OFFSET_BITS=64 \
	-DLIBURING_INTERNAL \
	\
	-DCONFIG_HAVE_KERNEL_RWF_T \
	-DCONFIG_HAVE_KERNEL_TIMESPEC \
	-DCONFIG_HAVE_OPEN_HOW \
	-DCONFIG_HAVE_STATX \
	-DCONFIG_HAVE_GLIBC_STATX \
	-DCONFIG_HAVE_CXX \
	-DCONFIG_HAVE_NVME_URING \
	-DCONFIG_HAVE_FANOTIFY \
	-DCONFIG_HAVE_FUTEXV \
	-DCONFIG_HAVE_UBLK_HEADER \

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)
clean-build:
	$(Q)rm -rf $(BUILDDIR)

$(DESTDIR)/lib/liburing.a: $(OBJS)

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
