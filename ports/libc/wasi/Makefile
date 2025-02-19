# this file is normally included by "../Makefile"
Q = $(if $(filter 1,$(V)),,@)
OUT ?= out
OBJ := $(OUT)/obj
CC := clang -O2 -DNDEBUG --target=wasm32-wasi -fno-trapping-math -Wall -Wextra -Werror -Wno-null-pointer-arithmetic -Wno-unused-parameter -Wno-sign-compare -Wno-unused-variable -Wno-unused-function -Wno-ignored-attributes -Wno-missing-braces -Wno-ignored-pragmas -Wno-unused-but-set-variable -Wno-unknown-warning-option -mthread-model single -isystem "include" -nostdlibinc

EMPTY_LIB_NAMES := m rt pthread crypt util xnet resolv
EMPTY_LIBS      := $(EMPTY_LIB_NAMES:%=$(OUT)/lib/lib%.a)
CRT_LIBS        := $(OUT)/lib/crt1.o \
                   $(OUT)/lib/crt1-command.o \
                   $(OUT)/lib/crt1-reactor.o
STATIC_LIBS     := $(OUT)/lib/libc-printscan-long-double.a $(OUT)/lib/libc-printscan-no-floating-point.a $(OUT)/lib/libc.a $(OUT)/lib/libdl.a $(OUT)/lib/libwasi-emulated-getpid.a $(OUT)/lib/libwasi-emulated-mman.a $(OUT)/lib/libwasi-emulated-process-clocks.a $(OUT)/lib/libwasi-emulated-signal.a
ALL_LIBS        := $(CRT_LIBS) $(STATIC_LIBS) $(EMPTY_LIBS)

all: $(OBJ)/all.ok

$(OBJ)/all.ok: $(ALL_LIBS)
	$(Q)touch "$@" "$(OBJ)/mkdirs.ok"

# TODO: create make rules for these files to be installed.
# Currently this slows down incremental "make" at src root.
install: all
	$(Q)mkdir -p "$(DESTDIR)/usr" "$(DESTDIR)/share"
	$(Q)cp -RT "$(OUT)/lib" "$(DESTDIR)/lib"
	$(Q)cp -RT include "$(DESTDIR)/usr/include"
	$(Q)cp -RT share "$(DESTDIR)/share/wasi"

clean:
	$(Q)rm -rf "$(OUT)"

.PHONY: all clean install

$(OUT)/lib/%.a:
	@echo "AR $@"
	$(Q)rm -f $@
	$(Q)ar rcs $@ $^

$(OUT)/lib/%.o: $(OBJ)/libc-bottom-half/crt/%.o
	$(Q)cp $< $@
$(OBJ)/libc-top-half/musl/src/signal/psignal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/signal/psignal.c"
	$(Q)$(CC)  -D_WASI_EMULATED_SIGNAL -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/signal/psignal.o -c libc-top-half/musl/src/signal/psignal.c
$(OBJ)/libc-top-half/musl/src/string/strsignal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strsignal.c"
	$(Q)$(CC)  -D_WASI_EMULATED_SIGNAL -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strsignal.o -c libc-top-half/musl/src/string/strsignal.c
$(OBJ)/libc-top-half/musl/src/internal/floatscan.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/floatscan.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/floatscan.no-floating-point.o -c libc-top-half/musl/src/internal/floatscan.c
$(OBJ)/libc-top-half/musl/src/stdio/vfprintf.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfprintf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.no-floating-point.o -c libc-top-half/musl/src/stdio/vfprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfscanf.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfscanf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.no-floating-point.o -c libc-top-half/musl/src/stdio/vfscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfwprintf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.no-floating-point.o -c libc-top-half/musl/src/stdio/vfwprintf.c
$(OBJ)/libc-top-half/musl/src/stdlib/strtod.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/strtod.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/strtod.no-floating-point.o -c libc-top-half/musl/src/stdlib/strtod.c
$(OBJ)/libc-top-half/musl/src/stdlib/wcstod.no-floating-point.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/wcstod.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_floating_point -D__wasilibc_printscan_floating_point_support_option="\"remove -lc-printscan-no-floating-point from the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.no-floating-point.o -c libc-top-half/musl/src/stdlib/wcstod.c
$(OBJ)/libc-top-half/musl/src/internal/floatscan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/floatscan.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/floatscan.o -c libc-top-half/musl/src/internal/floatscan.c
$(OBJ)/libc-top-half/musl/src/stdio/vfprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfprintf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.o -c libc-top-half/musl/src/stdio/vfprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfscanf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.o -c libc-top-half/musl/src/stdio/vfscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfwprintf.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.o -c libc-top-half/musl/src/stdio/vfwprintf.c
$(OBJ)/libc-top-half/musl/src/stdlib/strtod.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/strtod.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/strtod.o -c libc-top-half/musl/src/stdlib/strtod.c
$(OBJ)/libc-top-half/musl/src/stdlib/wcstod.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/wcstod.c"
	$(Q)$(CC)  -D__wasilibc_printscan_no_long_double -D__wasilibc_printscan_full_support_option="\"add -lc-printscan-long-double to the link command\"" -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.o -c libc-top-half/musl/src/stdlib/wcstod.c
$(OBJ)/dlmalloc/src/dlmalloc.o: | $(OBJ)/mkdirs.ok
	@echo "CC dlmalloc/src/dlmalloc.c"
	$(Q)$(CC)  -Idlmalloc/include -o $(OBJ)/dlmalloc/src/dlmalloc.o -c dlmalloc/src/dlmalloc.c
$(OBJ)/libc-bottom-half/clocks/clock.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/clocks/clock.c"
	$(Q)$(CC)  -Ilibc-bottom-half/cloudlibc/src -o $(OBJ)/libc-bottom-half/clocks/clock.o -c libc-bottom-half/clocks/clock.c
$(OBJ)/libc-bottom-half/clocks/getrusage.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/clocks/getrusage.c"
	$(Q)$(CC)  -Ilibc-bottom-half/cloudlibc/src -o $(OBJ)/libc-bottom-half/clocks/getrusage.o -c libc-bottom-half/clocks/getrusage.c
$(OBJ)/libc-bottom-half/clocks/times.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/clocks/times.c"
	$(Q)$(CC)  -Ilibc-bottom-half/cloudlibc/src -o $(OBJ)/libc-bottom-half/clocks/times.o -c libc-bottom-half/clocks/times.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/closedir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/closedir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/closedir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/closedir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/dirfd.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/dirfd.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/dirfd.o -c libc-bottom-half/cloudlibc/src/libc/dirent/dirfd.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdclosedir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/fdclosedir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdclosedir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/fdclosedir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdopendir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/fdopendir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdopendir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/fdopendir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/opendirat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/opendirat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/opendirat.o -c libc-bottom-half/cloudlibc/src/libc/dirent/opendirat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/readdir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/readdir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/readdir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/readdir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/rewinddir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/rewinddir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/rewinddir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/rewinddir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/scandirat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/scandirat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/scandirat.o -c libc-bottom-half/cloudlibc/src/libc/dirent/scandirat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/seekdir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/seekdir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/seekdir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/seekdir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/telldir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/dirent/telldir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/telldir.o -c libc-bottom-half/cloudlibc/src/libc/dirent/telldir.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/errno/errno.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/errno/errno.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/errno/errno.o -c libc-bottom-half/cloudlibc/src/libc/errno/errno.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/fcntl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/fcntl/fcntl.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/fcntl.o -c libc-bottom-half/cloudlibc/src/libc/fcntl/fcntl.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/openat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/fcntl/openat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/openat.o -c libc-bottom-half/cloudlibc/src/libc/fcntl/openat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fadvise.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fadvise.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fadvise.o -c libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fadvise.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fallocate.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fallocate.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fallocate.o -c libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fallocate.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/poll/poll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/poll/poll.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/poll/poll.o -c libc-bottom-half/cloudlibc/src/libc/poll/poll.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sched/sched_yield.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sched/sched_yield.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sched/sched_yield.o -c libc-bottom-half/cloudlibc/src/libc/sched/sched_yield.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdio/renameat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/stdio/renameat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdio/renameat.o -c libc-bottom-half/cloudlibc/src/libc/stdio/renameat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdlib/_Exit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/stdlib/_Exit.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdlib/_Exit.o -c libc-bottom-half/cloudlibc/src/libc/stdlib/_Exit.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/ioctl/ioctl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/ioctl/ioctl.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/ioctl/ioctl.o -c libc-bottom-half/cloudlibc/src/libc/sys/ioctl/ioctl.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/pselect.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/select/pselect.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/pselect.o -c libc-bottom-half/cloudlibc/src/libc/sys/select/pselect.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/select.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/select/select.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/select.o -c libc-bottom-half/cloudlibc/src/libc/sys/select/select.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/getsockopt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/socket/getsockopt.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/getsockopt.o -c libc-bottom-half/cloudlibc/src/libc/sys/socket/getsockopt.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/recv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/socket/recv.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/recv.o -c libc-bottom-half/cloudlibc/src/libc/sys/socket/recv.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/send.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/socket/send.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/send.o -c libc-bottom-half/cloudlibc/src/libc/sys/socket/send.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/shutdown.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/socket/shutdown.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/shutdown.o -c libc-bottom-half/cloudlibc/src/libc/sys/socket/shutdown.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/stat/fstat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstat.o -c libc-bottom-half/cloudlibc/src/libc/sys/stat/fstat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstatat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/stat/fstatat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstatat.o -c libc-bottom-half/cloudlibc/src/libc/sys/stat/fstatat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/futimens.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/stat/futimens.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/futimens.o -c libc-bottom-half/cloudlibc/src/libc/sys/stat/futimens.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/mkdirat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/stat/mkdirat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/mkdirat.o -c libc-bottom-half/cloudlibc/src/libc/sys/stat/mkdirat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/utimensat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/stat/utimensat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/utimensat.o -c libc-bottom-half/cloudlibc/src/libc/sys/stat/utimensat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/time/gettimeofday.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/time/gettimeofday.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/time/gettimeofday.o -c libc-bottom-half/cloudlibc/src/libc/sys/time/gettimeofday.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/preadv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/uio/preadv.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/preadv.o -c libc-bottom-half/cloudlibc/src/libc/sys/uio/preadv.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/pwritev.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/uio/pwritev.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/pwritev.o -c libc-bottom-half/cloudlibc/src/libc/sys/uio/pwritev.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/readv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/uio/readv.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/readv.o -c libc-bottom-half/cloudlibc/src/libc/sys/uio/readv.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/writev.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/sys/uio/writev.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/writev.o -c libc-bottom-half/cloudlibc/src/libc/sys/uio/writev.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_MONOTONIC.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/CLOCK_MONOTONIC.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_MONOTONIC.o -c libc-bottom-half/cloudlibc/src/libc/time/CLOCK_MONOTONIC.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_REALTIME.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/CLOCK_REALTIME.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_REALTIME.o -c libc-bottom-half/cloudlibc/src/libc/time/CLOCK_REALTIME.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_getres.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/clock_getres.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_getres.o -c libc-bottom-half/cloudlibc/src/libc/time/clock_getres.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_gettime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/clock_gettime.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_gettime.o -c libc-bottom-half/cloudlibc/src/libc/time/clock_gettime.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_nanosleep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/clock_nanosleep.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_nanosleep.o -c libc-bottom-half/cloudlibc/src/libc/time/clock_nanosleep.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/nanosleep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/nanosleep.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/nanosleep.o -c libc-bottom-half/cloudlibc/src/libc/time/nanosleep.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/time.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/time/time.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/time.o -c libc-bottom-half/cloudlibc/src/libc/time/time.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/faccessat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/faccessat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/faccessat.o -c libc-bottom-half/cloudlibc/src/libc/unistd/faccessat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fdatasync.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/fdatasync.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fdatasync.o -c libc-bottom-half/cloudlibc/src/libc/unistd/fdatasync.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fsync.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/fsync.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fsync.o -c libc-bottom-half/cloudlibc/src/libc/unistd/fsync.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/ftruncate.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/ftruncate.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/ftruncate.o -c libc-bottom-half/cloudlibc/src/libc/unistd/ftruncate.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/linkat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/linkat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/linkat.o -c libc-bottom-half/cloudlibc/src/libc/unistd/linkat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/lseek.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/lseek.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/lseek.o -c libc-bottom-half/cloudlibc/src/libc/unistd/lseek.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pread.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/pread.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pread.o -c libc-bottom-half/cloudlibc/src/libc/unistd/pread.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pwrite.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/pwrite.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pwrite.o -c libc-bottom-half/cloudlibc/src/libc/unistd/pwrite.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/read.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/read.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/read.o -c libc-bottom-half/cloudlibc/src/libc/unistd/read.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/readlinkat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/readlinkat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/readlinkat.o -c libc-bottom-half/cloudlibc/src/libc/unistd/readlinkat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/sleep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/sleep.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/sleep.o -c libc-bottom-half/cloudlibc/src/libc/unistd/sleep.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/symlinkat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/symlinkat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/symlinkat.o -c libc-bottom-half/cloudlibc/src/libc/unistd/symlinkat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/unlinkat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/unlinkat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/unlinkat.o -c libc-bottom-half/cloudlibc/src/libc/unistd/unlinkat.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/usleep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/usleep.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/usleep.o -c libc-bottom-half/cloudlibc/src/libc/unistd/usleep.c
