Q = $(if $(filter 1,$(V)),,@)  # 'make V=1' for verbose mode
QLOG = $(if $(filter 1,$(V)),@#,@echo) # echo when V!=1
MAKEFILE := $(abspath $(firstword $(MAKEFILE_LIST)))
SRCROOT := $(abspath $(lastword $(MAKEFILE_LIST))/../..)
SUBDIR := $(patsubst $(SRCROOT)/%,%,$(CURDIR))
LIBCLANGDIR := /distroot/lib/clang-$(ARCH)-playbit
NCPU := $(shell nproc)

# COMPILE_DEPFLAGS are used by playbit.rules.mk can be overridden by makefiles.
# -MD:  Write dependency files (.d)
# -MMD: Like -MD but ignores "system" files like /usr/include/stdio.h
COMPILE_DEPFLAGS := -MMD

# flags for prelinking, passed to lld
PRELINKFLAGS := $(PRELINKFLAGS) --thinlto-cache-dir=$(LTOCACHEDIR)
ifneq ($(ARCH),wasm32)
	PRELINKFLAGS += \
		--compress-debug-sections=zlib \
		-z noexecstack -z relro -z now -z defs -z notext
endif
export PRELINKFLAGS

# hack to define a make variable that holds "\n"
define NEWLINE


endef
