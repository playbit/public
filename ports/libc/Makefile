#!BOOTSTRAP
#!BUILDTOOL src/cc if HERMETIC
#!DEP src/rootfs [transitive] if HERMETIC and ARCH == NATIVE_ARCH
#
#!IGNORE wasi if ARCH != "wasm32"
#!IGNORE src if ARCH == "wasm32"
#!IGNORE include if ARCH == "wasm32"
#!IGNORE upgrade-musl.sh
#!IGNORE upgrade-wasi.sh
include ../../tools/playbit.defs.mk

MUSL_VERSION := 1.2.5
WASI_VERSION := sdk-21
OUT := $(BUILDDIR)

ifeq ($(ARCH),wasm32)
all:
	$(Q)$(MAKE) -C wasi OUT="$(OUT)" ARCH="$(ARCH)" V="$(V)" DESTDIR="$(DESTDIR)" install
build:
	$(Q)$(MAKE) -C wasi OUT="$(OUT)" ARCH="$(ARCH)" V="$(V)" DESTDIR="$(DESTDIR)" all
clean:
	$(Q)$(MAKE) -C wasi OUT="$(OUT)" ARCH="$(ARCH)" V="$(V)" DESTDIR="$(DESTDIR)" clean
else
include musl.mk
endif

# Hack to make it possible to run dynamically-linked programs on buildhost
/lib/ld.so.1: all
	$(QLOG) "SYMLINK $@ -> $(DESTDIR)/lib/libc.so"
	$(Q)ln -sf $(DESTDIR)/lib/libc.so $@

upgrade-musl:
	$(Q)bash upgrade-musl.sh

upgrade-wasi:
	$(Q)bash upgrade-wasi.sh

.PHONY: upgrade-musl upgrade-wasi
