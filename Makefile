include tools/playbit.defs.mk

PORTS := $(patsubst ports/%,%,$(wildcard ports/*))

_PBUILDARGS := $(if $(filter 1,$(V)),-p ,)$(PBUILDARGS)
# allow specifying DESTDIR to install locally
ifdef DESTDIR
	ifeq ($(findstring --install=,$(PBUILDARGS)),)
		_PBUILDARGS += --install=$(DESTDIR)
	endif
endif

default:
	@echo "No default make target. Run 'make all' to build all ports" >&2
	@exit 1

all:
	tools/pbuild $(_PBUILDARGS) $(addprefix ports/,$(PORTS))

$(PORTS):
	$(eval _port := $(@:%=%))
	tools/pbuild $(_PBUILDARGS) ports/$(_port)

.PHONY: default all $(PORTS)
