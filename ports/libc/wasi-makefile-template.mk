# this file is normally included by "../Makefile"
Q = $(if $(filter 1,$(V)),,@)
OUT ?= out
OBJ := $(OUT)/obj
CC := @CC@

EMPTY_LIB_NAMES := m rt pthread crypt util xnet resolv
EMPTY_LIBS      := $(EMPTY_LIB_NAMES:%=$(OUT)/lib/lib%.a)
CRT_LIBS        := $(OUT)/lib/crt1.o \
                   $(OUT)/lib/crt1-command.o \
                   $(OUT)/lib/crt1-reactor.o
STATIC_LIBS     := @STATIC_LIBS@
ALL_LIBS        := $(CRT_LIBS) $(STATIC_LIBS) $(EMPTY_LIBS)

all: $(OBJ)/all.ok

$(OBJ)/all.ok: $(ALL_LIBS)
	$(Q)touch "$@" "$(OBJ)/mkdirs.ok"

install: all
	$(Q)mkdir -p "$(DESTDIR)/usr" "$(DESTDIR)/share"
	cp -RT "$(OUT)/lib" "$(DESTDIR)/lib"
	cp -RT "$(OUT)/include" "$(DESTDIR)/usr/include"
	cp -RT "$(OUT)/share" "$(DESTDIR)/share/wasi"

clean:
	$(Q)rm -rf "$(OUT)"

.PHONY: all clean install

$(OUT)/lib/%.a:
	@echo "AR $@"
	$(Q)rm -f $@
	$(Q)ar rcs $@ $^

$(OUT)/lib/%.o: $(OBJ)/libc-bottom-half/crt/%.o
	$(Q)cp $< $@
