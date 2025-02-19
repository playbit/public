#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
#!DEP ports/libcxxabi [transitive]
#!DEP ports/libunwind [transitive] if ARCH != "wasm32"
include ../../tools/playbit.defs.mk

HEADERS := $(shell find include.c++.v1 -type f)
DESTDIR_HEADERS := $(patsubst include.c++.v1/%,$(DESTDIR)/usr/include/c++/v1/%,$(HEADERS))
PRODUCTS := $(DESTDIR)/lib/libc++.a $(DESTDIR_HEADERS)

LIBCXX_ABI_VERSION := 1

CXXFLAGS_ALL := \
	--target=$(ARCH)-playbit -fPIC -O2 -DNDEBUG \
	-Wno-user-defined-literals \
	-fno-modules \
	-faligned-allocation \
	-fvisibility-inlines-hidden \
	-fvisibility=hidden \
	-std=c++20 \
	-nostdinc++ \
	-nostdlib++ \
	-I. \
	-Iinclude \
	-Iinclude.c++.v1 \
	-I../libcxxabi/include \
  -DLIBCXX_BUILDING_LIBCXXABI \
	-D_LIBCPP_BUILDING_LIBRARY \
	-D_LIBCPP_REMOVE_TRANSITIVE_INCLUDES
ifeq ($(ARCH),wasm32)
	CXXFLAGS_ALL += -fno-exceptions -fno-rtti
else
	CXXFLAGS_ALL += -D_LIBCPP_LINK_PTHREAD_LIB
endif

SRCS := \
	algorithm.cpp \
	any.cpp \
	atomic.cpp \
	barrier.cpp \
	bind.cpp \
	charconv.cpp \
	chrono.cpp \
	condition_variable.cpp \
	condition_variable_destructor.cpp \
	exception.cpp \
	filesystem/filesystem_clock.cpp \
	filesystem/filesystem_error.cpp \
	filesystem/path.cpp \
	functional.cpp \
	future.cpp \
	hash.cpp \
	ios.cpp \
	ios.instantiations.cpp \
	iostream.cpp \
	legacy_debug_handler.cpp \
	legacy_pointer_safety.cpp \
	locale.cpp \
	memory.cpp \
	memory_resource.cpp \
	mutex.cpp \
	mutex_destructor.cpp \
	new.cpp \
	new_handler.cpp \
	new_helpers.cpp \
	optional.cpp \
	print.cpp \
	random.cpp \
	random_shuffle.cpp \
	regex.cpp \
	ryu/d2fixed.cpp \
	ryu/d2s.cpp \
	ryu/f2s.cpp \
	shared_mutex.cpp \
	stdexcept.cpp \
	string.cpp \
	strstream.cpp \
	system_error.cpp \
	thread.cpp \
	typeinfo.cpp \
	valarray.cpp \
	variant.cpp \
	vector.cpp \
	verbose_abort.cpp

ifneq ($(ARCH),wasm32)
SRCS += \
  filesystem/directory_entry.cpp \
  filesystem/directory_iterator.cpp \
  filesystem/operations.cpp
endif

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))

all: $(PRODUCTS)

clean:
	$(Q)rm -rf "$(BUILDDIR)" $(PRODUCTS)

upgrade:
	$(Q)bash upgrade-libcxx.sh

OBJ_DIRS := $(sort $(patsubst %/,%,$(dir $(OBJS))))
$(OBJS): | $(OBJ_DIRS)
$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

$(DESTDIR)/usr/include/c++/v1/%: include.c++.v1/%
	$(Q)install -D -m0644 "$<" "$@"

$(DESTDIR)/lib/libc++.a: $(OBJS)
	@echo "AR $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)rm -f "$@"
	$(Q)ar rcs "$@" $^

$(DESTDIR)/lib/libc++.so: $(OBJS)
	@echo "LINK $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(CFLAGS_ALL) $(LDFLAGS_ALL) -nostdlib -shared \
		-Wl,-e,_dlstart -o $@ $(LOBJS) $(LDSO_OBJS) -lclang_rt.builtins

$(BUILDDIR)/%.cpp.o: %.cpp
	@echo "CXX $<"
	$(Q)$(CXX) $(CXXFLAGS_ALL) -c -o $@ $<

.PHONY: all clean upgrade

