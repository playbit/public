#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
#!DEP ports/libunwind [transitive]
include ../../tools/playbit.defs.mk

CXXFLAGS_ALL := \
	--target=$(ARCH)-playbit -fPIC -O2 -DNDEBUG \
	-fno-modules \
	-funwind-tables \
	-Wno-user-defined-literals \
	-faligned-allocation \
	-std=c++20 \
  -nostdinc++ \
  -nostdlib++ \
  -D_LIBCXXABI_BUILDING_LIBRARY \
  -D_LIBCPP_BUILDING_LIBRARY \
  -I../libcxx \
  -I. \
  -Iinclude \
  -I../libunwind/include \
  -I../libcxx/include.c++.v1

ifeq ($(ARCH),wasm32)
	CXXFLAGS_ALL += -D_LIBCXXABI_HAS_NO_THREADS
else
  CXXFLAGS_ALL += -D_LIBCPP_HAS_THREAD_API_PTHREAD
endif

SRCS := \
  abort_message.cpp \
  cxa_aux_runtime.cpp \
  cxa_default_handlers.cpp \
  cxa_demangle.cpp \
  cxa_exception_storage.cpp \
  cxa_guard.cpp \
  cxa_handlers.cpp \
  cxa_vector.cpp \
  cxa_virtual.cpp \
  fallback_malloc.cpp \
  private_typeinfo.cpp \
  stdlib_exception.cpp \
  stdlib_new_delete.cpp \
  stdlib_stdexcept.cpp \
  stdlib_typeinfo.cpp
ifeq ($(ARCH),wasm32)
  SRCS += \
  	cxa_noexception.cpp
else
  SRCS += \
    cxa_exception.cpp \
    cxa_personality.cpp \
    cxa_thread_atexit.cpp
endif

HEADERS := \
	include/__cxxabi_config.h \
	include/cxxabi.h

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))
DESTDIR_HEADERS := $(patsubst %,$(DESTDIR)/usr/%,$(HEADERS))
PRODUCTS := $(DESTDIR)/lib/libc++abi.a $(DESTDIR_HEADERS)

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

$(DESTDIR)/usr/include/%: include/%
	@echo "COPY $< -> $@"
	$(Q)install -D -m0644 "$<" "$@"

$(DESTDIR)/lib/libc++abi.a: $(OBJS)
	@echo "AR $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)rm -f "$@"
	$(Q)ar rcs "$@" $^

$(BUILDDIR)/%.cpp.o: %.cpp
	@echo "CXX $<"
	$(Q)$(CXX) $(CXXFLAGS_ALL) -c -o $@ $<

.PHONY: all clean upgrade
