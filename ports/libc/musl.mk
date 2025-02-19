# this file is included by "Makefile"
OBJ := $(OUT)/obj

CFLAGS_ALL := \
	--target=$(ARCH)-playbit \
	-std=c99 \
	-nostdinc \
	-ffreestanding \
	-fexcess-precision=standard \
	-frounding-math \
	-fno-strict-aliasing \
	-Wa,--noexecstack \
	\
	-D_XOPEN_SOURCE=700 \
	-Iarch/$(ARCH) \
	-Iarch/generic \
	-Isrc/include \
	-Isrc/internal \
	-Iinclude \
	\
	-g -gz=zlib \
	-O2 \
	-fno-align-functions \
	-pipe \
	-fomit-frame-pointer \
	-fno-unwind-tables \
	-fno-asynchronous-unwind-tables \
	-ffunction-sections \
	-fdata-sections \
	-w \
	-Wno-pointer-to-int-cast \
	-Werror=implicit-function-declaration \
	-Werror=implicit-int \
	-Werror=pointer-sign \
	-Werror=pointer-arith \
	-Werror=int-conversion \
	-Werror=incompatible-pointer-types \
	-Wno-unused-arguments \
	-Waddress \
	-Warray-bounds \
	-Wchar-subscripts \
	-Wduplicate-decl-specifier \
	-Winit-self \
	-Wreturn-type \
	-Wsequence-point \
	-Wstrict-aliasing \
	-Wunused-function \
	-Wunused-label \
	-Wunused-variable

LDFLAGS_ALL := \
	-Wl,--sort-section,alignment \
	-Wl,--sort-common \
	-Wl,--gc-sections \
	-Wl,--hash-style=both \
	-Wl,--no-undefined \
	-Wl,--exclude-libs=ALL \
	-Wl,--dynamic-list=./dynamic.list \
	-Wl,--compress-debug-sections=zlib \
	-Wl,-soname,libc.so

CFLAGS_MEMOPS =
CFLAGS_NOSSP := -fno-stack-protector

SRC_DIRS   := $(addprefix ,src/* src/malloc/mallocng crt ldso)
BASE_GLOBS := $(addsuffix /*.c,$(SRC_DIRS))
ARCH_GLOBS := $(addsuffix /$(ARCH)/*.[csS],$(SRC_DIRS))
BASE_SRCS  := $(sort $(wildcard $(BASE_GLOBS)))
ARCH_SRCS  := $(sort $(wildcard $(ARCH_GLOBS)))
BASE_OBJS  := $(patsubst %,%.o,$(basename $(BASE_SRCS)))
ARCH_OBJS  := $(patsubst %,%.o,$(basename $(ARCH_SRCS)))
REPLACED_OBJS := $(sort $(subst /$(ARCH)/,/,$(ARCH_OBJS)))
ALL_OBJS := $(addprefix $(OBJ)/, $(filter-out $(REPLACED_OBJS), $(sort $(BASE_OBJS) $(ARCH_OBJS))))
LIBC_OBJS := $(filter $(OBJ)/src/%,$(ALL_OBJS)) $(filter $(OBJ)/compat/%,$(ALL_OBJS))
LDSO_OBJS := $(filter $(OBJ)/ldso/%,$(ALL_OBJS:%.o=%.lo))
CRT_OBJS := $(filter $(OBJ)/crt/%,$(ALL_OBJS))
AOBJS := $(LIBC_OBJS)
LOBJS := $(LIBC_OBJS:.o=.lo)
IMPH := $(addprefix , src/internal/stdio_impl.h src/internal/pthread_impl.h src/internal/locale_impl.h src/internal/libc.h)

ARCH_INCLUDES    := $(wildcard arch/$(ARCH)/bits/*.h)
GENERIC_INCLUDES := $(wildcard arch/generic/bits/*.h)
INCLUDES         := $(wildcard include/*.h include/*/*.h)
ALL_INCLUDES     := $(sort $(INCLUDES:%=%) $(ARCH_INCLUDES:arch/$(ARCH)/%=include/%) $(GENERIC_INCLUDES:arch/generic/%=include/%))

EMPTY_LIB_NAMES := m rt pthread crypt util xnet resolv dl
EMPTY_LIBS      := $(EMPTY_LIB_NAMES:%=$(OUT)/lib%.a)
CRT_LIBS        := $(addprefix $(OUT)/,$(notdir $(CRT_OBJS)))
STATIC_LIBS     := $(OUT)/libc.a
SHARED_LIBS     := $(OUT)/libc.so
ALL_LIBS        := $(CRT_LIBS) $(STATIC_LIBS) $(SHARED_LIBS) $(EMPTY_LIBS)

all: install
build: $(ALL_LIBS)

print-objs:
	@echo $(AOBJS)

OBJ_DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_LIBS) $(ALL_OBJS))))
$(ALL_LIBS) $(ALL_OBJS) $(ALL_OBJS:%.o=%.lo): | $(OBJ_DIRS)
$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

