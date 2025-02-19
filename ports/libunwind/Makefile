#!BOOTSTRAP
#!DEP ports/libc
include ../../tools/playbit.defs.mk

COMPILE_FLAGS_ALL := \
	--target=$(ARCH)-playbit -fPIC -O2 -DNDEBUG \
	-funwind-tables -Wno-user-defined-literals -faligned-allocation -fno-modules \
	-D_LIBUNWIND_IS_NATIVE_ONLY -isystem include

ASMFLAGS_ALL := $(COMPILE_FLAGS_ALL)
CFLAGS_ALL := $(COMPILE_FLAGS_ALL) -std=c99
CXXFLAGS_ALL := $(COMPILE_FLAGS_ALL) -std=c++11 -nostdinc++ -nostdlib++ \
	-fomit-frame-pointer \
	-fno-exceptions \
	-fno-rtti \
	-D_LIBCPP_HAS_THREAD_API_PTHREAD

ifeq ($(ARCH),wasm32)
# empty library
OBJS :=
PRODUCTS := $(DESTDIR)/lib/libunwind.a
else
SRCS := \
  libunwind.cpp \
  Unwind-seh.cpp \
  Unwind-sjlj.c \
  UnwindLevel1-gcc-ext.c \
  UnwindLevel1.c \
  UnwindRegistersRestore.S \
  UnwindRegistersSave.S
ifeq ($(ARCH),aarch64)
	SRCS += Unwind-EHABI.cpp
endif
HEADERS := \
	include/libunwind.h \
	include/unwind.h \
	include/unwind_arm_ehabi.h \
	include/unwind_itanium.h
DESTDIR_HEADERS := $(addprefix $(DESTDIR)/usr/,$(HEADERS))
OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))
PRODUCTS := $(DESTDIR)/lib/libunwind.a $(DESTDIR_HEADERS)
endif

all: $(PRODUCTS)

clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

upgrade:
	@echo "Please run $$(realpath "$$PWD/..")/libcxx/upgrade-libcxx.sh" >&2
	@exit 1

OBJ_DIRS := $(sort $(patsubst %/,%,$(dir $(OBJS))))
$(OBJS): | $(OBJ_DIRS)
$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

$(DESTDIR)/usr/include/%.h: include/%.h
	@echo "COPY $< -> $@"
	$(Q)install -m0644 -D "$<" "$@"

$(DESTDIR)/lib/libunwind.a: $(OBJS)
$(DESTDIR)/lib/%.a:
	@echo "AR $@"
	$(Q)rm -f $@
	$(Q)mkdir -p $(@D)
	$(Q)ar rcs $@ $^

$(BUILDDIR)/%.cpp.o: %.cpp
	@echo "CXX $<"
	$(Q)$(CXX) $(CXXFLAGS_ALL) -c -o $@ $<

$(BUILDDIR)/%.c.o: %.c
	@echo "CC $<"
	$(Q)$(CC) $(CFLAGS_ALL) -c -o $@ $<

$(BUILDDIR)/%.S.o: %.S
	@echo "AS $<"
	$(Q)$(CC) $(ASMFLAGS_ALL) -c -o $@ $<

.PHONY: all clean upgrade