$(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/write.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/cloudlibc/src/libc/unistd/write.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/write.o -c libc-bottom-half/cloudlibc/src/libc/unistd/write.c
$(OBJ)/libc-bottom-half/sources/__errno_location.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__errno_location.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__errno_location.o -c libc-bottom-half/sources/__errno_location.c
$(OBJ)/libc-bottom-half/sources/__main_void.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__main_void.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__main_void.o -c libc-bottom-half/sources/__main_void.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_dt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_dt.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_dt.o -c libc-bottom-half/sources/__wasilibc_dt.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_environ.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_environ.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_environ.o -c libc-bottom-half/sources/__wasilibc_environ.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_fd_renumber.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_fd_renumber.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_fd_renumber.o -c libc-bottom-half/sources/__wasilibc_fd_renumber.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_initialize_environ.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_initialize_environ.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_initialize_environ.o -c libc-bottom-half/sources/__wasilibc_initialize_environ.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_real.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_real.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_real.o -c libc-bottom-half/sources/__wasilibc_real.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_rmdirat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_rmdirat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_rmdirat.o -c libc-bottom-half/sources/__wasilibc_rmdirat.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_tell.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_tell.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_tell.o -c libc-bottom-half/sources/__wasilibc_tell.c
$(OBJ)/libc-bottom-half/sources/__wasilibc_unlinkat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/__wasilibc_unlinkat.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/__wasilibc_unlinkat.o -c libc-bottom-half/sources/__wasilibc_unlinkat.c
$(OBJ)/libc-bottom-half/sources/abort.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/abort.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/abort.o -c libc-bottom-half/sources/abort.c
$(OBJ)/libc-bottom-half/sources/accept.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/accept.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/accept.o -c libc-bottom-half/sources/accept.c
$(OBJ)/libc-bottom-half/sources/at_fdcwd.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/at_fdcwd.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/at_fdcwd.o -c libc-bottom-half/sources/at_fdcwd.c
$(OBJ)/libc-bottom-half/sources/chdir.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/chdir.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/chdir.o -c libc-bottom-half/sources/chdir.c
$(OBJ)/libc-bottom-half/sources/complex-builtins.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/complex-builtins.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/complex-builtins.o -c libc-bottom-half/sources/complex-builtins.c
$(OBJ)/libc-bottom-half/sources/environ.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/environ.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/environ.o -c libc-bottom-half/sources/environ.c
$(OBJ)/libc-bottom-half/sources/errno.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/errno.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/errno.o -c libc-bottom-half/sources/errno.c
$(OBJ)/libc-bottom-half/sources/getcwd.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/getcwd.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/getcwd.o -c libc-bottom-half/sources/getcwd.c
$(OBJ)/libc-bottom-half/sources/getentropy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/getentropy.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/getentropy.o -c libc-bottom-half/sources/getentropy.c
$(OBJ)/libc-bottom-half/sources/isatty.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/isatty.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/isatty.o -c libc-bottom-half/sources/isatty.c
$(OBJ)/libc-bottom-half/sources/math/fmin-fmax.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/math/fmin-fmax.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/math/fmin-fmax.o -c libc-bottom-half/sources/math/fmin-fmax.c
$(OBJ)/libc-bottom-half/sources/math/math-builtins.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/math/math-builtins.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/math/math-builtins.o -c libc-bottom-half/sources/math/math-builtins.c
$(OBJ)/libc-bottom-half/sources/posix.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/posix.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/posix.o -c libc-bottom-half/sources/posix.c
$(OBJ)/libc-bottom-half/sources/preopens.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/preopens.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/preopens.o -c libc-bottom-half/sources/preopens.c
$(OBJ)/libc-bottom-half/sources/reallocarray.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/reallocarray.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/reallocarray.o -c libc-bottom-half/sources/reallocarray.c
$(OBJ)/libc-bottom-half/sources/sbrk.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/sbrk.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/sbrk.o -c libc-bottom-half/sources/sbrk.c
$(OBJ)/libc-bottom-half/sources/truncate.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/sources/truncate.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -o $(OBJ)/libc-bottom-half/sources/truncate.o -c libc-bottom-half/sources/truncate.c
$(OBJ)/libc-bottom-half/crt/crt1-command.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/crt/crt1-command.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -fPIC -fvisibility=default -o $(OBJ)/libc-bottom-half/crt/crt1-command.o -c libc-bottom-half/crt/crt1-command.c
$(OBJ)/libc-bottom-half/crt/crt1-reactor.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/crt/crt1-reactor.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -fPIC -fvisibility=default -o $(OBJ)/libc-bottom-half/crt/crt1-reactor.o -c libc-bottom-half/crt/crt1-reactor.c
$(OBJ)/libc-bottom-half/crt/crt1.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/crt/crt1.c"
	$(Q)$(CC)  -Ilibc-bottom-half/headers/private -Ilibc-bottom-half/cloudlibc/src/include -Ilibc-bottom-half/cloudlibc/src -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -fPIC -fvisibility=default -o $(OBJ)/libc-bottom-half/crt/crt1.o -c libc-bottom-half/crt/crt1.c
$(OBJ)/libc-top-half/musl/src/complex/__cexp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/__cexp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/__cexp.o -c libc-top-half/musl/src/complex/__cexp.c
$(OBJ)/libc-top-half/musl/src/complex/__cexpf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/__cexpf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/__cexpf.o -c libc-top-half/musl/src/complex/__cexpf.c
$(OBJ)/libc-top-half/musl/src/complex/cabs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cabs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cabs.o -c libc-top-half/musl/src/complex/cabs.c
$(OBJ)/libc-top-half/musl/src/complex/cabsf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cabsf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cabsf.o -c libc-top-half/musl/src/complex/cabsf.c
$(OBJ)/libc-top-half/musl/src/complex/cabsl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cabsl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cabsl.o -c libc-top-half/musl/src/complex/cabsl.c
$(OBJ)/libc-top-half/musl/src/complex/cacos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacos.o -c libc-top-half/musl/src/complex/cacos.c
$(OBJ)/libc-top-half/musl/src/complex/cacosf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacosf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacosf.o -c libc-top-half/musl/src/complex/cacosf.c
$(OBJ)/libc-top-half/musl/src/complex/cacosh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacosh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacosh.o -c libc-top-half/musl/src/complex/cacosh.c
$(OBJ)/libc-top-half/musl/src/complex/cacoshf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacoshf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacoshf.o -c libc-top-half/musl/src/complex/cacoshf.c
$(OBJ)/libc-top-half/musl/src/complex/cacoshl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacoshl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacoshl.o -c libc-top-half/musl/src/complex/cacoshl.c
$(OBJ)/libc-top-half/musl/src/complex/cacosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cacosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cacosl.o -c libc-top-half/musl/src/complex/cacosl.c
$(OBJ)/libc-top-half/musl/src/complex/carg.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/carg.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/carg.o -c libc-top-half/musl/src/complex/carg.c
$(OBJ)/libc-top-half/musl/src/complex/cargf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cargf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cargf.o -c libc-top-half/musl/src/complex/cargf.c
$(OBJ)/libc-top-half/musl/src/complex/cargl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cargl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cargl.o -c libc-top-half/musl/src/complex/cargl.c
$(OBJ)/libc-top-half/musl/src/complex/casin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casin.o -c libc-top-half/musl/src/complex/casin.c
$(OBJ)/libc-top-half/musl/src/complex/casinf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casinf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casinf.o -c libc-top-half/musl/src/complex/casinf.c
$(OBJ)/libc-top-half/musl/src/complex/casinh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casinh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casinh.o -c libc-top-half/musl/src/complex/casinh.c
$(OBJ)/libc-top-half/musl/src/complex/casinhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casinhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casinhf.o -c libc-top-half/musl/src/complex/casinhf.c
$(OBJ)/libc-top-half/musl/src/complex/casinhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casinhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casinhl.o -c libc-top-half/musl/src/complex/casinhl.c
$(OBJ)/libc-top-half/musl/src/complex/casinl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/casinl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/casinl.o -c libc-top-half/musl/src/complex/casinl.c
$(OBJ)/libc-top-half/musl/src/complex/catan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catan.o -c libc-top-half/musl/src/complex/catan.c
$(OBJ)/libc-top-half/musl/src/complex/catanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catanf.o -c libc-top-half/musl/src/complex/catanf.c
$(OBJ)/libc-top-half/musl/src/complex/catanh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catanh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catanh.o -c libc-top-half/musl/src/complex/catanh.c
$(OBJ)/libc-top-half/musl/src/complex/catanhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catanhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catanhf.o -c libc-top-half/musl/src/complex/catanhf.c
$(OBJ)/libc-top-half/musl/src/complex/catanhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catanhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catanhl.o -c libc-top-half/musl/src/complex/catanhl.c
$(OBJ)/libc-top-half/musl/src/complex/catanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/catanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/catanl.o -c libc-top-half/musl/src/complex/catanl.c
$(OBJ)/libc-top-half/musl/src/complex/ccos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccos.o -c libc-top-half/musl/src/complex/ccos.c
$(OBJ)/libc-top-half/musl/src/complex/ccosf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccosf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccosf.o -c libc-top-half/musl/src/complex/ccosf.c
$(OBJ)/libc-top-half/musl/src/complex/ccosh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccosh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccosh.o -c libc-top-half/musl/src/complex/ccosh.c
$(OBJ)/libc-top-half/musl/src/complex/ccoshf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccoshf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccoshf.o -c libc-top-half/musl/src/complex/ccoshf.c
$(OBJ)/libc-top-half/musl/src/complex/ccoshl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccoshl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccoshl.o -c libc-top-half/musl/src/complex/ccoshl.c
$(OBJ)/libc-top-half/musl/src/complex/ccosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ccosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ccosl.o -c libc-top-half/musl/src/complex/ccosl.c
$(OBJ)/libc-top-half/musl/src/complex/cexp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cexp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cexp.o -c libc-top-half/musl/src/complex/cexp.c
$(OBJ)/libc-top-half/musl/src/complex/cexpf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cexpf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cexpf.o -c libc-top-half/musl/src/complex/cexpf.c
$(OBJ)/libc-top-half/musl/src/complex/cexpl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cexpl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cexpl.o -c libc-top-half/musl/src/complex/cexpl.c
$(OBJ)/libc-top-half/musl/src/complex/clog.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/clog.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/clog.o -c libc-top-half/musl/src/complex/clog.c
$(OBJ)/libc-top-half/musl/src/complex/clogf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/clogf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/clogf.o -c libc-top-half/musl/src/complex/clogf.c
$(OBJ)/libc-top-half/musl/src/complex/clogl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/clogl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/clogl.o -c libc-top-half/musl/src/complex/clogl.c
$(OBJ)/libc-top-half/musl/src/complex/conj.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/conj.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/conj.o -c libc-top-half/musl/src/complex/conj.c
$(OBJ)/libc-top-half/musl/src/complex/conjf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/conjf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/conjf.o -c libc-top-half/musl/src/complex/conjf.c
$(OBJ)/libc-top-half/musl/src/complex/conjl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/conjl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/conjl.o -c libc-top-half/musl/src/complex/conjl.c
$(OBJ)/libc-top-half/musl/src/complex/cpow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cpow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cpow.o -c libc-top-half/musl/src/complex/cpow.c
$(OBJ)/libc-top-half/musl/src/complex/cpowf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cpowf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cpowf.o -c libc-top-half/musl/src/complex/cpowf.c
$(OBJ)/libc-top-half/musl/src/complex/cpowl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cpowl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cpowl.o -c libc-top-half/musl/src/complex/cpowl.c
$(OBJ)/libc-top-half/musl/src/complex/cproj.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cproj.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cproj.o -c libc-top-half/musl/src/complex/cproj.c
$(OBJ)/libc-top-half/musl/src/complex/cprojf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cprojf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cprojf.o -c libc-top-half/musl/src/complex/cprojf.c
$(OBJ)/libc-top-half/musl/src/complex/cprojl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/cprojl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/cprojl.o -c libc-top-half/musl/src/complex/cprojl.c
$(OBJ)/libc-top-half/musl/src/complex/csin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csin.o -c libc-top-half/musl/src/complex/csin.c
$(OBJ)/libc-top-half/musl/src/complex/csinf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csinf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csinf.o -c libc-top-half/musl/src/complex/csinf.c
$(OBJ)/libc-top-half/musl/src/complex/csinh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csinh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csinh.o -c libc-top-half/musl/src/complex/csinh.c
$(OBJ)/libc-top-half/musl/src/complex/csinhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csinhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csinhf.o -c libc-top-half/musl/src/complex/csinhf.c
$(OBJ)/libc-top-half/musl/src/complex/csinhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csinhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csinhl.o -c libc-top-half/musl/src/complex/csinhl.c
$(OBJ)/libc-top-half/musl/src/complex/csinl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csinl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csinl.o -c libc-top-half/musl/src/complex/csinl.c
$(OBJ)/libc-top-half/musl/src/complex/csqrt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csqrt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csqrt.o -c libc-top-half/musl/src/complex/csqrt.c
$(OBJ)/libc-top-half/musl/src/complex/csqrtf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csqrtf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csqrtf.o -c libc-top-half/musl/src/complex/csqrtf.c
$(OBJ)/libc-top-half/musl/src/complex/csqrtl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/csqrtl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/csqrtl.o -c libc-top-half/musl/src/complex/csqrtl.c
$(OBJ)/libc-top-half/musl/src/complex/ctan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctan.o -c libc-top-half/musl/src/complex/ctan.c
$(OBJ)/libc-top-half/musl/src/complex/ctanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctanf.o -c libc-top-half/musl/src/complex/ctanf.c
$(OBJ)/libc-top-half/musl/src/complex/ctanh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctanh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctanh.o -c libc-top-half/musl/src/complex/ctanh.c
$(OBJ)/libc-top-half/musl/src/complex/ctanhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctanhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctanhf.o -c libc-top-half/musl/src/complex/ctanhf.c
$(OBJ)/libc-top-half/musl/src/complex/ctanhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctanhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctanhl.o -c libc-top-half/musl/src/complex/ctanhl.c
$(OBJ)/libc-top-half/musl/src/complex/ctanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/complex/ctanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/complex/ctanl.o -c libc-top-half/musl/src/complex/ctanl.c
$(OBJ)/libc-top-half/musl/src/conf/confstr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/conf/confstr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/conf/confstr.o -c libc-top-half/musl/src/conf/confstr.c
$(OBJ)/libc-top-half/musl/src/conf/fpathconf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/conf/fpathconf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/conf/fpathconf.o -c libc-top-half/musl/src/conf/fpathconf.c
$(OBJ)/libc-top-half/musl/src/conf/legacy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/conf/legacy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/conf/legacy.o -c libc-top-half/musl/src/conf/legacy.c
$(OBJ)/libc-top-half/musl/src/conf/pathconf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/conf/pathconf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/conf/pathconf.o -c libc-top-half/musl/src/conf/pathconf.c
$(OBJ)/libc-top-half/musl/src/conf/sysconf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/conf/sysconf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/conf/sysconf.o -c libc-top-half/musl/src/conf/sysconf.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt.o -c libc-top-half/musl/src/crypt/crypt.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_blowfish.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_blowfish.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_blowfish.o -c libc-top-half/musl/src/crypt/crypt_blowfish.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_des.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_des.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_des.o -c libc-top-half/musl/src/crypt/crypt_des.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_md5.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_md5.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_md5.o -c libc-top-half/musl/src/crypt/crypt_md5.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_r.o -c libc-top-half/musl/src/crypt/crypt_r.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_sha256.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_sha256.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_sha256.o -c libc-top-half/musl/src/crypt/crypt_sha256.c
$(OBJ)/libc-top-half/musl/src/crypt/crypt_sha512.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/crypt_sha512.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/crypt_sha512.o -c libc-top-half/musl/src/crypt/crypt_sha512.c
$(OBJ)/libc-top-half/musl/src/crypt/encrypt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/crypt/encrypt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/crypt/encrypt.o -c libc-top-half/musl/src/crypt/encrypt.c
$(OBJ)/libc-top-half/musl/src/ctype/__ctype_b_loc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/__ctype_b_loc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/__ctype_b_loc.o -c libc-top-half/musl/src/ctype/__ctype_b_loc.c
$(OBJ)/libc-top-half/musl/src/ctype/__ctype_get_mb_cur_max.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/__ctype_get_mb_cur_max.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/__ctype_get_mb_cur_max.o -c libc-top-half/musl/src/ctype/__ctype_get_mb_cur_max.c
$(OBJ)/libc-top-half/musl/src/ctype/__ctype_tolower_loc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/__ctype_tolower_loc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/__ctype_tolower_loc.o -c libc-top-half/musl/src/ctype/__ctype_tolower_loc.c
$(OBJ)/libc-top-half/musl/src/ctype/__ctype_toupper_loc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/__ctype_toupper_loc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/__ctype_toupper_loc.o -c libc-top-half/musl/src/ctype/__ctype_toupper_loc.c
$(OBJ)/libc-top-half/musl/src/ctype/isalnum.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isalnum.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isalnum.o -c libc-top-half/musl/src/ctype/isalnum.c
$(OBJ)/libc-top-half/musl/src/ctype/isalpha.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isalpha.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isalpha.o -c libc-top-half/musl/src/ctype/isalpha.c
$(OBJ)/libc-top-half/musl/src/ctype/isascii.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isascii.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isascii.o -c libc-top-half/musl/src/ctype/isascii.c
$(OBJ)/libc-top-half/musl/src/ctype/isblank.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isblank.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isblank.o -c libc-top-half/musl/src/ctype/isblank.c
$(OBJ)/libc-top-half/musl/src/ctype/iscntrl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iscntrl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iscntrl.o -c libc-top-half/musl/src/ctype/iscntrl.c
$(OBJ)/libc-top-half/musl/src/ctype/isdigit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isdigit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isdigit.o -c libc-top-half/musl/src/ctype/isdigit.c
$(OBJ)/libc-top-half/musl/src/ctype/isgraph.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isgraph.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isgraph.o -c libc-top-half/musl/src/ctype/isgraph.c
$(OBJ)/libc-top-half/musl/src/ctype/islower.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/islower.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/islower.o -c libc-top-half/musl/src/ctype/islower.c
$(OBJ)/libc-top-half/musl/src/ctype/isprint.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isprint.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isprint.o -c libc-top-half/musl/src/ctype/isprint.c
$(OBJ)/libc-top-half/musl/src/ctype/ispunct.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/ispunct.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/ispunct.o -c libc-top-half/musl/src/ctype/ispunct.c
$(OBJ)/libc-top-half/musl/src/ctype/isspace.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isspace.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isspace.o -c libc-top-half/musl/src/ctype/isspace.c
$(OBJ)/libc-top-half/musl/src/ctype/isupper.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isupper.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isupper.o -c libc-top-half/musl/src/ctype/isupper.c
$(OBJ)/libc-top-half/musl/src/ctype/iswalnum.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswalnum.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswalnum.o -c libc-top-half/musl/src/ctype/iswalnum.c
$(OBJ)/libc-top-half/musl/src/ctype/iswalpha.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswalpha.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswalpha.o -c libc-top-half/musl/src/ctype/iswalpha.c
$(OBJ)/libc-top-half/musl/src/ctype/iswblank.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswblank.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswblank.o -c libc-top-half/musl/src/ctype/iswblank.c
$(OBJ)/libc-top-half/musl/src/ctype/iswcntrl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswcntrl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswcntrl.o -c libc-top-half/musl/src/ctype/iswcntrl.c
$(OBJ)/libc-top-half/musl/src/ctype/iswctype.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswctype.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswctype.o -c libc-top-half/musl/src/ctype/iswctype.c
$(OBJ)/libc-top-half/musl/src/ctype/iswdigit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswdigit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswdigit.o -c libc-top-half/musl/src/ctype/iswdigit.c
$(OBJ)/libc-top-half/musl/src/ctype/iswgraph.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswgraph.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswgraph.o -c libc-top-half/musl/src/ctype/iswgraph.c
$(OBJ)/libc-top-half/musl/src/ctype/iswlower.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswlower.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswlower.o -c libc-top-half/musl/src/ctype/iswlower.c
$(OBJ)/libc-top-half/musl/src/ctype/iswprint.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswprint.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswprint.o -c libc-top-half/musl/src/ctype/iswprint.c
$(OBJ)/libc-top-half/musl/src/ctype/iswpunct.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswpunct.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswpunct.o -c libc-top-half/musl/src/ctype/iswpunct.c
$(OBJ)/libc-top-half/musl/src/ctype/iswspace.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswspace.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswspace.o -c libc-top-half/musl/src/ctype/iswspace.c
$(OBJ)/libc-top-half/musl/src/ctype/iswupper.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswupper.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswupper.o -c libc-top-half/musl/src/ctype/iswupper.c
$(OBJ)/libc-top-half/musl/src/ctype/iswxdigit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/iswxdigit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/iswxdigit.o -c libc-top-half/musl/src/ctype/iswxdigit.c
$(OBJ)/libc-top-half/musl/src/ctype/isxdigit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/isxdigit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/isxdigit.o -c libc-top-half/musl/src/ctype/isxdigit.c
$(OBJ)/libc-top-half/musl/src/ctype/toascii.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/toascii.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/toascii.o -c libc-top-half/musl/src/ctype/toascii.c
$(OBJ)/libc-top-half/musl/src/ctype/tolower.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/tolower.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/tolower.o -c libc-top-half/musl/src/ctype/tolower.c
$(OBJ)/libc-top-half/musl/src/ctype/toupper.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/toupper.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/toupper.o -c libc-top-half/musl/src/ctype/toupper.c
$(OBJ)/libc-top-half/musl/src/ctype/towctrans.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/towctrans.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/towctrans.o -c libc-top-half/musl/src/ctype/towctrans.c
$(OBJ)/libc-top-half/musl/src/ctype/wcswidth.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/wcswidth.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/wcswidth.o -c libc-top-half/musl/src/ctype/wcswidth.c
$(OBJ)/libc-top-half/musl/src/ctype/wctrans.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/wctrans.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/wctrans.o -c libc-top-half/musl/src/ctype/wctrans.c
$(OBJ)/libc-top-half/musl/src/ctype/wcwidth.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/ctype/wcwidth.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/ctype/wcwidth.o -c libc-top-half/musl/src/ctype/wcwidth.c
$(OBJ)/libc-top-half/musl/src/dirent/alphasort.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/dirent/alphasort.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/dirent/alphasort.o -c libc-top-half/musl/src/dirent/alphasort.c
$(OBJ)/libc-top-half/musl/src/dirent/versionsort.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/dirent/versionsort.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/dirent/versionsort.o -c libc-top-half/musl/src/dirent/versionsort.c
$(OBJ)/libc-top-half/musl/src/env/__stack_chk_fail.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/__stack_chk_fail.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/__stack_chk_fail.o -c libc-top-half/musl/src/env/__stack_chk_fail.c
$(OBJ)/libc-top-half/musl/src/env/clearenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/clearenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/clearenv.o -c libc-top-half/musl/src/env/clearenv.c
$(OBJ)/libc-top-half/musl/src/env/getenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/getenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/getenv.o -c libc-top-half/musl/src/env/getenv.c
$(OBJ)/libc-top-half/musl/src/env/putenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/putenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/putenv.o -c libc-top-half/musl/src/env/putenv.c
$(OBJ)/libc-top-half/musl/src/env/setenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/setenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/setenv.o -c libc-top-half/musl/src/env/setenv.c
$(OBJ)/libc-top-half/musl/src/env/unsetenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/env/unsetenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/env/unsetenv.o -c libc-top-half/musl/src/env/unsetenv.c
$(OBJ)/libc-top-half/musl/src/errno/strerror.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/errno/strerror.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/errno/strerror.o -c libc-top-half/musl/src/errno/strerror.c
$(OBJ)/libc-top-half/musl/src/exit/assert.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/exit/assert.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/exit/assert.o -c libc-top-half/musl/src/exit/assert.c
$(OBJ)/libc-top-half/musl/src/exit/at_quick_exit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/exit/at_quick_exit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/exit/at_quick_exit.o -c libc-top-half/musl/src/exit/at_quick_exit.c
$(OBJ)/libc-top-half/musl/src/exit/atexit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/exit/atexit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/exit/atexit.o -c libc-top-half/musl/src/exit/atexit.c
$(OBJ)/libc-top-half/musl/src/exit/exit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/exit/exit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/exit/exit.o -c libc-top-half/musl/src/exit/exit.c
$(OBJ)/libc-top-half/musl/src/exit/quick_exit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/exit/quick_exit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/exit/quick_exit.o -c libc-top-half/musl/src/exit/quick_exit.c
$(OBJ)/libc-top-half/musl/src/fcntl/creat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fcntl/creat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fcntl/creat.o -c libc-top-half/musl/src/fcntl/creat.c
$(OBJ)/libc-top-half/musl/src/fenv/fegetexceptflag.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/fegetexceptflag.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/fegetexceptflag.o -c libc-top-half/musl/src/fenv/fegetexceptflag.c
$(OBJ)/libc-top-half/musl/src/fenv/feholdexcept.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/feholdexcept.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/feholdexcept.o -c libc-top-half/musl/src/fenv/feholdexcept.c
$(OBJ)/libc-top-half/musl/src/fenv/fenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/fenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/fenv.o -c libc-top-half/musl/src/fenv/fenv.c
$(OBJ)/libc-top-half/musl/src/fenv/fesetexceptflag.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/fesetexceptflag.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/fesetexceptflag.o -c libc-top-half/musl/src/fenv/fesetexceptflag.c
$(OBJ)/libc-top-half/musl/src/fenv/fesetround.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/fesetround.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/fesetround.o -c libc-top-half/musl/src/fenv/fesetround.c
$(OBJ)/libc-top-half/musl/src/fenv/feupdateenv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/fenv/feupdateenv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/fenv/feupdateenv.o -c libc-top-half/musl/src/fenv/feupdateenv.c
$(OBJ)/libc-top-half/musl/src/internal/defsysinfo.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/defsysinfo.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/defsysinfo.o -c libc-top-half/musl/src/internal/defsysinfo.c
$(OBJ)/libc-top-half/musl/src/internal/floatscan.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/floatscan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/floatscan.long-double.o -c libc-top-half/musl/src/internal/floatscan.c
$(OBJ)/libc-top-half/musl/src/internal/intscan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/intscan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/intscan.o -c libc-top-half/musl/src/internal/intscan.c
$(OBJ)/libc-top-half/musl/src/internal/libc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/libc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/libc.o -c libc-top-half/musl/src/internal/libc.c
$(OBJ)/libc-top-half/musl/src/internal/shgetc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/internal/shgetc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/internal/shgetc.o -c libc-top-half/musl/src/internal/shgetc.c
$(OBJ)/libc-top-half/musl/src/legacy/getpagesize.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/legacy/getpagesize.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/legacy/getpagesize.o -c libc-top-half/musl/src/legacy/getpagesize.c
$(OBJ)/libc-top-half/musl/src/locale/__lctrans.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/__lctrans.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/__lctrans.o -c libc-top-half/musl/src/locale/__lctrans.c
$(OBJ)/libc-top-half/musl/src/locale/__mo_lookup.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/__mo_lookup.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/__mo_lookup.o -c libc-top-half/musl/src/locale/__mo_lookup.c
$(OBJ)/libc-top-half/musl/src/locale/c_locale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/c_locale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/c_locale.o -c libc-top-half/musl/src/locale/c_locale.c
$(OBJ)/libc-top-half/musl/src/locale/catclose.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/catclose.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/catclose.o -c libc-top-half/musl/src/locale/catclose.c
$(OBJ)/libc-top-half/musl/src/locale/catgets.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/catgets.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/catgets.o -c libc-top-half/musl/src/locale/catgets.c
$(OBJ)/libc-top-half/musl/src/locale/catopen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/catopen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/catopen.o -c libc-top-half/musl/src/locale/catopen.c
$(OBJ)/libc-top-half/musl/src/locale/duplocale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/duplocale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/duplocale.o -c libc-top-half/musl/src/locale/duplocale.c
$(OBJ)/libc-top-half/musl/src/locale/freelocale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/freelocale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/freelocale.o -c libc-top-half/musl/src/locale/freelocale.c
$(OBJ)/libc-top-half/musl/src/locale/iconv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/iconv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/iconv.o -c libc-top-half/musl/src/locale/iconv.c
$(OBJ)/libc-top-half/musl/src/locale/iconv_close.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/iconv_close.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/iconv_close.o -c libc-top-half/musl/src/locale/iconv_close.c
$(OBJ)/libc-top-half/musl/src/locale/langinfo.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/langinfo.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/langinfo.o -c libc-top-half/musl/src/locale/langinfo.c
$(OBJ)/libc-top-half/musl/src/locale/locale_map.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/locale_map.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/locale_map.o -c libc-top-half/musl/src/locale/locale_map.c
$(OBJ)/libc-top-half/musl/src/locale/localeconv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/localeconv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/localeconv.o -c libc-top-half/musl/src/locale/localeconv.c
$(OBJ)/libc-top-half/musl/src/locale/newlocale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/newlocale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/newlocale.o -c libc-top-half/musl/src/locale/newlocale.c
$(OBJ)/libc-top-half/musl/src/locale/pleval.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/pleval.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/pleval.o -c libc-top-half/musl/src/locale/pleval.c
$(OBJ)/libc-top-half/musl/src/locale/setlocale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/setlocale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/setlocale.o -c libc-top-half/musl/src/locale/setlocale.c
$(OBJ)/libc-top-half/musl/src/locale/strcoll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/strcoll.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/strcoll.o -c libc-top-half/musl/src/locale/strcoll.c
$(OBJ)/libc-top-half/musl/src/locale/strfmon.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/strfmon.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/strfmon.o -c libc-top-half/musl/src/locale/strfmon.c
$(OBJ)/libc-top-half/musl/src/locale/strtod_l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/strtod_l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/strtod_l.o -c libc-top-half/musl/src/locale/strtod_l.c
$(OBJ)/libc-top-half/musl/src/locale/strxfrm.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/strxfrm.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/strxfrm.o -c libc-top-half/musl/src/locale/strxfrm.c
$(OBJ)/libc-top-half/musl/src/locale/uselocale.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/uselocale.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/uselocale.o -c libc-top-half/musl/src/locale/uselocale.c
$(OBJ)/libc-top-half/musl/src/locale/wcscoll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/wcscoll.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/wcscoll.o -c libc-top-half/musl/src/locale/wcscoll.c
$(OBJ)/libc-top-half/musl/src/locale/wcsxfrm.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/locale/wcsxfrm.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/locale/wcsxfrm.o -c libc-top-half/musl/src/locale/wcsxfrm.c
$(OBJ)/libc-top-half/musl/src/math/__cos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__cos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__cos.o -c libc-top-half/musl/src/math/__cos.c
$(OBJ)/libc-top-half/musl/src/math/__cosdf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__cosdf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__cosdf.o -c libc-top-half/musl/src/math/__cosdf.c
$(OBJ)/libc-top-half/musl/src/math/__cosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__cosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__cosl.o -c libc-top-half/musl/src/math/__cosl.c
$(OBJ)/libc-top-half/musl/src/math/__expo2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__expo2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__expo2.o -c libc-top-half/musl/src/math/__expo2.c
$(OBJ)/libc-top-half/musl/src/math/__expo2f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__expo2f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__expo2f.o -c libc-top-half/musl/src/math/__expo2f.c
$(OBJ)/libc-top-half/musl/src/math/__invtrigl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__invtrigl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__invtrigl.o -c libc-top-half/musl/src/math/__invtrigl.c
$(OBJ)/libc-top-half/musl/src/math/__math_divzero.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_divzero.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_divzero.o -c libc-top-half/musl/src/math/__math_divzero.c
$(OBJ)/libc-top-half/musl/src/math/__math_divzerof.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_divzerof.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_divzerof.o -c libc-top-half/musl/src/math/__math_divzerof.c
$(OBJ)/libc-top-half/musl/src/math/__math_invalid.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_invalid.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_invalid.o -c libc-top-half/musl/src/math/__math_invalid.c
$(OBJ)/libc-top-half/musl/src/math/__math_invalidf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_invalidf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_invalidf.o -c libc-top-half/musl/src/math/__math_invalidf.c
$(OBJ)/libc-top-half/musl/src/math/__math_invalidl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_invalidl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_invalidl.o -c libc-top-half/musl/src/math/__math_invalidl.c
$(OBJ)/libc-top-half/musl/src/math/__math_oflow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_oflow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_oflow.o -c libc-top-half/musl/src/math/__math_oflow.c
$(OBJ)/libc-top-half/musl/src/math/__math_oflowf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_oflowf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_oflowf.o -c libc-top-half/musl/src/math/__math_oflowf.c
$(OBJ)/libc-top-half/musl/src/math/__math_uflow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_uflow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_uflow.o -c libc-top-half/musl/src/math/__math_uflow.c
$(OBJ)/libc-top-half/musl/src/math/__math_uflowf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_uflowf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_uflowf.o -c libc-top-half/musl/src/math/__math_uflowf.c
$(OBJ)/libc-top-half/musl/src/math/__math_xflow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_xflow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_xflow.o -c libc-top-half/musl/src/math/__math_xflow.c
$(OBJ)/libc-top-half/musl/src/math/__math_xflowf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__math_xflowf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__math_xflowf.o -c libc-top-half/musl/src/math/__math_xflowf.c
$(OBJ)/libc-top-half/musl/src/math/__polevll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__polevll.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__polevll.o -c libc-top-half/musl/src/math/__polevll.c
$(OBJ)/libc-top-half/musl/src/math/__rem_pio2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__rem_pio2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__rem_pio2.o -c libc-top-half/musl/src/math/__rem_pio2.c
$(OBJ)/libc-top-half/musl/src/math/__rem_pio2_large.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__rem_pio2_large.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__rem_pio2_large.o -c libc-top-half/musl/src/math/__rem_pio2_large.c
$(OBJ)/libc-top-half/musl/src/math/__rem_pio2f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__rem_pio2f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__rem_pio2f.o -c libc-top-half/musl/src/math/__rem_pio2f.c
$(OBJ)/libc-top-half/musl/src/math/__rem_pio2l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__rem_pio2l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__rem_pio2l.o -c libc-top-half/musl/src/math/__rem_pio2l.c
$(OBJ)/libc-top-half/musl/src/math/__sin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__sin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__sin.o -c libc-top-half/musl/src/math/__sin.c
$(OBJ)/libc-top-half/musl/src/math/__sindf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__sindf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__sindf.o -c libc-top-half/musl/src/math/__sindf.c
$(OBJ)/libc-top-half/musl/src/math/__sinl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__sinl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__sinl.o -c libc-top-half/musl/src/math/__sinl.c
$(OBJ)/libc-top-half/musl/src/math/__tan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__tan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__tan.o -c libc-top-half/musl/src/math/__tan.c
$(OBJ)/libc-top-half/musl/src/math/__tandf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__tandf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__tandf.o -c libc-top-half/musl/src/math/__tandf.c
$(OBJ)/libc-top-half/musl/src/math/__tanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/__tanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/__tanl.o -c libc-top-half/musl/src/math/__tanl.c
$(OBJ)/libc-top-half/musl/src/math/acos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acos.o -c libc-top-half/musl/src/math/acos.c
$(OBJ)/libc-top-half/musl/src/math/acosf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acosf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acosf.o -c libc-top-half/musl/src/math/acosf.c
$(OBJ)/libc-top-half/musl/src/math/acosh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acosh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acosh.o -c libc-top-half/musl/src/math/acosh.c
$(OBJ)/libc-top-half/musl/src/math/acoshf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acoshf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acoshf.o -c libc-top-half/musl/src/math/acoshf.c
$(OBJ)/libc-top-half/musl/src/math/acoshl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acoshl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acoshl.o -c libc-top-half/musl/src/math/acoshl.c
$(OBJ)/libc-top-half/musl/src/math/acosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/acosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/acosl.o -c libc-top-half/musl/src/math/acosl.c
$(OBJ)/libc-top-half/musl/src/math/asin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asin.o -c libc-top-half/musl/src/math/asin.c
$(OBJ)/libc-top-half/musl/src/math/asinf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asinf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asinf.o -c libc-top-half/musl/src/math/asinf.c
$(OBJ)/libc-top-half/musl/src/math/asinh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asinh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asinh.o -c libc-top-half/musl/src/math/asinh.c
$(OBJ)/libc-top-half/musl/src/math/asinhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asinhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asinhf.o -c libc-top-half/musl/src/math/asinhf.c
$(OBJ)/libc-top-half/musl/src/math/asinhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asinhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asinhl.o -c libc-top-half/musl/src/math/asinhl.c
$(OBJ)/libc-top-half/musl/src/math/asinl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/asinl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/asinl.o -c libc-top-half/musl/src/math/asinl.c
$(OBJ)/libc-top-half/musl/src/math/atan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atan.o -c libc-top-half/musl/src/math/atan.c
$(OBJ)/libc-top-half/musl/src/math/atan2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atan2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atan2.o -c libc-top-half/musl/src/math/atan2.c
$(OBJ)/libc-top-half/musl/src/math/atan2f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atan2f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atan2f.o -c libc-top-half/musl/src/math/atan2f.c
$(OBJ)/libc-top-half/musl/src/math/atan2l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atan2l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atan2l.o -c libc-top-half/musl/src/math/atan2l.c
$(OBJ)/libc-top-half/musl/src/math/atanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atanf.o -c libc-top-half/musl/src/math/atanf.c
$(OBJ)/libc-top-half/musl/src/math/atanh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atanh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atanh.o -c libc-top-half/musl/src/math/atanh.c
$(OBJ)/libc-top-half/musl/src/math/atanhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atanhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atanhf.o -c libc-top-half/musl/src/math/atanhf.c
$(OBJ)/libc-top-half/musl/src/math/atanhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atanhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atanhl.o -c libc-top-half/musl/src/math/atanhl.c
$(OBJ)/libc-top-half/musl/src/math/atanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/atanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/atanl.o -c libc-top-half/musl/src/math/atanl.c
$(OBJ)/libc-top-half/musl/src/math/cbrt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cbrt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cbrt.o -c libc-top-half/musl/src/math/cbrt.c
$(OBJ)/libc-top-half/musl/src/math/cbrtf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cbrtf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cbrtf.o -c libc-top-half/musl/src/math/cbrtf.c
$(OBJ)/libc-top-half/musl/src/math/cbrtl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cbrtl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cbrtl.o -c libc-top-half/musl/src/math/cbrtl.c
$(OBJ)/libc-top-half/musl/src/math/ceill.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ceill.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ceill.o -c libc-top-half/musl/src/math/ceill.c
$(OBJ)/libc-top-half/musl/src/math/copysignl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/copysignl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/copysignl.o -c libc-top-half/musl/src/math/copysignl.c
$(OBJ)/libc-top-half/musl/src/math/cos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cos.o -c libc-top-half/musl/src/math/cos.c
$(OBJ)/libc-top-half/musl/src/math/cosf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cosf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cosf.o -c libc-top-half/musl/src/math/cosf.c
$(OBJ)/libc-top-half/musl/src/math/cosh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cosh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cosh.o -c libc-top-half/musl/src/math/cosh.c
$(OBJ)/libc-top-half/musl/src/math/coshf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/coshf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/coshf.o -c libc-top-half/musl/src/math/coshf.c
$(OBJ)/libc-top-half/musl/src/math/coshl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/coshl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/coshl.o -c libc-top-half/musl/src/math/coshl.c
$(OBJ)/libc-top-half/musl/src/math/cosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/cosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/cosl.o -c libc-top-half/musl/src/math/cosl.c
$(OBJ)/libc-top-half/musl/src/math/erf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/erf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/erf.o -c libc-top-half/musl/src/math/erf.c
$(OBJ)/libc-top-half/musl/src/math/erff.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/erff.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/erff.o -c libc-top-half/musl/src/math/erff.c
$(OBJ)/libc-top-half/musl/src/math/erfl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/erfl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/erfl.o -c libc-top-half/musl/src/math/erfl.c
$(OBJ)/libc-top-half/musl/src/math/exp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp.o -c libc-top-half/musl/src/math/exp.c
$(OBJ)/libc-top-half/musl/src/math/exp10.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp10.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp10.o -c libc-top-half/musl/src/math/exp10.c
$(OBJ)/libc-top-half/musl/src/math/exp10f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp10f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp10f.o -c libc-top-half/musl/src/math/exp10f.c
$(OBJ)/libc-top-half/musl/src/math/exp10l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp10l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp10l.o -c libc-top-half/musl/src/math/exp10l.c
$(OBJ)/libc-top-half/musl/src/math/exp2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp2.o -c libc-top-half/musl/src/math/exp2.c
$(OBJ)/libc-top-half/musl/src/math/exp2f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp2f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp2f.o -c libc-top-half/musl/src/math/exp2f.c
$(OBJ)/libc-top-half/musl/src/math/exp2f_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp2f_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp2f_data.o -c libc-top-half/musl/src/math/exp2f_data.c
$(OBJ)/libc-top-half/musl/src/math/exp2l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp2l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp2l.o -c libc-top-half/musl/src/math/exp2l.c
$(OBJ)/libc-top-half/musl/src/math/exp_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/exp_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/exp_data.o -c libc-top-half/musl/src/math/exp_data.c
$(OBJ)/libc-top-half/musl/src/math/expf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/expf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/expf.o -c libc-top-half/musl/src/math/expf.c
$(OBJ)/libc-top-half/musl/src/math/expl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/expl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/expl.o -c libc-top-half/musl/src/math/expl.c
$(OBJ)/libc-top-half/musl/src/math/expm1.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/expm1.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/expm1.o -c libc-top-half/musl/src/math/expm1.c
$(OBJ)/libc-top-half/musl/src/math/expm1f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/expm1f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/expm1f.o -c libc-top-half/musl/src/math/expm1f.c
$(OBJ)/libc-top-half/musl/src/math/expm1l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/expm1l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/expm1l.o -c libc-top-half/musl/src/math/expm1l.c
$(OBJ)/libc-top-half/musl/src/math/fabsl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fabsl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fabsl.o -c libc-top-half/musl/src/math/fabsl.c
$(OBJ)/libc-top-half/musl/src/math/fdim.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fdim.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fdim.o -c libc-top-half/musl/src/math/fdim.c
$(OBJ)/libc-top-half/musl/src/math/fdimf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fdimf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fdimf.o -c libc-top-half/musl/src/math/fdimf.c
$(OBJ)/libc-top-half/musl/src/math/fdiml.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fdiml.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fdiml.o -c libc-top-half/musl/src/math/fdiml.c
$(OBJ)/libc-top-half/musl/src/math/finite.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/finite.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/finite.o -c libc-top-half/musl/src/math/finite.c
$(OBJ)/libc-top-half/musl/src/math/finitef.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/finitef.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/finitef.o -c libc-top-half/musl/src/math/finitef.c
$(OBJ)/libc-top-half/musl/src/math/floorl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/floorl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/floorl.o -c libc-top-half/musl/src/math/floorl.c
$(OBJ)/libc-top-half/musl/src/math/fma.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fma.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fma.o -c libc-top-half/musl/src/math/fma.c
$(OBJ)/libc-top-half/musl/src/math/fmaf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmaf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmaf.o -c libc-top-half/musl/src/math/fmaf.c
$(OBJ)/libc-top-half/musl/src/math/fmal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmal.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmal.o -c libc-top-half/musl/src/math/fmal.c
$(OBJ)/libc-top-half/musl/src/math/fmaxl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmaxl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmaxl.o -c libc-top-half/musl/src/math/fmaxl.c
$(OBJ)/libc-top-half/musl/src/math/fminl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fminl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fminl.o -c libc-top-half/musl/src/math/fminl.c
$(OBJ)/libc-top-half/musl/src/math/fmod.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmod.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmod.o -c libc-top-half/musl/src/math/fmod.c
$(OBJ)/libc-top-half/musl/src/math/fmodf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmodf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmodf.o -c libc-top-half/musl/src/math/fmodf.c
$(OBJ)/libc-top-half/musl/src/math/fmodl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/fmodl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/fmodl.o -c libc-top-half/musl/src/math/fmodl.c
$(OBJ)/libc-top-half/musl/src/math/frexp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/frexp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/frexp.o -c libc-top-half/musl/src/math/frexp.c
$(OBJ)/libc-top-half/musl/src/math/frexpf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/frexpf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/frexpf.o -c libc-top-half/musl/src/math/frexpf.c
$(OBJ)/libc-top-half/musl/src/math/frexpl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/frexpl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/frexpl.o -c libc-top-half/musl/src/math/frexpl.c
$(OBJ)/libc-top-half/musl/src/math/hypot.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/hypot.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/hypot.o -c libc-top-half/musl/src/math/hypot.c
$(OBJ)/libc-top-half/musl/src/math/hypotf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/hypotf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/hypotf.o -c libc-top-half/musl/src/math/hypotf.c
$(OBJ)/libc-top-half/musl/src/math/hypotl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/hypotl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/hypotl.o -c libc-top-half/musl/src/math/hypotl.c
$(OBJ)/libc-top-half/musl/src/math/ilogb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ilogb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ilogb.o -c libc-top-half/musl/src/math/ilogb.c
$(OBJ)/libc-top-half/musl/src/math/ilogbf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ilogbf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ilogbf.o -c libc-top-half/musl/src/math/ilogbf.c
$(OBJ)/libc-top-half/musl/src/math/ilogbl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ilogbl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ilogbl.o -c libc-top-half/musl/src/math/ilogbl.c
$(OBJ)/libc-top-half/musl/src/math/j0.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/j0.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/j0.o -c libc-top-half/musl/src/math/j0.c
$(OBJ)/libc-top-half/musl/src/math/j0f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/j0f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/j0f.o -c libc-top-half/musl/src/math/j0f.c
$(OBJ)/libc-top-half/musl/src/math/j1.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/j1.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/j1.o -c libc-top-half/musl/src/math/j1.c
$(OBJ)/libc-top-half/musl/src/math/j1f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/j1f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/j1f.o -c libc-top-half/musl/src/math/j1f.c
$(OBJ)/libc-top-half/musl/src/math/jn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/jn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/jn.o -c libc-top-half/musl/src/math/jn.c
$(OBJ)/libc-top-half/musl/src/math/jnf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/jnf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/jnf.o -c libc-top-half/musl/src/math/jnf.c
$(OBJ)/libc-top-half/musl/src/math/ldexp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ldexp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ldexp.o -c libc-top-half/musl/src/math/ldexp.c
$(OBJ)/libc-top-half/musl/src/math/ldexpf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ldexpf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ldexpf.o -c libc-top-half/musl/src/math/ldexpf.c
$(OBJ)/libc-top-half/musl/src/math/ldexpl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/ldexpl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/ldexpl.o -c libc-top-half/musl/src/math/ldexpl.c
$(OBJ)/libc-top-half/musl/src/math/lgamma.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lgamma.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lgamma.o -c libc-top-half/musl/src/math/lgamma.c
$(OBJ)/libc-top-half/musl/src/math/lgamma_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lgamma_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lgamma_r.o -c libc-top-half/musl/src/math/lgamma_r.c
$(OBJ)/libc-top-half/musl/src/math/lgammaf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lgammaf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lgammaf.o -c libc-top-half/musl/src/math/lgammaf.c
$(OBJ)/libc-top-half/musl/src/math/lgammaf_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lgammaf_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lgammaf_r.o -c libc-top-half/musl/src/math/lgammaf_r.c
$(OBJ)/libc-top-half/musl/src/math/lgammal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lgammal.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lgammal.o -c libc-top-half/musl/src/math/lgammal.c
$(OBJ)/libc-top-half/musl/src/math/llrint.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llrint.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llrint.o -c libc-top-half/musl/src/math/llrint.c
$(OBJ)/libc-top-half/musl/src/math/llrintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llrintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llrintf.o -c libc-top-half/musl/src/math/llrintf.c
$(OBJ)/libc-top-half/musl/src/math/llrintl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llrintl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llrintl.o -c libc-top-half/musl/src/math/llrintl.c
$(OBJ)/libc-top-half/musl/src/math/llround.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llround.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llround.o -c libc-top-half/musl/src/math/llround.c
$(OBJ)/libc-top-half/musl/src/math/llroundf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llroundf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llroundf.o -c libc-top-half/musl/src/math/llroundf.c
$(OBJ)/libc-top-half/musl/src/math/llroundl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/llroundl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/llroundl.o -c libc-top-half/musl/src/math/llroundl.c
$(OBJ)/libc-top-half/musl/src/math/log.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log.o -c libc-top-half/musl/src/math/log.c
$(OBJ)/libc-top-half/musl/src/math/log10.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log10.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log10.o -c libc-top-half/musl/src/math/log10.c
$(OBJ)/libc-top-half/musl/src/math/log10f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log10f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log10f.o -c libc-top-half/musl/src/math/log10f.c
$(OBJ)/libc-top-half/musl/src/math/log10l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log10l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log10l.o -c libc-top-half/musl/src/math/log10l.c
$(OBJ)/libc-top-half/musl/src/math/log1p.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log1p.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log1p.o -c libc-top-half/musl/src/math/log1p.c
$(OBJ)/libc-top-half/musl/src/math/log1pf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log1pf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log1pf.o -c libc-top-half/musl/src/math/log1pf.c
$(OBJ)/libc-top-half/musl/src/math/log1pl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log1pl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log1pl.o -c libc-top-half/musl/src/math/log1pl.c
$(OBJ)/libc-top-half/musl/src/math/log2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log2.o -c libc-top-half/musl/src/math/log2.c
$(OBJ)/libc-top-half/musl/src/math/log2_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log2_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log2_data.o -c libc-top-half/musl/src/math/log2_data.c
$(OBJ)/libc-top-half/musl/src/math/log2f.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log2f.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log2f.o -c libc-top-half/musl/src/math/log2f.c
$(OBJ)/libc-top-half/musl/src/math/log2f_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log2f_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log2f_data.o -c libc-top-half/musl/src/math/log2f_data.c
$(OBJ)/libc-top-half/musl/src/math/log2l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log2l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log2l.o -c libc-top-half/musl/src/math/log2l.c
$(OBJ)/libc-top-half/musl/src/math/log_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/log_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/log_data.o -c libc-top-half/musl/src/math/log_data.c
$(OBJ)/libc-top-half/musl/src/math/logb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logb.o -c libc-top-half/musl/src/math/logb.c
$(OBJ)/libc-top-half/musl/src/math/logbf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logbf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logbf.o -c libc-top-half/musl/src/math/logbf.c
$(OBJ)/libc-top-half/musl/src/math/logbl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logbl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logbl.o -c libc-top-half/musl/src/math/logbl.c
$(OBJ)/libc-top-half/musl/src/math/logf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logf.o -c libc-top-half/musl/src/math/logf.c
$(OBJ)/libc-top-half/musl/src/math/logf_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logf_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logf_data.o -c libc-top-half/musl/src/math/logf_data.c
$(OBJ)/libc-top-half/musl/src/math/logl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/logl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/logl.o -c libc-top-half/musl/src/math/logl.c
$(OBJ)/libc-top-half/musl/src/math/lrint.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lrint.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lrint.o -c libc-top-half/musl/src/math/lrint.c
$(OBJ)/libc-top-half/musl/src/math/lrintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lrintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lrintf.o -c libc-top-half/musl/src/math/lrintf.c
$(OBJ)/libc-top-half/musl/src/math/lrintl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lrintl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lrintl.o -c libc-top-half/musl/src/math/lrintl.c
$(OBJ)/libc-top-half/musl/src/math/lround.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lround.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lround.o -c libc-top-half/musl/src/math/lround.c
$(OBJ)/libc-top-half/musl/src/math/lroundf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lroundf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lroundf.o -c libc-top-half/musl/src/math/lroundf.c
$(OBJ)/libc-top-half/musl/src/math/lroundl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/lroundl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/lroundl.o -c libc-top-half/musl/src/math/lroundl.c
$(OBJ)/libc-top-half/musl/src/math/modf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/modf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/modf.o -c libc-top-half/musl/src/math/modf.c
$(OBJ)/libc-top-half/musl/src/math/modff.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/modff.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/modff.o -c libc-top-half/musl/src/math/modff.c
$(OBJ)/libc-top-half/musl/src/math/modfl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/modfl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/modfl.o -c libc-top-half/musl/src/math/modfl.c
$(OBJ)/libc-top-half/musl/src/math/nan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nan.o -c libc-top-half/musl/src/math/nan.c
$(OBJ)/libc-top-half/musl/src/math/nanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nanf.o -c libc-top-half/musl/src/math/nanf.c
$(OBJ)/libc-top-half/musl/src/math/nanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nanl.o -c libc-top-half/musl/src/math/nanl.c
$(OBJ)/libc-top-half/musl/src/math/nearbyintl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nearbyintl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nearbyintl.o -c libc-top-half/musl/src/math/nearbyintl.c
$(OBJ)/libc-top-half/musl/src/math/nextafter.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nextafter.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nextafter.o -c libc-top-half/musl/src/math/nextafter.c
$(OBJ)/libc-top-half/musl/src/math/nextafterf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nextafterf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nextafterf.o -c libc-top-half/musl/src/math/nextafterf.c
$(OBJ)/libc-top-half/musl/src/math/nextafterl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nextafterl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nextafterl.o -c libc-top-half/musl/src/math/nextafterl.c
$(OBJ)/libc-top-half/musl/src/math/nexttoward.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nexttoward.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nexttoward.o -c libc-top-half/musl/src/math/nexttoward.c
$(OBJ)/libc-top-half/musl/src/math/nexttowardf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nexttowardf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nexttowardf.o -c libc-top-half/musl/src/math/nexttowardf.c
$(OBJ)/libc-top-half/musl/src/math/nexttowardl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/nexttowardl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/nexttowardl.o -c libc-top-half/musl/src/math/nexttowardl.c
$(OBJ)/libc-top-half/musl/src/math/pow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/pow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/pow.o -c libc-top-half/musl/src/math/pow.c
$(OBJ)/libc-top-half/musl/src/math/pow_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/pow_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/pow_data.o -c libc-top-half/musl/src/math/pow_data.c
$(OBJ)/libc-top-half/musl/src/math/powf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/powf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/powf.o -c libc-top-half/musl/src/math/powf.c
$(OBJ)/libc-top-half/musl/src/math/powf_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/powf_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/powf_data.o -c libc-top-half/musl/src/math/powf_data.c
$(OBJ)/libc-top-half/musl/src/math/powl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/powl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/powl.o -c libc-top-half/musl/src/math/powl.c
$(OBJ)/libc-top-half/musl/src/math/remainder.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remainder.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remainder.o -c libc-top-half/musl/src/math/remainder.c
$(OBJ)/libc-top-half/musl/src/math/remainderf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remainderf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remainderf.o -c libc-top-half/musl/src/math/remainderf.c
$(OBJ)/libc-top-half/musl/src/math/remainderl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remainderl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remainderl.o -c libc-top-half/musl/src/math/remainderl.c
$(OBJ)/libc-top-half/musl/src/math/remquo.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remquo.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remquo.o -c libc-top-half/musl/src/math/remquo.c
$(OBJ)/libc-top-half/musl/src/math/remquof.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remquof.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remquof.o -c libc-top-half/musl/src/math/remquof.c
$(OBJ)/libc-top-half/musl/src/math/remquol.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/remquol.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/remquol.o -c libc-top-half/musl/src/math/remquol.c
$(OBJ)/libc-top-half/musl/src/math/rintl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/rintl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/rintl.o -c libc-top-half/musl/src/math/rintl.c
$(OBJ)/libc-top-half/musl/src/math/round.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/round.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/round.o -c libc-top-half/musl/src/math/round.c
$(OBJ)/libc-top-half/musl/src/math/roundf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/roundf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/roundf.o -c libc-top-half/musl/src/math/roundf.c
$(OBJ)/libc-top-half/musl/src/math/roundl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/roundl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/roundl.o -c libc-top-half/musl/src/math/roundl.c
$(OBJ)/libc-top-half/musl/src/math/scalb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalb.o -c libc-top-half/musl/src/math/scalb.c
$(OBJ)/libc-top-half/musl/src/math/scalbf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalbf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalbf.o -c libc-top-half/musl/src/math/scalbf.c
$(OBJ)/libc-top-half/musl/src/math/scalbln.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalbln.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalbln.o -c libc-top-half/musl/src/math/scalbln.c
$(OBJ)/libc-top-half/musl/src/math/scalblnf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalblnf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalblnf.o -c libc-top-half/musl/src/math/scalblnf.c
$(OBJ)/libc-top-half/musl/src/math/scalblnl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalblnl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalblnl.o -c libc-top-half/musl/src/math/scalblnl.c
$(OBJ)/libc-top-half/musl/src/math/scalbn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalbn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalbn.o -c libc-top-half/musl/src/math/scalbn.c
$(OBJ)/libc-top-half/musl/src/math/scalbnf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalbnf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalbnf.o -c libc-top-half/musl/src/math/scalbnf.c
$(OBJ)/libc-top-half/musl/src/math/scalbnl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/scalbnl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/scalbnl.o -c libc-top-half/musl/src/math/scalbnl.c
$(OBJ)/libc-top-half/musl/src/math/signgam.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/signgam.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/signgam.o -c libc-top-half/musl/src/math/signgam.c
$(OBJ)/libc-top-half/musl/src/math/significand.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/significand.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/significand.o -c libc-top-half/musl/src/math/significand.c
$(OBJ)/libc-top-half/musl/src/math/significandf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/significandf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/significandf.o -c libc-top-half/musl/src/math/significandf.c
$(OBJ)/libc-top-half/musl/src/math/sin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sin.o -c libc-top-half/musl/src/math/sin.c
$(OBJ)/libc-top-half/musl/src/math/sincos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sincos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sincos.o -c libc-top-half/musl/src/math/sincos.c
$(OBJ)/libc-top-half/musl/src/math/sincosf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sincosf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sincosf.o -c libc-top-half/musl/src/math/sincosf.c
$(OBJ)/libc-top-half/musl/src/math/sincosl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sincosl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sincosl.o -c libc-top-half/musl/src/math/sincosl.c
$(OBJ)/libc-top-half/musl/src/math/sinf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sinf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sinf.o -c libc-top-half/musl/src/math/sinf.c
$(OBJ)/libc-top-half/musl/src/math/sinh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sinh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sinh.o -c libc-top-half/musl/src/math/sinh.c
$(OBJ)/libc-top-half/musl/src/math/sinhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sinhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sinhf.o -c libc-top-half/musl/src/math/sinhf.c
$(OBJ)/libc-top-half/musl/src/math/sinhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sinhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sinhl.o -c libc-top-half/musl/src/math/sinhl.c
$(OBJ)/libc-top-half/musl/src/math/sinl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sinl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sinl.o -c libc-top-half/musl/src/math/sinl.c
$(OBJ)/libc-top-half/musl/src/math/sqrt_data.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sqrt_data.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sqrt_data.o -c libc-top-half/musl/src/math/sqrt_data.c
$(OBJ)/libc-top-half/musl/src/math/sqrtl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/sqrtl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/sqrtl.o -c libc-top-half/musl/src/math/sqrtl.c
$(OBJ)/libc-top-half/musl/src/math/tan.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tan.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tan.o -c libc-top-half/musl/src/math/tan.c
$(OBJ)/libc-top-half/musl/src/math/tanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tanf.o -c libc-top-half/musl/src/math/tanf.c
$(OBJ)/libc-top-half/musl/src/math/tanh.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tanh.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tanh.o -c libc-top-half/musl/src/math/tanh.c
$(OBJ)/libc-top-half/musl/src/math/tanhf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tanhf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tanhf.o -c libc-top-half/musl/src/math/tanhf.c
$(OBJ)/libc-top-half/musl/src/math/tanhl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tanhl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tanhl.o -c libc-top-half/musl/src/math/tanhl.c
$(OBJ)/libc-top-half/musl/src/math/tanl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tanl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tanl.o -c libc-top-half/musl/src/math/tanl.c
$(OBJ)/libc-top-half/musl/src/math/tgamma.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tgamma.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tgamma.o -c libc-top-half/musl/src/math/tgamma.c
$(OBJ)/libc-top-half/musl/src/math/tgammaf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tgammaf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tgammaf.o -c libc-top-half/musl/src/math/tgammaf.c
$(OBJ)/libc-top-half/musl/src/math/tgammal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/tgammal.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/tgammal.o -c libc-top-half/musl/src/math/tgammal.c
$(OBJ)/libc-top-half/musl/src/math/truncl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/math/truncl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/math/truncl.o -c libc-top-half/musl/src/math/truncl.c
$(OBJ)/libc-top-half/musl/src/misc/a64l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/a64l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/a64l.o -c libc-top-half/musl/src/misc/a64l.c
$(OBJ)/libc-top-half/musl/src/misc/basename.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/basename.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/basename.o -c libc-top-half/musl/src/misc/basename.c
$(OBJ)/libc-top-half/musl/src/misc/dirname.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/dirname.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/dirname.o -c libc-top-half/musl/src/misc/dirname.c
$(OBJ)/libc-top-half/musl/src/misc/dl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/dl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/dl.o -c libc-top-half/musl/src/misc/dl.c
$(OBJ)/libc-top-half/musl/src/misc/ffs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/ffs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/ffs.o -c libc-top-half/musl/src/misc/ffs.c
$(OBJ)/libc-top-half/musl/src/misc/ffsl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/ffsl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/ffsl.o -c libc-top-half/musl/src/misc/ffsl.c
$(OBJ)/libc-top-half/musl/src/misc/ffsll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/ffsll.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/ffsll.o -c libc-top-half/musl/src/misc/ffsll.c
$(OBJ)/libc-top-half/musl/src/misc/fmtmsg.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/fmtmsg.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/fmtmsg.o -c libc-top-half/musl/src/misc/fmtmsg.c
$(OBJ)/libc-top-half/musl/src/misc/getdomainname.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/getdomainname.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/getdomainname.o -c libc-top-half/musl/src/misc/getdomainname.c
$(OBJ)/libc-top-half/musl/src/misc/gethostid.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/gethostid.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/gethostid.o -c libc-top-half/musl/src/misc/gethostid.c
$(OBJ)/libc-top-half/musl/src/misc/getopt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/getopt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/getopt.o -c libc-top-half/musl/src/misc/getopt.c
$(OBJ)/libc-top-half/musl/src/misc/getopt_long.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/getopt_long.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/getopt_long.o -c libc-top-half/musl/src/misc/getopt_long.c
$(OBJ)/libc-top-half/musl/src/misc/getsubopt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/getsubopt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/getsubopt.o -c libc-top-half/musl/src/misc/getsubopt.c
$(OBJ)/libc-top-half/musl/src/misc/nftw.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/nftw.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/nftw.o -c libc-top-half/musl/src/misc/nftw.c
$(OBJ)/libc-top-half/musl/src/misc/uname.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/misc/uname.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/misc/uname.o -c libc-top-half/musl/src/misc/uname.c
$(OBJ)/libc-top-half/musl/src/multibyte/btowc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/btowc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/btowc.o -c libc-top-half/musl/src/multibyte/btowc.c
$(OBJ)/libc-top-half/musl/src/multibyte/c16rtomb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/c16rtomb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/c16rtomb.o -c libc-top-half/musl/src/multibyte/c16rtomb.c
$(OBJ)/libc-top-half/musl/src/multibyte/c32rtomb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/c32rtomb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/c32rtomb.o -c libc-top-half/musl/src/multibyte/c32rtomb.c
$(OBJ)/libc-top-half/musl/src/multibyte/internal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/internal.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/internal.o -c libc-top-half/musl/src/multibyte/internal.c
$(OBJ)/libc-top-half/musl/src/multibyte/mblen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mblen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mblen.o -c libc-top-half/musl/src/multibyte/mblen.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbrlen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbrlen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbrlen.o -c libc-top-half/musl/src/multibyte/mbrlen.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc16.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbrtoc16.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc16.o -c libc-top-half/musl/src/multibyte/mbrtoc16.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc32.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbrtoc32.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc32.o -c libc-top-half/musl/src/multibyte/mbrtoc32.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbrtowc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbrtowc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbrtowc.o -c libc-top-half/musl/src/multibyte/mbrtowc.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbsinit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbsinit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbsinit.o -c libc-top-half/musl/src/multibyte/mbsinit.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbsnrtowcs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbsnrtowcs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbsnrtowcs.o -c libc-top-half/musl/src/multibyte/mbsnrtowcs.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbsrtowcs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbsrtowcs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbsrtowcs.o -c libc-top-half/musl/src/multibyte/mbsrtowcs.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbstowcs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbstowcs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbstowcs.o -c libc-top-half/musl/src/multibyte/mbstowcs.c
$(OBJ)/libc-top-half/musl/src/multibyte/mbtowc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/mbtowc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/mbtowc.o -c libc-top-half/musl/src/multibyte/mbtowc.c
$(OBJ)/libc-top-half/musl/src/multibyte/wcrtomb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wcrtomb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wcrtomb.o -c libc-top-half/musl/src/multibyte/wcrtomb.c
$(OBJ)/libc-top-half/musl/src/multibyte/wcsnrtombs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wcsnrtombs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wcsnrtombs.o -c libc-top-half/musl/src/multibyte/wcsnrtombs.c
$(OBJ)/libc-top-half/musl/src/multibyte/wcsrtombs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wcsrtombs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wcsrtombs.o -c libc-top-half/musl/src/multibyte/wcsrtombs.c
$(OBJ)/libc-top-half/musl/src/multibyte/wcstombs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wcstombs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wcstombs.o -c libc-top-half/musl/src/multibyte/wcstombs.c
$(OBJ)/libc-top-half/musl/src/multibyte/wctob.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wctob.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wctob.o -c libc-top-half/musl/src/multibyte/wctob.c
$(OBJ)/libc-top-half/musl/src/multibyte/wctomb.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/multibyte/wctomb.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/multibyte/wctomb.o -c libc-top-half/musl/src/multibyte/wctomb.c
$(OBJ)/libc-top-half/musl/src/network/htonl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/htonl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/htonl.o -c libc-top-half/musl/src/network/htonl.c
$(OBJ)/libc-top-half/musl/src/network/htons.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/htons.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/htons.o -c libc-top-half/musl/src/network/htons.c
$(OBJ)/libc-top-half/musl/src/network/in6addr_any.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/in6addr_any.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/in6addr_any.o -c libc-top-half/musl/src/network/in6addr_any.c
$(OBJ)/libc-top-half/musl/src/network/in6addr_loopback.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/in6addr_loopback.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/in6addr_loopback.o -c libc-top-half/musl/src/network/in6addr_loopback.c
$(OBJ)/libc-top-half/musl/src/network/inet_aton.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/inet_aton.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/inet_aton.o -c libc-top-half/musl/src/network/inet_aton.c
$(OBJ)/libc-top-half/musl/src/network/inet_ntop.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/inet_ntop.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/inet_ntop.o -c libc-top-half/musl/src/network/inet_ntop.c
$(OBJ)/libc-top-half/musl/src/network/inet_pton.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/inet_pton.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/inet_pton.o -c libc-top-half/musl/src/network/inet_pton.c
$(OBJ)/libc-top-half/musl/src/network/ntohl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/ntohl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/ntohl.o -c libc-top-half/musl/src/network/ntohl.c
$(OBJ)/libc-top-half/musl/src/network/ntohs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/network/ntohs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/network/ntohs.o -c libc-top-half/musl/src/network/ntohs.c
$(OBJ)/libc-top-half/musl/src/prng/__rand48_step.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/__rand48_step.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/__rand48_step.o -c libc-top-half/musl/src/prng/__rand48_step.c
$(OBJ)/libc-top-half/musl/src/prng/__seed48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/__seed48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/__seed48.o -c libc-top-half/musl/src/prng/__seed48.c
$(OBJ)/libc-top-half/musl/src/prng/drand48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/drand48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/drand48.o -c libc-top-half/musl/src/prng/drand48.c
$(OBJ)/libc-top-half/musl/src/prng/lcong48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/lcong48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/lcong48.o -c libc-top-half/musl/src/prng/lcong48.c
$(OBJ)/libc-top-half/musl/src/prng/lrand48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/lrand48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/lrand48.o -c libc-top-half/musl/src/prng/lrand48.c
$(OBJ)/libc-top-half/musl/src/prng/mrand48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/mrand48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/mrand48.o -c libc-top-half/musl/src/prng/mrand48.c
$(OBJ)/libc-top-half/musl/src/prng/rand.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/rand.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/rand.o -c libc-top-half/musl/src/prng/rand.c
$(OBJ)/libc-top-half/musl/src/prng/rand_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/rand_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/rand_r.o -c libc-top-half/musl/src/prng/rand_r.c
$(OBJ)/libc-top-half/musl/src/prng/random.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/random.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/random.o -c libc-top-half/musl/src/prng/random.c
$(OBJ)/libc-top-half/musl/src/prng/seed48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/seed48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/seed48.o -c libc-top-half/musl/src/prng/seed48.c
$(OBJ)/libc-top-half/musl/src/prng/srand48.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/prng/srand48.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/prng/srand48.o -c libc-top-half/musl/src/prng/srand48.c
$(OBJ)/libc-top-half/musl/src/regex/fnmatch.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/fnmatch.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/fnmatch.o -c libc-top-half/musl/src/regex/fnmatch.c
$(OBJ)/libc-top-half/musl/src/regex/glob.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/glob.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/glob.o -c libc-top-half/musl/src/regex/glob.c
$(OBJ)/libc-top-half/musl/src/regex/regcomp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/regcomp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/regcomp.o -c libc-top-half/musl/src/regex/regcomp.c
$(OBJ)/libc-top-half/musl/src/regex/regerror.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/regerror.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/regerror.o -c libc-top-half/musl/src/regex/regerror.c
$(OBJ)/libc-top-half/musl/src/regex/regexec.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/regexec.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/regexec.o -c libc-top-half/musl/src/regex/regexec.c
$(OBJ)/libc-top-half/musl/src/regex/tre-mem.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/regex/tre-mem.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/regex/tre-mem.o -c libc-top-half/musl/src/regex/tre-mem.c
$(OBJ)/libc-top-half/musl/src/search/hsearch.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/hsearch.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/hsearch.o -c libc-top-half/musl/src/search/hsearch.c
$(OBJ)/libc-top-half/musl/src/search/insque.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/insque.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/insque.o -c libc-top-half/musl/src/search/insque.c
$(OBJ)/libc-top-half/musl/src/search/lsearch.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/lsearch.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/lsearch.o -c libc-top-half/musl/src/search/lsearch.c
$(OBJ)/libc-top-half/musl/src/search/tdelete.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/tdelete.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/tdelete.o -c libc-top-half/musl/src/search/tdelete.c
$(OBJ)/libc-top-half/musl/src/search/tdestroy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/tdestroy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/tdestroy.o -c libc-top-half/musl/src/search/tdestroy.c
$(OBJ)/libc-top-half/musl/src/search/tfind.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/tfind.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/tfind.o -c libc-top-half/musl/src/search/tfind.c
$(OBJ)/libc-top-half/musl/src/search/tsearch.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/tsearch.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/tsearch.o -c libc-top-half/musl/src/search/tsearch.c
$(OBJ)/libc-top-half/musl/src/search/twalk.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/search/twalk.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/search/twalk.o -c libc-top-half/musl/src/search/twalk.c
$(OBJ)/libc-top-half/musl/src/stat/futimesat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stat/futimesat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stat/futimesat.o -c libc-top-half/musl/src/stat/futimesat.c
$(OBJ)/libc-top-half/musl/src/stdio/__fclose_ca.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__fclose_ca.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__fclose_ca.o -c libc-top-half/musl/src/stdio/__fclose_ca.c
$(OBJ)/libc-top-half/musl/src/stdio/__fdopen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__fdopen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__fdopen.o -c libc-top-half/musl/src/stdio/__fdopen.c
$(OBJ)/libc-top-half/musl/src/stdio/__fmodeflags.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__fmodeflags.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__fmodeflags.o -c libc-top-half/musl/src/stdio/__fmodeflags.c
$(OBJ)/libc-top-half/musl/src/stdio/__fopen_rb_ca.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__fopen_rb_ca.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__fopen_rb_ca.o -c libc-top-half/musl/src/stdio/__fopen_rb_ca.c
$(OBJ)/libc-top-half/musl/src/stdio/__overflow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__overflow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__overflow.o -c libc-top-half/musl/src/stdio/__overflow.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdio_close.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdio_close.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdio_close.o -c libc-top-half/musl/src/stdio/__stdio_close.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdio_exit.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdio_exit.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdio_exit.o -c libc-top-half/musl/src/stdio/__stdio_exit.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdio_read.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdio_read.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdio_read.o -c libc-top-half/musl/src/stdio/__stdio_read.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdio_seek.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdio_seek.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdio_seek.o -c libc-top-half/musl/src/stdio/__stdio_seek.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdio_write.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdio_write.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdio_write.o -c libc-top-half/musl/src/stdio/__stdio_write.c
$(OBJ)/libc-top-half/musl/src/stdio/__stdout_write.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__stdout_write.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__stdout_write.o -c libc-top-half/musl/src/stdio/__stdout_write.c
$(OBJ)/libc-top-half/musl/src/stdio/__toread.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__toread.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__toread.o -c libc-top-half/musl/src/stdio/__toread.c
$(OBJ)/libc-top-half/musl/src/stdio/__towrite.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__towrite.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__towrite.o -c libc-top-half/musl/src/stdio/__towrite.c
$(OBJ)/libc-top-half/musl/src/stdio/__uflow.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/__uflow.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/__uflow.o -c libc-top-half/musl/src/stdio/__uflow.c
$(OBJ)/libc-top-half/musl/src/stdio/asprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/asprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/asprintf.o -c libc-top-half/musl/src/stdio/asprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/clearerr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/clearerr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/clearerr.o -c libc-top-half/musl/src/stdio/clearerr.c
$(OBJ)/libc-top-half/musl/src/stdio/dprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/dprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/dprintf.o -c libc-top-half/musl/src/stdio/dprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/ext.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ext.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ext.o -c libc-top-half/musl/src/stdio/ext.c
$(OBJ)/libc-top-half/musl/src/stdio/ext2.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ext2.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ext2.o -c libc-top-half/musl/src/stdio/ext2.c
$(OBJ)/libc-top-half/musl/src/stdio/fclose.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fclose.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fclose.o -c libc-top-half/musl/src/stdio/fclose.c
$(OBJ)/libc-top-half/musl/src/stdio/feof.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/feof.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/feof.o -c libc-top-half/musl/src/stdio/feof.c
$(OBJ)/libc-top-half/musl/src/stdio/ferror.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ferror.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ferror.o -c libc-top-half/musl/src/stdio/ferror.c
$(OBJ)/libc-top-half/musl/src/stdio/fflush.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fflush.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fflush.o -c libc-top-half/musl/src/stdio/fflush.c
$(OBJ)/libc-top-half/musl/src/stdio/fgetc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgetc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgetc.o -c libc-top-half/musl/src/stdio/fgetc.c
$(OBJ)/libc-top-half/musl/src/stdio/fgetln.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgetln.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgetln.o -c libc-top-half/musl/src/stdio/fgetln.c
$(OBJ)/libc-top-half/musl/src/stdio/fgetpos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgetpos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgetpos.o -c libc-top-half/musl/src/stdio/fgetpos.c
$(OBJ)/libc-top-half/musl/src/stdio/fgets.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgets.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgets.o -c libc-top-half/musl/src/stdio/fgets.c
$(OBJ)/libc-top-half/musl/src/stdio/fgetwc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgetwc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgetwc.o -c libc-top-half/musl/src/stdio/fgetwc.c
$(OBJ)/libc-top-half/musl/src/stdio/fgetws.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fgetws.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fgetws.o -c libc-top-half/musl/src/stdio/fgetws.c
$(OBJ)/libc-top-half/musl/src/stdio/fileno.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fileno.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fileno.o -c libc-top-half/musl/src/stdio/fileno.c
$(OBJ)/libc-top-half/musl/src/stdio/fmemopen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fmemopen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fmemopen.o -c libc-top-half/musl/src/stdio/fmemopen.c
$(OBJ)/libc-top-half/musl/src/stdio/fopen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fopen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fopen.o -c libc-top-half/musl/src/stdio/fopen.c
$(OBJ)/libc-top-half/musl/src/stdio/fopencookie.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fopencookie.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fopencookie.o -c libc-top-half/musl/src/stdio/fopencookie.c
$(OBJ)/libc-top-half/musl/src/stdio/fprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fprintf.o -c libc-top-half/musl/src/stdio/fprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/fputc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fputc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fputc.o -c libc-top-half/musl/src/stdio/fputc.c
$(OBJ)/libc-top-half/musl/src/stdio/fputs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fputs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fputs.o -c libc-top-half/musl/src/stdio/fputs.c
$(OBJ)/libc-top-half/musl/src/stdio/fputwc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fputwc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fputwc.o -c libc-top-half/musl/src/stdio/fputwc.c
$(OBJ)/libc-top-half/musl/src/stdio/fputws.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fputws.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fputws.o -c libc-top-half/musl/src/stdio/fputws.c
$(OBJ)/libc-top-half/musl/src/stdio/fread.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fread.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fread.o -c libc-top-half/musl/src/stdio/fread.c
$(OBJ)/libc-top-half/musl/src/stdio/freopen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/freopen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/freopen.o -c libc-top-half/musl/src/stdio/freopen.c
$(OBJ)/libc-top-half/musl/src/stdio/fscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fscanf.o -c libc-top-half/musl/src/stdio/fscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/fseek.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fseek.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fseek.o -c libc-top-half/musl/src/stdio/fseek.c
$(OBJ)/libc-top-half/musl/src/stdio/fsetpos.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fsetpos.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fsetpos.o -c libc-top-half/musl/src/stdio/fsetpos.c
$(OBJ)/libc-top-half/musl/src/stdio/ftell.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ftell.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ftell.o -c libc-top-half/musl/src/stdio/ftell.c
$(OBJ)/libc-top-half/musl/src/stdio/fwide.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fwide.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fwide.o -c libc-top-half/musl/src/stdio/fwide.c
$(OBJ)/libc-top-half/musl/src/stdio/fwprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fwprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fwprintf.o -c libc-top-half/musl/src/stdio/fwprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/fwrite.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fwrite.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fwrite.o -c libc-top-half/musl/src/stdio/fwrite.c
$(OBJ)/libc-top-half/musl/src/stdio/fwscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/fwscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/fwscanf.o -c libc-top-half/musl/src/stdio/fwscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/getc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getc.o -c libc-top-half/musl/src/stdio/getc.c
$(OBJ)/libc-top-half/musl/src/stdio/getc_unlocked.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getc_unlocked.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getc_unlocked.o -c libc-top-half/musl/src/stdio/getc_unlocked.c
$(OBJ)/libc-top-half/musl/src/stdio/getchar.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getchar.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getchar.o -c libc-top-half/musl/src/stdio/getchar.c
$(OBJ)/libc-top-half/musl/src/stdio/getchar_unlocked.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getchar_unlocked.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getchar_unlocked.o -c libc-top-half/musl/src/stdio/getchar_unlocked.c
$(OBJ)/libc-top-half/musl/src/stdio/getdelim.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getdelim.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getdelim.o -c libc-top-half/musl/src/stdio/getdelim.c
$(OBJ)/libc-top-half/musl/src/stdio/getline.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getline.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getline.o -c libc-top-half/musl/src/stdio/getline.c
$(OBJ)/libc-top-half/musl/src/stdio/getw.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getw.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getw.o -c libc-top-half/musl/src/stdio/getw.c
$(OBJ)/libc-top-half/musl/src/stdio/getwc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getwc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getwc.o -c libc-top-half/musl/src/stdio/getwc.c
$(OBJ)/libc-top-half/musl/src/stdio/getwchar.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/getwchar.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/getwchar.o -c libc-top-half/musl/src/stdio/getwchar.c
$(OBJ)/libc-top-half/musl/src/stdio/ofl.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ofl.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ofl.o -c libc-top-half/musl/src/stdio/ofl.c
$(OBJ)/libc-top-half/musl/src/stdio/ofl_add.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ofl_add.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ofl_add.o -c libc-top-half/musl/src/stdio/ofl_add.c
$(OBJ)/libc-top-half/musl/src/stdio/open_memstream.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/open_memstream.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/open_memstream.o -c libc-top-half/musl/src/stdio/open_memstream.c
$(OBJ)/libc-top-half/musl/src/stdio/open_wmemstream.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/open_wmemstream.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/open_wmemstream.o -c libc-top-half/musl/src/stdio/open_wmemstream.c
$(OBJ)/libc-top-half/musl/src/stdio/perror.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/perror.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/perror.o -c libc-top-half/musl/src/stdio/perror.c
$(OBJ)/libc-top-half/musl/src/stdio/printf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/printf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/printf.o -c libc-top-half/musl/src/stdio/printf.c
$(OBJ)/libc-top-half/musl/src/stdio/putc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putc.o -c libc-top-half/musl/src/stdio/putc.c
$(OBJ)/libc-top-half/musl/src/stdio/putc_unlocked.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putc_unlocked.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putc_unlocked.o -c libc-top-half/musl/src/stdio/putc_unlocked.c
$(OBJ)/libc-top-half/musl/src/stdio/putchar.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putchar.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putchar.o -c libc-top-half/musl/src/stdio/putchar.c
$(OBJ)/libc-top-half/musl/src/stdio/putchar_unlocked.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putchar_unlocked.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putchar_unlocked.o -c libc-top-half/musl/src/stdio/putchar_unlocked.c
$(OBJ)/libc-top-half/musl/src/stdio/puts.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/puts.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/puts.o -c libc-top-half/musl/src/stdio/puts.c
$(OBJ)/libc-top-half/musl/src/stdio/putw.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putw.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putw.o -c libc-top-half/musl/src/stdio/putw.c
$(OBJ)/libc-top-half/musl/src/stdio/putwc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putwc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putwc.o -c libc-top-half/musl/src/stdio/putwc.c
$(OBJ)/libc-top-half/musl/src/stdio/putwchar.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/putwchar.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/putwchar.o -c libc-top-half/musl/src/stdio/putwchar.c
$(OBJ)/libc-top-half/musl/src/stdio/rewind.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/rewind.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/rewind.o -c libc-top-half/musl/src/stdio/rewind.c
$(OBJ)/libc-top-half/musl/src/stdio/scanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/scanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/scanf.o -c libc-top-half/musl/src/stdio/scanf.c
$(OBJ)/libc-top-half/musl/src/stdio/setbuf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/setbuf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/setbuf.o -c libc-top-half/musl/src/stdio/setbuf.c
$(OBJ)/libc-top-half/musl/src/stdio/setbuffer.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/setbuffer.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/setbuffer.o -c libc-top-half/musl/src/stdio/setbuffer.c
$(OBJ)/libc-top-half/musl/src/stdio/setlinebuf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/setlinebuf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/setlinebuf.o -c libc-top-half/musl/src/stdio/setlinebuf.c
$(OBJ)/libc-top-half/musl/src/stdio/setvbuf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/setvbuf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/setvbuf.o -c libc-top-half/musl/src/stdio/setvbuf.c
$(OBJ)/libc-top-half/musl/src/stdio/snprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/snprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/snprintf.o -c libc-top-half/musl/src/stdio/snprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/sprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/sprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/sprintf.o -c libc-top-half/musl/src/stdio/sprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/sscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/sscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/sscanf.o -c libc-top-half/musl/src/stdio/sscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/stderr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/stderr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/stderr.o -c libc-top-half/musl/src/stdio/stderr.c
$(OBJ)/libc-top-half/musl/src/stdio/stdin.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/stdin.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/stdin.o -c libc-top-half/musl/src/stdio/stdin.c
$(OBJ)/libc-top-half/musl/src/stdio/stdout.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/stdout.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/stdout.o -c libc-top-half/musl/src/stdio/stdout.c
$(OBJ)/libc-top-half/musl/src/stdio/swprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/swprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/swprintf.o -c libc-top-half/musl/src/stdio/swprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/swscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/swscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/swscanf.o -c libc-top-half/musl/src/stdio/swscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/ungetc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ungetc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ungetc.o -c libc-top-half/musl/src/stdio/ungetc.c
$(OBJ)/libc-top-half/musl/src/stdio/ungetwc.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/ungetwc.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/ungetwc.o -c libc-top-half/musl/src/stdio/ungetwc.c
$(OBJ)/libc-top-half/musl/src/stdio/vasprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vasprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vasprintf.o -c libc-top-half/musl/src/stdio/vasprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vdprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vdprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vdprintf.o -c libc-top-half/musl/src/stdio/vdprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfprintf.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.long-double.o -c libc-top-half/musl/src/stdio/vfprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfscanf.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.long-double.o -c libc-top-half/musl/src/stdio/vfscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfwprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.long-double.o -c libc-top-half/musl/src/stdio/vfwprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vfwscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vfwscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vfwscanf.o -c libc-top-half/musl/src/stdio/vfwscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vprintf.o -c libc-top-half/musl/src/stdio/vprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vscanf.o -c libc-top-half/musl/src/stdio/vscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vsnprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vsnprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vsnprintf.o -c libc-top-half/musl/src/stdio/vsnprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vsprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vsprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vsprintf.o -c libc-top-half/musl/src/stdio/vsprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vsscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vsscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vsscanf.o -c libc-top-half/musl/src/stdio/vsscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vswprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vswprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vswprintf.o -c libc-top-half/musl/src/stdio/vswprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vswscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vswscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vswscanf.o -c libc-top-half/musl/src/stdio/vswscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/vwprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vwprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vwprintf.o -c libc-top-half/musl/src/stdio/vwprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/vwscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/vwscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/vwscanf.o -c libc-top-half/musl/src/stdio/vwscanf.c
$(OBJ)/libc-top-half/musl/src/stdio/wprintf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/wprintf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/wprintf.o -c libc-top-half/musl/src/stdio/wprintf.c
$(OBJ)/libc-top-half/musl/src/stdio/wscanf.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdio/wscanf.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdio/wscanf.o -c libc-top-half/musl/src/stdio/wscanf.c
$(OBJ)/libc-top-half/musl/src/stdlib/abs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/abs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/abs.o -c libc-top-half/musl/src/stdlib/abs.c
$(OBJ)/libc-top-half/musl/src/stdlib/atof.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/atof.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/atof.o -c libc-top-half/musl/src/stdlib/atof.c
$(OBJ)/libc-top-half/musl/src/stdlib/atoi.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/atoi.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/atoi.o -c libc-top-half/musl/src/stdlib/atoi.c
$(OBJ)/libc-top-half/musl/src/stdlib/atol.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/atol.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/atol.o -c libc-top-half/musl/src/stdlib/atol.c
$(OBJ)/libc-top-half/musl/src/stdlib/atoll.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/atoll.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/atoll.o -c libc-top-half/musl/src/stdlib/atoll.c
$(OBJ)/libc-top-half/musl/src/stdlib/bsearch.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/bsearch.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/bsearch.o -c libc-top-half/musl/src/stdlib/bsearch.c
$(OBJ)/libc-top-half/musl/src/stdlib/div.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/div.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/div.o -c libc-top-half/musl/src/stdlib/div.c
$(OBJ)/libc-top-half/musl/src/stdlib/ecvt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/ecvt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/ecvt.o -c libc-top-half/musl/src/stdlib/ecvt.c
$(OBJ)/libc-top-half/musl/src/stdlib/fcvt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/fcvt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/fcvt.o -c libc-top-half/musl/src/stdlib/fcvt.c
$(OBJ)/libc-top-half/musl/src/stdlib/gcvt.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/gcvt.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/gcvt.o -c libc-top-half/musl/src/stdlib/gcvt.c
$(OBJ)/libc-top-half/musl/src/stdlib/imaxabs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/imaxabs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/imaxabs.o -c libc-top-half/musl/src/stdlib/imaxabs.c
$(OBJ)/libc-top-half/musl/src/stdlib/imaxdiv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/imaxdiv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/imaxdiv.o -c libc-top-half/musl/src/stdlib/imaxdiv.c
$(OBJ)/libc-top-half/musl/src/stdlib/labs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/labs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/labs.o -c libc-top-half/musl/src/stdlib/labs.c
$(OBJ)/libc-top-half/musl/src/stdlib/ldiv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/ldiv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/ldiv.o -c libc-top-half/musl/src/stdlib/ldiv.c
$(OBJ)/libc-top-half/musl/src/stdlib/llabs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/llabs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/llabs.o -c libc-top-half/musl/src/stdlib/llabs.c
$(OBJ)/libc-top-half/musl/src/stdlib/lldiv.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/lldiv.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/lldiv.o -c libc-top-half/musl/src/stdlib/lldiv.c
$(OBJ)/libc-top-half/musl/src/stdlib/qsort.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/qsort.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/qsort.o -c libc-top-half/musl/src/stdlib/qsort.c
$(OBJ)/libc-top-half/musl/src/stdlib/qsort_nr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/qsort_nr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/qsort_nr.o -c libc-top-half/musl/src/stdlib/qsort_nr.c
$(OBJ)/libc-top-half/musl/src/stdlib/strtod.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/strtod.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/strtod.long-double.o -c libc-top-half/musl/src/stdlib/strtod.c
$(OBJ)/libc-top-half/musl/src/stdlib/strtol.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/strtol.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/strtol.o -c libc-top-half/musl/src/stdlib/strtol.c
$(OBJ)/libc-top-half/musl/src/stdlib/wcstod.long-double.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/wcstod.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.long-double.o -c libc-top-half/musl/src/stdlib/wcstod.c
$(OBJ)/libc-top-half/musl/src/stdlib/wcstol.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/stdlib/wcstol.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/stdlib/wcstol.o -c libc-top-half/musl/src/stdlib/wcstol.c
$(OBJ)/libc-top-half/musl/src/string/bcmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/bcmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/bcmp.o -c libc-top-half/musl/src/string/bcmp.c
$(OBJ)/libc-top-half/musl/src/string/bcopy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/bcopy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/bcopy.o -c libc-top-half/musl/src/string/bcopy.c
$(OBJ)/libc-top-half/musl/src/string/bzero.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/bzero.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/bzero.o -c libc-top-half/musl/src/string/bzero.c
$(OBJ)/libc-top-half/musl/src/string/explicit_bzero.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/explicit_bzero.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/explicit_bzero.o -c libc-top-half/musl/src/string/explicit_bzero.c
$(OBJ)/libc-top-half/musl/src/string/index.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/index.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/index.o -c libc-top-half/musl/src/string/index.c
$(OBJ)/libc-top-half/musl/src/string/memccpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memccpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memccpy.o -c libc-top-half/musl/src/string/memccpy.c
$(OBJ)/libc-top-half/musl/src/string/memchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memchr.o -c libc-top-half/musl/src/string/memchr.c
$(OBJ)/libc-top-half/musl/src/string/memcmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memcmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memcmp.o -c libc-top-half/musl/src/string/memcmp.c
$(OBJ)/libc-top-half/musl/src/string/memmem.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memmem.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memmem.o -c libc-top-half/musl/src/string/memmem.c
$(OBJ)/libc-top-half/musl/src/string/mempcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/mempcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/mempcpy.o -c libc-top-half/musl/src/string/mempcpy.c
$(OBJ)/libc-top-half/musl/src/string/memrchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memrchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memrchr.o -c libc-top-half/musl/src/string/memrchr.c
$(OBJ)/libc-top-half/musl/src/string/rindex.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/rindex.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/rindex.o -c libc-top-half/musl/src/string/rindex.c
$(OBJ)/libc-top-half/musl/src/string/stpcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/stpcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/stpcpy.o -c libc-top-half/musl/src/string/stpcpy.c
$(OBJ)/libc-top-half/musl/src/string/stpncpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/stpncpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/stpncpy.o -c libc-top-half/musl/src/string/stpncpy.c
$(OBJ)/libc-top-half/musl/src/string/strcasecmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcasecmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcasecmp.o -c libc-top-half/musl/src/string/strcasecmp.c
$(OBJ)/libc-top-half/musl/src/string/strcasestr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcasestr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcasestr.o -c libc-top-half/musl/src/string/strcasestr.c
$(OBJ)/libc-top-half/musl/src/string/strcat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcat.o -c libc-top-half/musl/src/string/strcat.c
$(OBJ)/libc-top-half/musl/src/string/strchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strchr.o -c libc-top-half/musl/src/string/strchr.c
$(OBJ)/libc-top-half/musl/src/string/strchrnul.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strchrnul.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strchrnul.o -c libc-top-half/musl/src/string/strchrnul.c
$(OBJ)/libc-top-half/musl/src/string/strcmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcmp.o -c libc-top-half/musl/src/string/strcmp.c
$(OBJ)/libc-top-half/musl/src/string/strcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcpy.o -c libc-top-half/musl/src/string/strcpy.c
$(OBJ)/libc-top-half/musl/src/string/strcspn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strcspn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strcspn.o -c libc-top-half/musl/src/string/strcspn.c
$(OBJ)/libc-top-half/musl/src/string/strdup.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strdup.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strdup.o -c libc-top-half/musl/src/string/strdup.c
$(OBJ)/libc-top-half/musl/src/string/strerror_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strerror_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strerror_r.o -c libc-top-half/musl/src/string/strerror_r.c
$(OBJ)/libc-top-half/musl/src/string/strlcat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strlcat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strlcat.o -c libc-top-half/musl/src/string/strlcat.c
$(OBJ)/libc-top-half/musl/src/string/strlcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strlcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strlcpy.o -c libc-top-half/musl/src/string/strlcpy.c
$(OBJ)/libc-top-half/musl/src/string/strlen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strlen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strlen.o -c libc-top-half/musl/src/string/strlen.c
$(OBJ)/libc-top-half/musl/src/string/strncasecmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strncasecmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strncasecmp.o -c libc-top-half/musl/src/string/strncasecmp.c
$(OBJ)/libc-top-half/musl/src/string/strncat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strncat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strncat.o -c libc-top-half/musl/src/string/strncat.c
$(OBJ)/libc-top-half/musl/src/string/strncmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strncmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strncmp.o -c libc-top-half/musl/src/string/strncmp.c
$(OBJ)/libc-top-half/musl/src/string/strncpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strncpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strncpy.o -c libc-top-half/musl/src/string/strncpy.c
$(OBJ)/libc-top-half/musl/src/string/strndup.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strndup.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strndup.o -c libc-top-half/musl/src/string/strndup.c
$(OBJ)/libc-top-half/musl/src/string/strnlen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strnlen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strnlen.o -c libc-top-half/musl/src/string/strnlen.c
$(OBJ)/libc-top-half/musl/src/string/strpbrk.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strpbrk.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strpbrk.o -c libc-top-half/musl/src/string/strpbrk.c
$(OBJ)/libc-top-half/musl/src/string/strrchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strrchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strrchr.o -c libc-top-half/musl/src/string/strrchr.c
$(OBJ)/libc-top-half/musl/src/string/strsep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strsep.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strsep.o -c libc-top-half/musl/src/string/strsep.c
$(OBJ)/libc-top-half/musl/src/string/strspn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strspn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strspn.o -c libc-top-half/musl/src/string/strspn.c
$(OBJ)/libc-top-half/musl/src/string/strstr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strstr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strstr.o -c libc-top-half/musl/src/string/strstr.c
$(OBJ)/libc-top-half/musl/src/string/strtok.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strtok.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strtok.o -c libc-top-half/musl/src/string/strtok.c
$(OBJ)/libc-top-half/musl/src/string/strtok_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strtok_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strtok_r.o -c libc-top-half/musl/src/string/strtok_r.c
$(OBJ)/libc-top-half/musl/src/string/strverscmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/strverscmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/strverscmp.o -c libc-top-half/musl/src/string/strverscmp.c
$(OBJ)/libc-top-half/musl/src/string/swab.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/swab.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/swab.o -c libc-top-half/musl/src/string/swab.c
$(OBJ)/libc-top-half/musl/src/string/wcpcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcpcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcpcpy.o -c libc-top-half/musl/src/string/wcpcpy.c
$(OBJ)/libc-top-half/musl/src/string/wcpncpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcpncpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcpncpy.o -c libc-top-half/musl/src/string/wcpncpy.c
$(OBJ)/libc-top-half/musl/src/string/wcscasecmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscasecmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscasecmp.o -c libc-top-half/musl/src/string/wcscasecmp.c
$(OBJ)/libc-top-half/musl/src/string/wcscasecmp_l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscasecmp_l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscasecmp_l.o -c libc-top-half/musl/src/string/wcscasecmp_l.c
$(OBJ)/libc-top-half/musl/src/string/wcscat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscat.o -c libc-top-half/musl/src/string/wcscat.c
$(OBJ)/libc-top-half/musl/src/string/wcschr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcschr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcschr.o -c libc-top-half/musl/src/string/wcschr.c
$(OBJ)/libc-top-half/musl/src/string/wcscmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscmp.o -c libc-top-half/musl/src/string/wcscmp.c
$(OBJ)/libc-top-half/musl/src/string/wcscpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscpy.o -c libc-top-half/musl/src/string/wcscpy.c
$(OBJ)/libc-top-half/musl/src/string/wcscspn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcscspn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcscspn.o -c libc-top-half/musl/src/string/wcscspn.c
$(OBJ)/libc-top-half/musl/src/string/wcsdup.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsdup.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsdup.o -c libc-top-half/musl/src/string/wcsdup.c
$(OBJ)/libc-top-half/musl/src/string/wcslen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcslen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcslen.o -c libc-top-half/musl/src/string/wcslen.c
$(OBJ)/libc-top-half/musl/src/string/wcsncasecmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsncasecmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsncasecmp.o -c libc-top-half/musl/src/string/wcsncasecmp.c
$(OBJ)/libc-top-half/musl/src/string/wcsncasecmp_l.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsncasecmp_l.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsncasecmp_l.o -c libc-top-half/musl/src/string/wcsncasecmp_l.c
$(OBJ)/libc-top-half/musl/src/string/wcsncat.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsncat.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsncat.o -c libc-top-half/musl/src/string/wcsncat.c
$(OBJ)/libc-top-half/musl/src/string/wcsncmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsncmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsncmp.o -c libc-top-half/musl/src/string/wcsncmp.c
$(OBJ)/libc-top-half/musl/src/string/wcsncpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsncpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsncpy.o -c libc-top-half/musl/src/string/wcsncpy.c
$(OBJ)/libc-top-half/musl/src/string/wcsnlen.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsnlen.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsnlen.o -c libc-top-half/musl/src/string/wcsnlen.c
$(OBJ)/libc-top-half/musl/src/string/wcspbrk.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcspbrk.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcspbrk.o -c libc-top-half/musl/src/string/wcspbrk.c
$(OBJ)/libc-top-half/musl/src/string/wcsrchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsrchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsrchr.o -c libc-top-half/musl/src/string/wcsrchr.c
$(OBJ)/libc-top-half/musl/src/string/wcsspn.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsspn.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsspn.o -c libc-top-half/musl/src/string/wcsspn.c
$(OBJ)/libc-top-half/musl/src/string/wcsstr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcsstr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcsstr.o -c libc-top-half/musl/src/string/wcsstr.c
$(OBJ)/libc-top-half/musl/src/string/wcstok.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcstok.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcstok.o -c libc-top-half/musl/src/string/wcstok.c
$(OBJ)/libc-top-half/musl/src/string/wcswcs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wcswcs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wcswcs.o -c libc-top-half/musl/src/string/wcswcs.c
$(OBJ)/libc-top-half/musl/src/string/wmemchr.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wmemchr.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wmemchr.o -c libc-top-half/musl/src/string/wmemchr.c
$(OBJ)/libc-top-half/musl/src/string/wmemcmp.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wmemcmp.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wmemcmp.o -c libc-top-half/musl/src/string/wmemcmp.c
$(OBJ)/libc-top-half/musl/src/string/wmemcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wmemcpy.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wmemcpy.o -c libc-top-half/musl/src/string/wmemcpy.c
$(OBJ)/libc-top-half/musl/src/string/wmemmove.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wmemmove.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wmemmove.o -c libc-top-half/musl/src/string/wmemmove.c
$(OBJ)/libc-top-half/musl/src/string/wmemset.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/wmemset.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/wmemset.o -c libc-top-half/musl/src/string/wmemset.c
$(OBJ)/libc-top-half/musl/src/thread/thrd_sleep.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/thread/thrd_sleep.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/thread/thrd_sleep.o -c libc-top-half/musl/src/thread/thrd_sleep.c
$(OBJ)/libc-top-half/musl/src/time/__month_to_secs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/__month_to_secs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/__month_to_secs.o -c libc-top-half/musl/src/time/__month_to_secs.c
$(OBJ)/libc-top-half/musl/src/time/__secs_to_tm.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/__secs_to_tm.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/__secs_to_tm.o -c libc-top-half/musl/src/time/__secs_to_tm.c
$(OBJ)/libc-top-half/musl/src/time/__tm_to_secs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/__tm_to_secs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/__tm_to_secs.o -c libc-top-half/musl/src/time/__tm_to_secs.c
$(OBJ)/libc-top-half/musl/src/time/__tz.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/__tz.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/__tz.o -c libc-top-half/musl/src/time/__tz.c
$(OBJ)/libc-top-half/musl/src/time/__year_to_secs.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/__year_to_secs.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/__year_to_secs.o -c libc-top-half/musl/src/time/__year_to_secs.c
$(OBJ)/libc-top-half/musl/src/time/asctime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/asctime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/asctime.o -c libc-top-half/musl/src/time/asctime.c
$(OBJ)/libc-top-half/musl/src/time/asctime_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/asctime_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/asctime_r.o -c libc-top-half/musl/src/time/asctime_r.c
$(OBJ)/libc-top-half/musl/src/time/ctime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/ctime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/ctime.o -c libc-top-half/musl/src/time/ctime.c
$(OBJ)/libc-top-half/musl/src/time/ctime_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/ctime_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/ctime_r.o -c libc-top-half/musl/src/time/ctime_r.c
$(OBJ)/libc-top-half/musl/src/time/difftime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/difftime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/difftime.o -c libc-top-half/musl/src/time/difftime.c
$(OBJ)/libc-top-half/musl/src/time/ftime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/ftime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/ftime.o -c libc-top-half/musl/src/time/ftime.c
$(OBJ)/libc-top-half/musl/src/time/getdate.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/getdate.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/getdate.o -c libc-top-half/musl/src/time/getdate.c
$(OBJ)/libc-top-half/musl/src/time/gmtime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/gmtime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/gmtime.o -c libc-top-half/musl/src/time/gmtime.c
$(OBJ)/libc-top-half/musl/src/time/gmtime_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/gmtime_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/gmtime_r.o -c libc-top-half/musl/src/time/gmtime_r.c
$(OBJ)/libc-top-half/musl/src/time/localtime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/localtime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/localtime.o -c libc-top-half/musl/src/time/localtime.c
$(OBJ)/libc-top-half/musl/src/time/localtime_r.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/localtime_r.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/localtime_r.o -c libc-top-half/musl/src/time/localtime_r.c
$(OBJ)/libc-top-half/musl/src/time/mktime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/mktime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/mktime.o -c libc-top-half/musl/src/time/mktime.c
$(OBJ)/libc-top-half/musl/src/time/strftime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/strftime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/strftime.o -c libc-top-half/musl/src/time/strftime.c
$(OBJ)/libc-top-half/musl/src/time/strptime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/strptime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/strptime.o -c libc-top-half/musl/src/time/strptime.c
$(OBJ)/libc-top-half/musl/src/time/timegm.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/timegm.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/timegm.o -c libc-top-half/musl/src/time/timegm.c
$(OBJ)/libc-top-half/musl/src/time/timespec_get.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/timespec_get.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/timespec_get.o -c libc-top-half/musl/src/time/timespec_get.c
$(OBJ)/libc-top-half/musl/src/time/wcsftime.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/time/wcsftime.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/time/wcsftime.o -c libc-top-half/musl/src/time/wcsftime.c
$(OBJ)/libc-top-half/musl/src/unistd/posix_close.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/unistd/posix_close.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/unistd/posix_close.o -c libc-top-half/musl/src/unistd/posix_close.c
$(OBJ)/libc-top-half/sources/arc4random.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/sources/arc4random.c"
	$(Q)$(CC)  -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/sources/arc4random.o -c libc-top-half/sources/arc4random.c
$(OBJ)/libc-bottom-half/getpid/getpid.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/getpid/getpid.c"
	$(Q)$(CC)  -o $(OBJ)/libc-bottom-half/getpid/getpid.o -c libc-bottom-half/getpid/getpid.c
$(OBJ)/libc-bottom-half/mman/mman.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/mman/mman.c"
	$(Q)$(CC)  -o $(OBJ)/libc-bottom-half/mman/mman.o -c libc-bottom-half/mman/mman.c
$(OBJ)/libc-bottom-half/signal/signal.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-bottom-half/signal/signal.c"
	$(Q)$(CC)  -o $(OBJ)/libc-bottom-half/signal/signal.o -c libc-bottom-half/signal/signal.c
$(OBJ)/libc-top-half/musl/src/string/memcpy.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memcpy.c"
	$(Q)$(CC)  -mbulk-memory -DBULK_MEMORY_THRESHOLD=32 -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memcpy.o -c libc-top-half/musl/src/string/memcpy.c
$(OBJ)/libc-top-half/musl/src/string/memmove.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memmove.c"
	$(Q)$(CC)  -mbulk-memory -DBULK_MEMORY_THRESHOLD=32 -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memmove.o -c libc-top-half/musl/src/string/memmove.c
$(OBJ)/libc-top-half/musl/src/string/memset.o: | $(OBJ)/mkdirs.ok
	@echo "CC libc-top-half/musl/src/string/memset.c"
	$(Q)$(CC)  -mbulk-memory -DBULK_MEMORY_THRESHOLD=32 -Ilibc-top-half/musl/src/include -Ilibc-top-half/musl/src/internal -Ilibc-top-half/musl/arch/wasm32 -Ilibc-top-half/musl/arch/generic -Ilibc-top-half/headers/private -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses -Wno-logical-op-parentheses -Wno-string-plus-int -Wno-dangling-else -Wno-unknown-pragmas -o $(OBJ)/libc-top-half/musl/src/string/memset.o -c libc-top-half/musl/src/string/memset.c

$(OUT)/lib/libc-printscan-long-double.a: \
  $(OBJ)/libc-top-half/musl/src/internal/floatscan.long-double.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.long-double.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.long-double.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.long-double.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/strtod.long-double.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.long-double.o \

$(OUT)/lib/libc-printscan-no-floating-point.a: \
  $(OBJ)/libc-top-half/musl/src/internal/floatscan.no-floating-point.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.no-floating-point.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.no-floating-point.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.no-floating-point.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/strtod.no-floating-point.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.no-floating-point.o \

$(OUT)/lib/libc.a: \
  $(OBJ)/dlmalloc/src/dlmalloc.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/closedir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/dirfd.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdclosedir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/fdopendir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/opendirat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/readdir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/rewinddir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/scandirat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/seekdir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent/telldir.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/errno/errno.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/fcntl.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/openat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fadvise.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl/posix_fallocate.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/poll/poll.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sched/sched_yield.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdio/renameat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdlib/_Exit.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/ioctl/ioctl.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/pselect.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select/select.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/getsockopt.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/recv.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/send.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket/shutdown.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/fstatat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/futimens.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/mkdirat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat/utimensat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/time/gettimeofday.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/preadv.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/pwritev.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/readv.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio/writev.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_MONOTONIC.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/CLOCK_REALTIME.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_getres.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_gettime.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/clock_nanosleep.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/nanosleep.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time/time.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/faccessat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fdatasync.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/fsync.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/ftruncate.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/linkat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/lseek.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pread.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/pwrite.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/read.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/readlinkat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/sleep.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/symlinkat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/unlinkat.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/usleep.o \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd/write.o \
  $(OBJ)/libc-bottom-half/sources/__errno_location.o \
  $(OBJ)/libc-bottom-half/sources/__main_void.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_dt.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_environ.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_fd_renumber.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_initialize_environ.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_real.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_rmdirat.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_tell.o \
  $(OBJ)/libc-bottom-half/sources/__wasilibc_unlinkat.o \
  $(OBJ)/libc-bottom-half/sources/abort.o \
  $(OBJ)/libc-bottom-half/sources/accept.o \
  $(OBJ)/libc-bottom-half/sources/at_fdcwd.o \
  $(OBJ)/libc-bottom-half/sources/chdir.o \
  $(OBJ)/libc-bottom-half/sources/complex-builtins.o \
  $(OBJ)/libc-bottom-half/sources/environ.o \
  $(OBJ)/libc-bottom-half/sources/errno.o \
  $(OBJ)/libc-bottom-half/sources/getcwd.o \
  $(OBJ)/libc-bottom-half/sources/getentropy.o \
  $(OBJ)/libc-bottom-half/sources/isatty.o \
  $(OBJ)/libc-bottom-half/sources/math/fmin-fmax.o \
  $(OBJ)/libc-bottom-half/sources/math/math-builtins.o \
  $(OBJ)/libc-bottom-half/sources/posix.o \
  $(OBJ)/libc-bottom-half/sources/preopens.o \
  $(OBJ)/libc-bottom-half/sources/reallocarray.o \
  $(OBJ)/libc-bottom-half/sources/sbrk.o \
  $(OBJ)/libc-bottom-half/sources/truncate.o \
  $(OBJ)/libc-top-half/musl/src/complex/__cexp.o \
  $(OBJ)/libc-top-half/musl/src/complex/__cexpf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cabs.o \
  $(OBJ)/libc-top-half/musl/src/complex/cabsf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cabsl.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacos.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacosf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacosh.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacoshf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacoshl.o \
  $(OBJ)/libc-top-half/musl/src/complex/cacosl.o \
  $(OBJ)/libc-top-half/musl/src/complex/carg.o \
  $(OBJ)/libc-top-half/musl/src/complex/cargf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cargl.o \
  $(OBJ)/libc-top-half/musl/src/complex/casin.o \
  $(OBJ)/libc-top-half/musl/src/complex/casinf.o \
  $(OBJ)/libc-top-half/musl/src/complex/casinh.o \
  $(OBJ)/libc-top-half/musl/src/complex/casinhf.o \
  $(OBJ)/libc-top-half/musl/src/complex/casinhl.o \
  $(OBJ)/libc-top-half/musl/src/complex/casinl.o \
  $(OBJ)/libc-top-half/musl/src/complex/catan.o \
  $(OBJ)/libc-top-half/musl/src/complex/catanf.o \
  $(OBJ)/libc-top-half/musl/src/complex/catanh.o \
  $(OBJ)/libc-top-half/musl/src/complex/catanhf.o \
  $(OBJ)/libc-top-half/musl/src/complex/catanhl.o \
  $(OBJ)/libc-top-half/musl/src/complex/catanl.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccos.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccosf.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccosh.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccoshf.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccoshl.o \
  $(OBJ)/libc-top-half/musl/src/complex/ccosl.o \
  $(OBJ)/libc-top-half/musl/src/complex/cexp.o \
  $(OBJ)/libc-top-half/musl/src/complex/cexpf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cexpl.o \
  $(OBJ)/libc-top-half/musl/src/complex/clog.o \
  $(OBJ)/libc-top-half/musl/src/complex/clogf.o \
  $(OBJ)/libc-top-half/musl/src/complex/clogl.o \
  $(OBJ)/libc-top-half/musl/src/complex/conj.o \
  $(OBJ)/libc-top-half/musl/src/complex/conjf.o \
  $(OBJ)/libc-top-half/musl/src/complex/conjl.o \
  $(OBJ)/libc-top-half/musl/src/complex/cpow.o \
  $(OBJ)/libc-top-half/musl/src/complex/cpowf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cpowl.o \
  $(OBJ)/libc-top-half/musl/src/complex/cproj.o \
  $(OBJ)/libc-top-half/musl/src/complex/cprojf.o \
  $(OBJ)/libc-top-half/musl/src/complex/cprojl.o \
  $(OBJ)/libc-top-half/musl/src/complex/csin.o \
  $(OBJ)/libc-top-half/musl/src/complex/csinf.o \
  $(OBJ)/libc-top-half/musl/src/complex/csinh.o \
  $(OBJ)/libc-top-half/musl/src/complex/csinhf.o \
  $(OBJ)/libc-top-half/musl/src/complex/csinhl.o \
  $(OBJ)/libc-top-half/musl/src/complex/csinl.o \
  $(OBJ)/libc-top-half/musl/src/complex/csqrt.o \
  $(OBJ)/libc-top-half/musl/src/complex/csqrtf.o \
  $(OBJ)/libc-top-half/musl/src/complex/csqrtl.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctan.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctanf.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctanh.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctanhf.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctanhl.o \
  $(OBJ)/libc-top-half/musl/src/complex/ctanl.o \
  $(OBJ)/libc-top-half/musl/src/conf/confstr.o \
  $(OBJ)/libc-top-half/musl/src/conf/fpathconf.o \
  $(OBJ)/libc-top-half/musl/src/conf/legacy.o \
  $(OBJ)/libc-top-half/musl/src/conf/pathconf.o \
  $(OBJ)/libc-top-half/musl/src/conf/sysconf.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_blowfish.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_des.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_md5.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_r.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_sha256.o \
  $(OBJ)/libc-top-half/musl/src/crypt/crypt_sha512.o \
  $(OBJ)/libc-top-half/musl/src/crypt/encrypt.o \
  $(OBJ)/libc-top-half/musl/src/ctype/__ctype_b_loc.o \
  $(OBJ)/libc-top-half/musl/src/ctype/__ctype_get_mb_cur_max.o \
  $(OBJ)/libc-top-half/musl/src/ctype/__ctype_tolower_loc.o \
  $(OBJ)/libc-top-half/musl/src/ctype/__ctype_toupper_loc.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isalnum.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isalpha.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isascii.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isblank.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iscntrl.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isdigit.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isgraph.o \
  $(OBJ)/libc-top-half/musl/src/ctype/islower.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isprint.o \
  $(OBJ)/libc-top-half/musl/src/ctype/ispunct.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isspace.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isupper.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswalnum.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswalpha.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswblank.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswcntrl.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswctype.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswdigit.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswgraph.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswlower.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswprint.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswpunct.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswspace.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswupper.o \
  $(OBJ)/libc-top-half/musl/src/ctype/iswxdigit.o \
  $(OBJ)/libc-top-half/musl/src/ctype/isxdigit.o \
  $(OBJ)/libc-top-half/musl/src/ctype/toascii.o \
  $(OBJ)/libc-top-half/musl/src/ctype/tolower.o \
  $(OBJ)/libc-top-half/musl/src/ctype/toupper.o \
  $(OBJ)/libc-top-half/musl/src/ctype/towctrans.o \
  $(OBJ)/libc-top-half/musl/src/ctype/wcswidth.o \
  $(OBJ)/libc-top-half/musl/src/ctype/wctrans.o \
  $(OBJ)/libc-top-half/musl/src/ctype/wcwidth.o \
  $(OBJ)/libc-top-half/musl/src/dirent/alphasort.o \
  $(OBJ)/libc-top-half/musl/src/dirent/versionsort.o \
  $(OBJ)/libc-top-half/musl/src/env/__stack_chk_fail.o \
  $(OBJ)/libc-top-half/musl/src/env/clearenv.o \
  $(OBJ)/libc-top-half/musl/src/env/getenv.o \
  $(OBJ)/libc-top-half/musl/src/env/putenv.o \
  $(OBJ)/libc-top-half/musl/src/env/setenv.o \
  $(OBJ)/libc-top-half/musl/src/env/unsetenv.o \
  $(OBJ)/libc-top-half/musl/src/errno/strerror.o \
  $(OBJ)/libc-top-half/musl/src/exit/assert.o \
  $(OBJ)/libc-top-half/musl/src/exit/at_quick_exit.o \
  $(OBJ)/libc-top-half/musl/src/exit/atexit.o \
  $(OBJ)/libc-top-half/musl/src/exit/exit.o \
  $(OBJ)/libc-top-half/musl/src/exit/quick_exit.o \
  $(OBJ)/libc-top-half/musl/src/fcntl/creat.o \
  $(OBJ)/libc-top-half/musl/src/fenv/fegetexceptflag.o \
  $(OBJ)/libc-top-half/musl/src/fenv/feholdexcept.o \
  $(OBJ)/libc-top-half/musl/src/fenv/fenv.o \
  $(OBJ)/libc-top-half/musl/src/fenv/fesetexceptflag.o \
  $(OBJ)/libc-top-half/musl/src/fenv/fesetround.o \
  $(OBJ)/libc-top-half/musl/src/fenv/feupdateenv.o \
  $(OBJ)/libc-top-half/musl/src/internal/defsysinfo.o \
  $(OBJ)/libc-top-half/musl/src/internal/floatscan.o \
  $(OBJ)/libc-top-half/musl/src/internal/intscan.o \
  $(OBJ)/libc-top-half/musl/src/internal/libc.o \
  $(OBJ)/libc-top-half/musl/src/internal/shgetc.o \
  $(OBJ)/libc-top-half/musl/src/legacy/getpagesize.o \
  $(OBJ)/libc-top-half/musl/src/locale/__lctrans.o \
  $(OBJ)/libc-top-half/musl/src/locale/__mo_lookup.o \
  $(OBJ)/libc-top-half/musl/src/locale/c_locale.o \
  $(OBJ)/libc-top-half/musl/src/locale/catclose.o \
  $(OBJ)/libc-top-half/musl/src/locale/catgets.o \
  $(OBJ)/libc-top-half/musl/src/locale/catopen.o \
  $(OBJ)/libc-top-half/musl/src/locale/duplocale.o \
  $(OBJ)/libc-top-half/musl/src/locale/freelocale.o \
  $(OBJ)/libc-top-half/musl/src/locale/iconv.o \
  $(OBJ)/libc-top-half/musl/src/locale/iconv_close.o \
  $(OBJ)/libc-top-half/musl/src/locale/langinfo.o \
  $(OBJ)/libc-top-half/musl/src/locale/locale_map.o \
  $(OBJ)/libc-top-half/musl/src/locale/localeconv.o \
  $(OBJ)/libc-top-half/musl/src/locale/newlocale.o \
  $(OBJ)/libc-top-half/musl/src/locale/pleval.o \
  $(OBJ)/libc-top-half/musl/src/locale/setlocale.o \
  $(OBJ)/libc-top-half/musl/src/locale/strcoll.o \
  $(OBJ)/libc-top-half/musl/src/locale/strfmon.o \
  $(OBJ)/libc-top-half/musl/src/locale/strtod_l.o \
  $(OBJ)/libc-top-half/musl/src/locale/strxfrm.o \
  $(OBJ)/libc-top-half/musl/src/locale/uselocale.o \
  $(OBJ)/libc-top-half/musl/src/locale/wcscoll.o \
  $(OBJ)/libc-top-half/musl/src/locale/wcsxfrm.o \
  $(OBJ)/libc-top-half/musl/src/math/__cos.o \
  $(OBJ)/libc-top-half/musl/src/math/__cosdf.o \
  $(OBJ)/libc-top-half/musl/src/math/__cosl.o \
  $(OBJ)/libc-top-half/musl/src/math/__expo2.o \
  $(OBJ)/libc-top-half/musl/src/math/__expo2f.o \
  $(OBJ)/libc-top-half/musl/src/math/__invtrigl.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_divzero.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_divzerof.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_invalid.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_invalidf.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_invalidl.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_oflow.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_oflowf.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_uflow.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_uflowf.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_xflow.o \
  $(OBJ)/libc-top-half/musl/src/math/__math_xflowf.o \
  $(OBJ)/libc-top-half/musl/src/math/__polevll.o \
  $(OBJ)/libc-top-half/musl/src/math/__rem_pio2.o \
  $(OBJ)/libc-top-half/musl/src/math/__rem_pio2_large.o \
  $(OBJ)/libc-top-half/musl/src/math/__rem_pio2f.o \
  $(OBJ)/libc-top-half/musl/src/math/__rem_pio2l.o \
  $(OBJ)/libc-top-half/musl/src/math/__sin.o \
  $(OBJ)/libc-top-half/musl/src/math/__sindf.o \
  $(OBJ)/libc-top-half/musl/src/math/__sinl.o \
  $(OBJ)/libc-top-half/musl/src/math/__tan.o \
  $(OBJ)/libc-top-half/musl/src/math/__tandf.o \
  $(OBJ)/libc-top-half/musl/src/math/__tanl.o \
  $(OBJ)/libc-top-half/musl/src/math/acos.o \
  $(OBJ)/libc-top-half/musl/src/math/acosf.o \
  $(OBJ)/libc-top-half/musl/src/math/acosh.o \
  $(OBJ)/libc-top-half/musl/src/math/acoshf.o \
  $(OBJ)/libc-top-half/musl/src/math/acoshl.o \
  $(OBJ)/libc-top-half/musl/src/math/acosl.o \
  $(OBJ)/libc-top-half/musl/src/math/asin.o \
  $(OBJ)/libc-top-half/musl/src/math/asinf.o \
  $(OBJ)/libc-top-half/musl/src/math/asinh.o \
  $(OBJ)/libc-top-half/musl/src/math/asinhf.o \
  $(OBJ)/libc-top-half/musl/src/math/asinhl.o \
  $(OBJ)/libc-top-half/musl/src/math/asinl.o \
  $(OBJ)/libc-top-half/musl/src/math/atan.o \
  $(OBJ)/libc-top-half/musl/src/math/atan2.o \
  $(OBJ)/libc-top-half/musl/src/math/atan2f.o \
  $(OBJ)/libc-top-half/musl/src/math/atan2l.o \
  $(OBJ)/libc-top-half/musl/src/math/atanf.o \
  $(OBJ)/libc-top-half/musl/src/math/atanh.o \
  $(OBJ)/libc-top-half/musl/src/math/atanhf.o \
  $(OBJ)/libc-top-half/musl/src/math/atanhl.o \
  $(OBJ)/libc-top-half/musl/src/math/atanl.o \
  $(OBJ)/libc-top-half/musl/src/math/cbrt.o \
  $(OBJ)/libc-top-half/musl/src/math/cbrtf.o \
  $(OBJ)/libc-top-half/musl/src/math/cbrtl.o \
  $(OBJ)/libc-top-half/musl/src/math/ceill.o \
  $(OBJ)/libc-top-half/musl/src/math/copysignl.o \
  $(OBJ)/libc-top-half/musl/src/math/cos.o \
  $(OBJ)/libc-top-half/musl/src/math/cosf.o \
  $(OBJ)/libc-top-half/musl/src/math/cosh.o \
  $(OBJ)/libc-top-half/musl/src/math/coshf.o \
  $(OBJ)/libc-top-half/musl/src/math/coshl.o \
  $(OBJ)/libc-top-half/musl/src/math/cosl.o \
  $(OBJ)/libc-top-half/musl/src/math/erf.o \
  $(OBJ)/libc-top-half/musl/src/math/erff.o \
  $(OBJ)/libc-top-half/musl/src/math/erfl.o \
  $(OBJ)/libc-top-half/musl/src/math/exp.o \
  $(OBJ)/libc-top-half/musl/src/math/exp10.o \
  $(OBJ)/libc-top-half/musl/src/math/exp10f.o \
  $(OBJ)/libc-top-half/musl/src/math/exp10l.o \
  $(OBJ)/libc-top-half/musl/src/math/exp2.o \
  $(OBJ)/libc-top-half/musl/src/math/exp2f.o \
  $(OBJ)/libc-top-half/musl/src/math/exp2f_data.o \
  $(OBJ)/libc-top-half/musl/src/math/exp2l.o \
  $(OBJ)/libc-top-half/musl/src/math/exp_data.o \
  $(OBJ)/libc-top-half/musl/src/math/expf.o \
  $(OBJ)/libc-top-half/musl/src/math/expl.o \
  $(OBJ)/libc-top-half/musl/src/math/expm1.o \
  $(OBJ)/libc-top-half/musl/src/math/expm1f.o \
  $(OBJ)/libc-top-half/musl/src/math/expm1l.o \
  $(OBJ)/libc-top-half/musl/src/math/fabsl.o \
  $(OBJ)/libc-top-half/musl/src/math/fdim.o \
  $(OBJ)/libc-top-half/musl/src/math/fdimf.o \
  $(OBJ)/libc-top-half/musl/src/math/fdiml.o \
  $(OBJ)/libc-top-half/musl/src/math/finite.o \
  $(OBJ)/libc-top-half/musl/src/math/finitef.o \
  $(OBJ)/libc-top-half/musl/src/math/floorl.o \
  $(OBJ)/libc-top-half/musl/src/math/fma.o \
  $(OBJ)/libc-top-half/musl/src/math/fmaf.o \
  $(OBJ)/libc-top-half/musl/src/math/fmal.o \
  $(OBJ)/libc-top-half/musl/src/math/fmaxl.o \
  $(OBJ)/libc-top-half/musl/src/math/fminl.o \
  $(OBJ)/libc-top-half/musl/src/math/fmod.o \
  $(OBJ)/libc-top-half/musl/src/math/fmodf.o \
  $(OBJ)/libc-top-half/musl/src/math/fmodl.o \
  $(OBJ)/libc-top-half/musl/src/math/frexp.o \
  $(OBJ)/libc-top-half/musl/src/math/frexpf.o \
  $(OBJ)/libc-top-half/musl/src/math/frexpl.o \
  $(OBJ)/libc-top-half/musl/src/math/hypot.o \
  $(OBJ)/libc-top-half/musl/src/math/hypotf.o \
  $(OBJ)/libc-top-half/musl/src/math/hypotl.o \
  $(OBJ)/libc-top-half/musl/src/math/ilogb.o \
  $(OBJ)/libc-top-half/musl/src/math/ilogbf.o \
  $(OBJ)/libc-top-half/musl/src/math/ilogbl.o \
  $(OBJ)/libc-top-half/musl/src/math/j0.o \
  $(OBJ)/libc-top-half/musl/src/math/j0f.o \
  $(OBJ)/libc-top-half/musl/src/math/j1.o \
  $(OBJ)/libc-top-half/musl/src/math/j1f.o \
  $(OBJ)/libc-top-half/musl/src/math/jn.o \
  $(OBJ)/libc-top-half/musl/src/math/jnf.o \
  $(OBJ)/libc-top-half/musl/src/math/ldexp.o \
  $(OBJ)/libc-top-half/musl/src/math/ldexpf.o \
  $(OBJ)/libc-top-half/musl/src/math/ldexpl.o \
  $(OBJ)/libc-top-half/musl/src/math/lgamma.o \
  $(OBJ)/libc-top-half/musl/src/math/lgamma_r.o \
  $(OBJ)/libc-top-half/musl/src/math/lgammaf.o \
  $(OBJ)/libc-top-half/musl/src/math/lgammaf_r.o \
  $(OBJ)/libc-top-half/musl/src/math/lgammal.o \
  $(OBJ)/libc-top-half/musl/src/math/llrint.o \
  $(OBJ)/libc-top-half/musl/src/math/llrintf.o \
  $(OBJ)/libc-top-half/musl/src/math/llrintl.o \
  $(OBJ)/libc-top-half/musl/src/math/llround.o \
  $(OBJ)/libc-top-half/musl/src/math/llroundf.o \
  $(OBJ)/libc-top-half/musl/src/math/llroundl.o \
  $(OBJ)/libc-top-half/musl/src/math/log.o \
  $(OBJ)/libc-top-half/musl/src/math/log10.o \
  $(OBJ)/libc-top-half/musl/src/math/log10f.o \
  $(OBJ)/libc-top-half/musl/src/math/log10l.o \
  $(OBJ)/libc-top-half/musl/src/math/log1p.o \
  $(OBJ)/libc-top-half/musl/src/math/log1pf.o \
  $(OBJ)/libc-top-half/musl/src/math/log1pl.o \
  $(OBJ)/libc-top-half/musl/src/math/log2.o \
  $(OBJ)/libc-top-half/musl/src/math/log2_data.o \
  $(OBJ)/libc-top-half/musl/src/math/log2f.o \
  $(OBJ)/libc-top-half/musl/src/math/log2f_data.o \
  $(OBJ)/libc-top-half/musl/src/math/log2l.o \
  $(OBJ)/libc-top-half/musl/src/math/log_data.o \
  $(OBJ)/libc-top-half/musl/src/math/logb.o \
  $(OBJ)/libc-top-half/musl/src/math/logbf.o \
  $(OBJ)/libc-top-half/musl/src/math/logbl.o \
  $(OBJ)/libc-top-half/musl/src/math/logf.o \
  $(OBJ)/libc-top-half/musl/src/math/logf_data.o \
  $(OBJ)/libc-top-half/musl/src/math/logl.o \
  $(OBJ)/libc-top-half/musl/src/math/lrint.o \
  $(OBJ)/libc-top-half/musl/src/math/lrintf.o \
  $(OBJ)/libc-top-half/musl/src/math/lrintl.o \
  $(OBJ)/libc-top-half/musl/src/math/lround.o \
  $(OBJ)/libc-top-half/musl/src/math/lroundf.o \
  $(OBJ)/libc-top-half/musl/src/math/lroundl.o \
  $(OBJ)/libc-top-half/musl/src/math/modf.o \
  $(OBJ)/libc-top-half/musl/src/math/modff.o \
  $(OBJ)/libc-top-half/musl/src/math/modfl.o \
  $(OBJ)/libc-top-half/musl/src/math/nan.o \
  $(OBJ)/libc-top-half/musl/src/math/nanf.o \
  $(OBJ)/libc-top-half/musl/src/math/nanl.o \
  $(OBJ)/libc-top-half/musl/src/math/nearbyintl.o \
  $(OBJ)/libc-top-half/musl/src/math/nextafter.o \
  $(OBJ)/libc-top-half/musl/src/math/nextafterf.o \
  $(OBJ)/libc-top-half/musl/src/math/nextafterl.o \
  $(OBJ)/libc-top-half/musl/src/math/nexttoward.o \
  $(OBJ)/libc-top-half/musl/src/math/nexttowardf.o \
  $(OBJ)/libc-top-half/musl/src/math/nexttowardl.o \
  $(OBJ)/libc-top-half/musl/src/math/pow.o \
  $(OBJ)/libc-top-half/musl/src/math/pow_data.o \
  $(OBJ)/libc-top-half/musl/src/math/powf.o \
  $(OBJ)/libc-top-half/musl/src/math/powf_data.o \
  $(OBJ)/libc-top-half/musl/src/math/powl.o \
  $(OBJ)/libc-top-half/musl/src/math/remainder.o \
  $(OBJ)/libc-top-half/musl/src/math/remainderf.o \
  $(OBJ)/libc-top-half/musl/src/math/remainderl.o \
  $(OBJ)/libc-top-half/musl/src/math/remquo.o \
  $(OBJ)/libc-top-half/musl/src/math/remquof.o \
  $(OBJ)/libc-top-half/musl/src/math/remquol.o \
  $(OBJ)/libc-top-half/musl/src/math/rintl.o \
  $(OBJ)/libc-top-half/musl/src/math/round.o \
  $(OBJ)/libc-top-half/musl/src/math/roundf.o \
  $(OBJ)/libc-top-half/musl/src/math/roundl.o \
  $(OBJ)/libc-top-half/musl/src/math/scalb.o \
  $(OBJ)/libc-top-half/musl/src/math/scalbf.o \
  $(OBJ)/libc-top-half/musl/src/math/scalbln.o \
  $(OBJ)/libc-top-half/musl/src/math/scalblnf.o \
  $(OBJ)/libc-top-half/musl/src/math/scalblnl.o \
  $(OBJ)/libc-top-half/musl/src/math/scalbn.o \
  $(OBJ)/libc-top-half/musl/src/math/scalbnf.o \
  $(OBJ)/libc-top-half/musl/src/math/scalbnl.o \
  $(OBJ)/libc-top-half/musl/src/math/signgam.o \
  $(OBJ)/libc-top-half/musl/src/math/significand.o \
  $(OBJ)/libc-top-half/musl/src/math/significandf.o \
  $(OBJ)/libc-top-half/musl/src/math/sin.o \
  $(OBJ)/libc-top-half/musl/src/math/sincos.o \
  $(OBJ)/libc-top-half/musl/src/math/sincosf.o \
  $(OBJ)/libc-top-half/musl/src/math/sincosl.o \
  $(OBJ)/libc-top-half/musl/src/math/sinf.o \
  $(OBJ)/libc-top-half/musl/src/math/sinh.o \
  $(OBJ)/libc-top-half/musl/src/math/sinhf.o \
  $(OBJ)/libc-top-half/musl/src/math/sinhl.o \
  $(OBJ)/libc-top-half/musl/src/math/sinl.o \
  $(OBJ)/libc-top-half/musl/src/math/sqrt_data.o \
  $(OBJ)/libc-top-half/musl/src/math/sqrtl.o \
  $(OBJ)/libc-top-half/musl/src/math/tan.o \
  $(OBJ)/libc-top-half/musl/src/math/tanf.o \
  $(OBJ)/libc-top-half/musl/src/math/tanh.o \
  $(OBJ)/libc-top-half/musl/src/math/tanhf.o \
  $(OBJ)/libc-top-half/musl/src/math/tanhl.o \
  $(OBJ)/libc-top-half/musl/src/math/tanl.o \
  $(OBJ)/libc-top-half/musl/src/math/tgamma.o \
  $(OBJ)/libc-top-half/musl/src/math/tgammaf.o \
  $(OBJ)/libc-top-half/musl/src/math/tgammal.o \
  $(OBJ)/libc-top-half/musl/src/math/truncl.o \
  $(OBJ)/libc-top-half/musl/src/misc/a64l.o \
  $(OBJ)/libc-top-half/musl/src/misc/basename.o \
  $(OBJ)/libc-top-half/musl/src/misc/dirname.o \
  $(OBJ)/libc-top-half/musl/src/misc/ffs.o \
  $(OBJ)/libc-top-half/musl/src/misc/ffsl.o \
  $(OBJ)/libc-top-half/musl/src/misc/ffsll.o \
  $(OBJ)/libc-top-half/musl/src/misc/fmtmsg.o \
  $(OBJ)/libc-top-half/musl/src/misc/getdomainname.o \
  $(OBJ)/libc-top-half/musl/src/misc/gethostid.o \
  $(OBJ)/libc-top-half/musl/src/misc/getopt.o \
  $(OBJ)/libc-top-half/musl/src/misc/getopt_long.o \
  $(OBJ)/libc-top-half/musl/src/misc/getsubopt.o \
  $(OBJ)/libc-top-half/musl/src/misc/nftw.o \
  $(OBJ)/libc-top-half/musl/src/misc/uname.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/btowc.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/c16rtomb.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/c32rtomb.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/internal.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mblen.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbrlen.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc16.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbrtoc32.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbrtowc.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbsinit.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbsnrtowcs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbsrtowcs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbstowcs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/mbtowc.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wcrtomb.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wcsnrtombs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wcsrtombs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wcstombs.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wctob.o \
  $(OBJ)/libc-top-half/musl/src/multibyte/wctomb.o \
  $(OBJ)/libc-top-half/musl/src/network/htonl.o \
  $(OBJ)/libc-top-half/musl/src/network/htons.o \
  $(OBJ)/libc-top-half/musl/src/network/in6addr_any.o \
  $(OBJ)/libc-top-half/musl/src/network/in6addr_loopback.o \
  $(OBJ)/libc-top-half/musl/src/network/inet_aton.o \
  $(OBJ)/libc-top-half/musl/src/network/inet_ntop.o \
  $(OBJ)/libc-top-half/musl/src/network/inet_pton.o \
  $(OBJ)/libc-top-half/musl/src/network/ntohl.o \
  $(OBJ)/libc-top-half/musl/src/network/ntohs.o \
  $(OBJ)/libc-top-half/musl/src/prng/__rand48_step.o \
  $(OBJ)/libc-top-half/musl/src/prng/__seed48.o \
  $(OBJ)/libc-top-half/musl/src/prng/drand48.o \
  $(OBJ)/libc-top-half/musl/src/prng/lcong48.o \
  $(OBJ)/libc-top-half/musl/src/prng/lrand48.o \
  $(OBJ)/libc-top-half/musl/src/prng/mrand48.o \
  $(OBJ)/libc-top-half/musl/src/prng/rand.o \
  $(OBJ)/libc-top-half/musl/src/prng/rand_r.o \
  $(OBJ)/libc-top-half/musl/src/prng/random.o \
  $(OBJ)/libc-top-half/musl/src/prng/seed48.o \
  $(OBJ)/libc-top-half/musl/src/prng/srand48.o \
  $(OBJ)/libc-top-half/musl/src/regex/fnmatch.o \
  $(OBJ)/libc-top-half/musl/src/regex/glob.o \
  $(OBJ)/libc-top-half/musl/src/regex/regcomp.o \
  $(OBJ)/libc-top-half/musl/src/regex/regerror.o \
  $(OBJ)/libc-top-half/musl/src/regex/regexec.o \
  $(OBJ)/libc-top-half/musl/src/regex/tre-mem.o \
  $(OBJ)/libc-top-half/musl/src/search/hsearch.o \
  $(OBJ)/libc-top-half/musl/src/search/insque.o \
  $(OBJ)/libc-top-half/musl/src/search/lsearch.o \
  $(OBJ)/libc-top-half/musl/src/search/tdelete.o \
  $(OBJ)/libc-top-half/musl/src/search/tdestroy.o \
  $(OBJ)/libc-top-half/musl/src/search/tfind.o \
  $(OBJ)/libc-top-half/musl/src/search/tsearch.o \
  $(OBJ)/libc-top-half/musl/src/search/twalk.o \
  $(OBJ)/libc-top-half/musl/src/stat/futimesat.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__fclose_ca.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__fdopen.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__fmodeflags.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__fopen_rb_ca.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__overflow.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdio_close.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdio_exit.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdio_read.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdio_seek.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdio_write.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__stdout_write.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__toread.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__towrite.o \
  $(OBJ)/libc-top-half/musl/src/stdio/__uflow.o \
  $(OBJ)/libc-top-half/musl/src/stdio/asprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/clearerr.o \
  $(OBJ)/libc-top-half/musl/src/stdio/dprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ext.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ext2.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fclose.o \
  $(OBJ)/libc-top-half/musl/src/stdio/feof.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ferror.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fflush.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgetc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgetln.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgetpos.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgets.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgetwc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fgetws.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fileno.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fmemopen.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fopen.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fopencookie.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fputc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fputs.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fputwc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fputws.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fread.o \
  $(OBJ)/libc-top-half/musl/src/stdio/freopen.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fseek.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fsetpos.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ftell.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fwide.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fwprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fwrite.o \
  $(OBJ)/libc-top-half/musl/src/stdio/fwscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getc_unlocked.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getchar.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getchar_unlocked.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getdelim.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getline.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getw.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getwc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/getwchar.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ofl.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ofl_add.o \
  $(OBJ)/libc-top-half/musl/src/stdio/open_memstream.o \
  $(OBJ)/libc-top-half/musl/src/stdio/open_wmemstream.o \
  $(OBJ)/libc-top-half/musl/src/stdio/perror.o \
  $(OBJ)/libc-top-half/musl/src/stdio/printf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putc_unlocked.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putchar.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putchar_unlocked.o \
  $(OBJ)/libc-top-half/musl/src/stdio/puts.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putw.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putwc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/putwchar.o \
  $(OBJ)/libc-top-half/musl/src/stdio/rewind.o \
  $(OBJ)/libc-top-half/musl/src/stdio/scanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/setbuf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/setbuffer.o \
  $(OBJ)/libc-top-half/musl/src/stdio/setlinebuf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/setvbuf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/snprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/sprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/sscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/stderr.o \
  $(OBJ)/libc-top-half/musl/src/stdio/stdin.o \
  $(OBJ)/libc-top-half/musl/src/stdio/stdout.o \
  $(OBJ)/libc-top-half/musl/src/stdio/swprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/swscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ungetc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/ungetwc.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vasprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vdprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfwprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vfwscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vsnprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vsprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vsscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vswprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vswscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vwprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/vwscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/wprintf.o \
  $(OBJ)/libc-top-half/musl/src/stdio/wscanf.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/abs.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/atof.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/atoi.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/atol.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/atoll.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/bsearch.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/div.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/ecvt.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/fcvt.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/gcvt.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/imaxabs.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/imaxdiv.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/labs.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/ldiv.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/llabs.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/lldiv.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/qsort.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/qsort_nr.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/strtod.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/strtol.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/wcstod.o \
  $(OBJ)/libc-top-half/musl/src/stdlib/wcstol.o \
  $(OBJ)/libc-top-half/musl/src/string/bcmp.o \
  $(OBJ)/libc-top-half/musl/src/string/bcopy.o \
  $(OBJ)/libc-top-half/musl/src/string/bzero.o \
  $(OBJ)/libc-top-half/musl/src/string/explicit_bzero.o \
  $(OBJ)/libc-top-half/musl/src/string/index.o \
  $(OBJ)/libc-top-half/musl/src/string/memccpy.o \
  $(OBJ)/libc-top-half/musl/src/string/memchr.o \
  $(OBJ)/libc-top-half/musl/src/string/memcmp.o \
  $(OBJ)/libc-top-half/musl/src/string/memcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/memmem.o \
  $(OBJ)/libc-top-half/musl/src/string/memmove.o \
  $(OBJ)/libc-top-half/musl/src/string/mempcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/memrchr.o \
  $(OBJ)/libc-top-half/musl/src/string/memset.o \
  $(OBJ)/libc-top-half/musl/src/string/rindex.o \
  $(OBJ)/libc-top-half/musl/src/string/stpcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/stpncpy.o \
  $(OBJ)/libc-top-half/musl/src/string/strcasecmp.o \
  $(OBJ)/libc-top-half/musl/src/string/strcasestr.o \
  $(OBJ)/libc-top-half/musl/src/string/strcat.o \
  $(OBJ)/libc-top-half/musl/src/string/strchr.o \
  $(OBJ)/libc-top-half/musl/src/string/strchrnul.o \
  $(OBJ)/libc-top-half/musl/src/string/strcmp.o \
  $(OBJ)/libc-top-half/musl/src/string/strcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/strcspn.o \
  $(OBJ)/libc-top-half/musl/src/string/strdup.o \
  $(OBJ)/libc-top-half/musl/src/string/strerror_r.o \
  $(OBJ)/libc-top-half/musl/src/string/strlcat.o \
  $(OBJ)/libc-top-half/musl/src/string/strlcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/strlen.o \
  $(OBJ)/libc-top-half/musl/src/string/strncasecmp.o \
  $(OBJ)/libc-top-half/musl/src/string/strncat.o \
  $(OBJ)/libc-top-half/musl/src/string/strncmp.o \
  $(OBJ)/libc-top-half/musl/src/string/strncpy.o \
  $(OBJ)/libc-top-half/musl/src/string/strndup.o \
  $(OBJ)/libc-top-half/musl/src/string/strnlen.o \
  $(OBJ)/libc-top-half/musl/src/string/strpbrk.o \
  $(OBJ)/libc-top-half/musl/src/string/strrchr.o \
  $(OBJ)/libc-top-half/musl/src/string/strsep.o \
  $(OBJ)/libc-top-half/musl/src/string/strspn.o \
  $(OBJ)/libc-top-half/musl/src/string/strstr.o \
  $(OBJ)/libc-top-half/musl/src/string/strtok.o \
  $(OBJ)/libc-top-half/musl/src/string/strtok_r.o \
  $(OBJ)/libc-top-half/musl/src/string/strverscmp.o \
  $(OBJ)/libc-top-half/musl/src/string/swab.o \
  $(OBJ)/libc-top-half/musl/src/string/wcpcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/wcpncpy.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscasecmp.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscasecmp_l.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscat.o \
  $(OBJ)/libc-top-half/musl/src/string/wcschr.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscmp.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscpy.o \
  $(OBJ)/libc-top-half/musl/src/string/wcscspn.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsdup.o \
  $(OBJ)/libc-top-half/musl/src/string/wcslen.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsncasecmp.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsncasecmp_l.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsncat.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsncmp.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsncpy.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsnlen.o \
  $(OBJ)/libc-top-half/musl/src/string/wcspbrk.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsrchr.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsspn.o \
  $(OBJ)/libc-top-half/musl/src/string/wcsstr.o \
  $(OBJ)/libc-top-half/musl/src/string/wcstok.o \
  $(OBJ)/libc-top-half/musl/src/string/wcswcs.o \
  $(OBJ)/libc-top-half/musl/src/string/wmemchr.o \
  $(OBJ)/libc-top-half/musl/src/string/wmemcmp.o \
  $(OBJ)/libc-top-half/musl/src/string/wmemcpy.o \
  $(OBJ)/libc-top-half/musl/src/string/wmemmove.o \
  $(OBJ)/libc-top-half/musl/src/string/wmemset.o \
  $(OBJ)/libc-top-half/musl/src/thread/thrd_sleep.o \
  $(OBJ)/libc-top-half/musl/src/time/__month_to_secs.o \
  $(OBJ)/libc-top-half/musl/src/time/__secs_to_tm.o \
  $(OBJ)/libc-top-half/musl/src/time/__tm_to_secs.o \
  $(OBJ)/libc-top-half/musl/src/time/__tz.o \
  $(OBJ)/libc-top-half/musl/src/time/__year_to_secs.o \
  $(OBJ)/libc-top-half/musl/src/time/asctime.o \
  $(OBJ)/libc-top-half/musl/src/time/asctime_r.o \
  $(OBJ)/libc-top-half/musl/src/time/ctime.o \
  $(OBJ)/libc-top-half/musl/src/time/ctime_r.o \
  $(OBJ)/libc-top-half/musl/src/time/difftime.o \
  $(OBJ)/libc-top-half/musl/src/time/ftime.o \
  $(OBJ)/libc-top-half/musl/src/time/getdate.o \
  $(OBJ)/libc-top-half/musl/src/time/gmtime.o \
  $(OBJ)/libc-top-half/musl/src/time/gmtime_r.o \
  $(OBJ)/libc-top-half/musl/src/time/localtime.o \
  $(OBJ)/libc-top-half/musl/src/time/localtime_r.o \
  $(OBJ)/libc-top-half/musl/src/time/mktime.o \
  $(OBJ)/libc-top-half/musl/src/time/strftime.o \
  $(OBJ)/libc-top-half/musl/src/time/strptime.o \
  $(OBJ)/libc-top-half/musl/src/time/timegm.o \
  $(OBJ)/libc-top-half/musl/src/time/timespec_get.o \
  $(OBJ)/libc-top-half/musl/src/time/wcsftime.o \
  $(OBJ)/libc-top-half/musl/src/unistd/posix_close.o \
  $(OBJ)/libc-top-half/sources/arc4random.o \

$(OUT)/lib/libdl.a: \
  $(OBJ)/libc-top-half/musl/src/misc/dl.o \

$(OUT)/lib/libwasi-emulated-getpid.a: \
  $(OBJ)/libc-bottom-half/getpid/getpid.o \

$(OUT)/lib/libwasi-emulated-mman.a: \
  $(OBJ)/libc-bottom-half/mman/mman.o \

$(OUT)/lib/libwasi-emulated-process-clocks.a: \
  $(OBJ)/libc-bottom-half/clocks/clock.o \
  $(OBJ)/libc-bottom-half/clocks/getrusage.o \
  $(OBJ)/libc-bottom-half/clocks/times.o \

$(OUT)/lib/libwasi-emulated-signal.a: \
  $(OBJ)/libc-bottom-half/signal/signal.o \
  $(OBJ)/libc-top-half/musl/src/signal/psignal.o \
  $(OBJ)/libc-top-half/musl/src/string/strsignal.o \


OBJ_DIRS := $(OUT)/lib \
  $(OBJ)/dlmalloc/src \
  $(OBJ)/libc-bottom-half/clocks \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/dirent \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/errno \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/fcntl \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/poll \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sched \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdio \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/stdlib \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/ioctl \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/select \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/socket \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/stat \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/time \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/sys/uio \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/time \
  $(OBJ)/libc-bottom-half/cloudlibc/src/libc/unistd \
  $(OBJ)/libc-bottom-half/crt \
  $(OBJ)/libc-bottom-half/getpid \
  $(OBJ)/libc-bottom-half/mman \
  $(OBJ)/libc-bottom-half/signal \
  $(OBJ)/libc-bottom-half/sources \
  $(OBJ)/libc-bottom-half/sources/math \
  $(OBJ)/libc-top-half/musl/src/complex \
  $(OBJ)/libc-top-half/musl/src/conf \
  $(OBJ)/libc-top-half/musl/src/crypt \
  $(OBJ)/libc-top-half/musl/src/ctype \
  $(OBJ)/libc-top-half/musl/src/dirent \
  $(OBJ)/libc-top-half/musl/src/env \
  $(OBJ)/libc-top-half/musl/src/errno \
  $(OBJ)/libc-top-half/musl/src/exit \
  $(OBJ)/libc-top-half/musl/src/fcntl \
  $(OBJ)/libc-top-half/musl/src/fenv \
  $(OBJ)/libc-top-half/musl/src/internal \
  $(OBJ)/libc-top-half/musl/src/legacy \
  $(OBJ)/libc-top-half/musl/src/locale \
  $(OBJ)/libc-top-half/musl/src/math \
  $(OBJ)/libc-top-half/musl/src/misc \
  $(OBJ)/libc-top-half/musl/src/multibyte \
  $(OBJ)/libc-top-half/musl/src/network \
  $(OBJ)/libc-top-half/musl/src/prng \
  $(OBJ)/libc-top-half/musl/src/regex \
  $(OBJ)/libc-top-half/musl/src/search \
  $(OBJ)/libc-top-half/musl/src/signal \
  $(OBJ)/libc-top-half/musl/src/stat \
  $(OBJ)/libc-top-half/musl/src/stdio \
  $(OBJ)/libc-top-half/musl/src/stdlib \
  $(OBJ)/libc-top-half/musl/src/string \
  $(OBJ)/libc-top-half/musl/src/thread \
  $(OBJ)/libc-top-half/musl/src/time \
  $(OBJ)/libc-top-half/musl/src/unistd \
  $(OBJ)/libc-top-half/sources \

$(OBJ)/mkdirs.ok: $(OBJ_DIRS)
	$(Q)touch "$@"

$(OBJ_DIRS):
	$(Q)mkdir -p "$@"

$(ALL_LIBS): | $(OBJ_DIRS)