$(OBJ)/include/bits/alltypes.h: \
		arch/$(ARCH)/bits/alltypes.h.in \
		include/alltypes.h.in \
		tools/mkalltypes.sed
	@echo "GEN $@"
	$(Q)sed -f tools/mkalltypes.sed \
		arch/$(ARCH)/bits/alltypes.h.in include/alltypes.h.in > $@

$(OBJ)/include/bits/syscall.h: arch/$(ARCH)/bits/syscall.h.in
	@echo "GEN $@"
	$(Q)cp $< $@
	$(Q)sed -n -e s/__NR_/SYS_/p < $< >> $@

$(OBJ)/crt/rcrt1.o $(OBJ)/ldso/dlstart.lo $(OBJ)/ldso/dynlink.lo: \
		src/internal/dynlink.h \
		arch/$(ARCH)/reloc.h

$(OBJ)/crt/crt1.o $(OBJ)/crt/scrt1.o $(OBJ)/crt/rcrt1.o $(OBJ)/ldso/dlstart.lo: \
		arch/$(ARCH)/crt_arch.h

$(OBJ)/crt/rcrt1.o: ldso/dlstart.c
$(OBJ)/crt/Scrt1.o $(OBJ)/crt/rcrt1.o: CFLAGS_ALL += -fPIC

OPTIMIZE_SRCS = $(wildcard $(OPTIMIZE_GLOBS:%=src/%))
$(OPTIMIZE_SRCS:%.c=$(OBJ)/%.o) $(OPTIMIZE_SRCS:%.c=$(OBJ)/%.lo): CFLAGS += -O3

MEMOPS_OBJS = $(filter %/memcpy.o %/memmove.o %/memcmp.o %/memset.o, $(LIBC_OBJS))
$(MEMOPS_OBJS) $(MEMOPS_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_MEMOPS)

NOSSP_OBJS = $(CRT_OBJS) $(LDSO_OBJS) $(filter \
	%/__libc_start_main.o %/__init_tls.o %/__stack_chk_fail.o \
	%/__set_thread_area.o %/memset.o %/memcpy.o \
	, $(LIBC_OBJS))
$(NOSSP_OBJS) $(NOSSP_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_NOSSP)

$(CRT_OBJS): CFLAGS_ALL += -DCRT
$(LOBJS) $(LDSO_OBJS): CFLAGS_ALL += -fPIC

$(OBJ)/%.o: %.s
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<
$(OBJ)/%.o: %.S
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<
$(OBJ)/%.o: %.c $(IMPH)
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<
$(OBJ)/%.lo: %.s
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<
$(OBJ)/%.lo: %.S
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<
$(OBJ)/%.lo: %.c $(IMPH)
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<

$(OUT)/libc.a: $(AOBJS)
$(OUT)/%.a:
	@echo "AR $@"
	$(Q)rm -f $@
	$(Q)ar rcs $@ $^

$(OUT)/libc.so: $(LOBJS) $(LDSO_OBJS)
	@echo "LINK $@"
	$(Q)$(CC) $(CFLAGS_ALL) $(LDFLAGS_ALL) -nostdlib -shared \
		-Wl,-e,_dlstart -o $@ $(LOBJS) $(LDSO_OBJS) -lclang_rt.builtins

$(OUT)/%.o: $(OBJ)/crt/$(ARCH)/%.o
	$(Q)cp $< $@
$(OUT)/%.o: $(OBJ)/crt/%.o
	$(Q)cp $< $@

# -------------------------------------------------------------------------------------
# install

$(DESTDIR)/bin/ldd: $(DESTDIR)/lib/libc.so
	$(QLOG) "SYMLINK $@ -> /lib/$(<F)"
	$(Q)mkdir -p $(@D)
	$(Q)ln -sf "/lib/$(<F)" "$@"

$(DESTDIR)/bin/%: $(OBJ)/%
	install -D $< $@

$(DESTDIR)/lib/%.so: $(OUT)/%.so
	install -D -m 755 $< $@

$(DESTDIR)/lib/%: $(OUT)/%
	install -D -m 644 $< $@

$(DESTDIR)/usr/include/bits/%: arch/$(ARCH)/bits/%
	install -D -m 644 $< $@

$(DESTDIR)/usr/include/bits/%: arch/generic/bits/%
	install -D -m 644 $< $@

$(DESTDIR)/usr/include/%: include/%
	install -D -m 644 $< $@

$(DESTDIR)/lib/ld.so.1: $(OUT)/libc.so
	ln -sf "$(<F)" "$@"

install-libs: $(ALL_LIBS:$(OUT)/%=$(DESTDIR)/lib/%) $(DESTDIR)/lib/ld.so.1
install-progs: $(DESTDIR)/bin/ldd
install-headers: $(ALL_INCLUDES:include/%=$(DESTDIR)/usr/include/%)
install: install-libs install-progs install-headers

clean:
	$(Q)rm -rf "$(OUT)"

.PHONY: all build clean install
