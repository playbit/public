#!BOOTSTRAP
#!BUILDTOOL src/cc if HERMETIC
#!BUILDTOOL src/libc if HERMETIC
#!DEP ports/libc
include ../../tools/playbit.defs.mk

BUSYBOX_VERSION := 1.36.1
PROGS := $(shell grep -vE '^\s*#|^\s*$$' progs.txt)
DESTDIR_PROGS := $(addprefix $(DESTDIR),$(PROGS))
SRCS := $(wildcard */*.c) $(wildcard */*.h)

CFLAGS := --target=$(ARCH)-playbit -static -w
ifeq ($(DEBUG),)
	CFLAGS += -O2 -flto=thin
else
	CFLAGS += -g -O0
endif

all: $(DESTDIR_PROGS)

clean:
	$(Q)rm -rf "$(BUILDDIR)" $(DESTDIR_PROGS)

upgrade:
	$(Q)bash upgrade-busybox.sh

check-progs: $(BUILDDIR)/busybox
	$(Q)grep -vE '^\s*#|^\s*$$' progs.txt | sed -E 's/^.+\///' | sort -u > /tmp/busybox-ls1
	$(Q)"$(BUILDDIR)/busybox" --list | sort -u > /tmp/busybox-ls2
	$(Q)diff -u /tmp/busybox-ls1 /tmp/busybox-ls2 || \
	    (echo "progs.txt differs from '$(BUILDDIR)/busybox --list'"; exit 1)

$(DESTDIR)/sbin/busybox: $(BUILDDIR)/busybox | $(DESTDIR)/sbin
	$(QLOG) "COPY $< -> $@"
	$(Q)install -m0755 "$<" "$@"

$(DESTDIR)/sbin/%: $(DESTDIR)/sbin/busybox | $(DESTDIR)/sbin
	$(QLOG) "LINK $@"
	$(Q)ln -f "$<" "$@"

$(DESTDIR)/bin/%: $(DESTDIR)/sbin/busybox | $(DESTDIR)/bin
	@echo "LINK $@"
	$(Q)ln -f "$<" "$@"

$(DESTDIR)/bin:
	mkdir -p "$@"

$(DESTDIR)/sbin:
	mkdir -p "$@"

$(BUILDDIR)/busybox: $(BUILDDIR)/.config
	$(QLOG) "MAKE -C $(BUILDDIR)"
	$(Q)PATH=$(BUILDDIR)/xbin:$(PATH) \
	$(MAKE) -C $(BUILDDIR) \
		ARCH=$(ARCH) \
		AS=clang \
		CC=clang \
		LD=ld \
		HOSTCC=clang \
		HOSTCXX=clang++ \
		HOSTCFLAGS="-static -w" \
		HOSTCXXFLAGS="-static -w" \
		HOSTLDFLAGS="-static" \
		CC=clang \
		CXX=clang++ \
		CFLAGS="$(CFLAGS)" \
		CXXFLAGS="$(CFLAGS)" \
		LDFLAGS="-static" \
		$(if $(filter 1,$(V)),V=1,)
ifneq ($(DEBUG),)
	$(Q)cp $(BUILDDIR)/busybox_unstripped $@
endif
	$(Q)touch "$@"

$(BUILDDIR)/.config: busybox.conf $(BUILDDIR)/Makefile \
		$(BUILDDIR)/xbin/gcc \
		$(BUILDDIR)/xbin/ld \
		$(BUILDDIR)/xbin/pod2text \
		$(BUILDDIR)/xbin/pod2man \
		$(BUILDDIR)/xbin/pod2html
	$(QLOG) "COPY $< -> $@"
	$(Q)cp $< $@
	$(Q)sed -i -E -e 's@^CONFIG_EXTRA_CFLAGS="@CONFIG_EXTRA_CFLAGS="'"--target=$(ARCH)-playbit "'@' $@
	$(Q)sed -i -E -e 's@^CONFIG_EXTRA_LDFLAGS="@CONFIG_EXTRA_LDFLAGS="'"--target=$(ARCH)-playbit "'@' $@
	$(Q)sed -i -E -e 's@^CONFIG_SYSROOT=.+@CONFIG_SYSROOT="'"$(DESTDIR)"'"@' $@

# busybox really wants to build with gcc, so we "trick" it by putting "gcc" on PATH

$(BUILDDIR)/xbin/gcc: $(BUILDDIR)/Makefile
	$(QLOG) "GEN $@"
	$(Q)mkdir -p $(@D)
	$(Q)echo "#!/bin/sh" > $@
	$(Q)echo "exec $$(command -v clang) \"$$""@\" -w -static" >> $@
	$(Q)chmod +x $@

$(BUILDDIR)/xbin/ld: $(BUILDDIR)/Makefile
	$(QLOG) "GEN $@"
	$(Q)mkdir -p $(@D)
	$(Q)echo "#!/bin/sh" > $@
	$(Q)echo "exec $$(command -v ld.lld) --static \"$$""@\"" >> $@
	$(Q)chmod +x $@

$(BUILDDIR)/xbin/pod2text:
$(BUILDDIR)/xbin/pod2man:
$(BUILDDIR)/xbin/pod2html:
$(BUILDDIR)/xbin/pod%: $(BUILDDIR)/Makefile
	$(QLOG) "GEN $@"
	$(Q)mkdir -p $(@D)
	$(Q)echo "#!/bin/true" > $@
	$(Q)chmod +x $@

$(BUILDDIR)/Makefile: busybox.mk $(SRCS)
	$(QLOG) "COPY $(CURDIR)/ -> $(@D)/"
	$(Q)rm -rf "$(@D)"
	$(Q)mkdir -p "$(@D)"
	$(Q)cp -RT . "$(@D)"
	$(Q)mv "$(@D)/busybox.mk" "$@"
	$(Q)touch $@

.PHONY: all clean upgrade check-progs
