#!BUILDTOOL toolchain
#!DEP ports/libc
include ../../tools/playbit.defs.mk

CARES_VERSION := 1.28.1
CFLAGS += \
	-Iinclude -I. \
	-DHAVE_CONFIG_H \
	-DCARES_BUILDING_LIBRARY \
	-DCARES_NO_DEPRECATED \
	-Wall \
	-Wextra \
	-Wcast-align \
	-Wconversion \
	-Wdeclaration-after-statement \
	-Wdouble-promotion \
	-Wfloat-equal \
	-Wformat-security \
	-Winit-self \
	-Wmissing-braces \
	-Wmissing-declarations \
	-Wmissing-format-attribute \
	-Wmissing-include-dirs \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wold-style-definition \
	-Wpacked \
	-Wpointer-arith \
	-Wredundant-decls \
	-Wshadow \
	-Wsign-conversion \
	-Wstrict-overflow \
	-Wstrict-prototypes \
	-Wundef \
	-Wunused \
	-Wvariadic-macros \
	-Wvla \
	-Wwrite-strings \
	-Werror=implicit-int \
	-Werror=implicit-function-declaration \
	-Werror=partial-availability \
	-pthread

LIB_SRCS := \
	ares__addrinfo2hostent.c \
	ares__addrinfo_localhost.c \
	ares__buf.c \
	ares__close_sockets.c \
	ares__hosts_file.c \
	ares__htable.c \
	ares__htable_asvp.c \
	ares__htable_strvp.c \
	ares__htable_szvp.c \
	ares__iface_ips.c \
	ares__llist.c \
	ares__parse_into_addrinfo.c \
	ares__slist.c \
	ares__socket.c \
	ares__sortaddrinfo.c \
	ares__threads.c \
	ares__timeval.c \
	ares_cancel.c \
	ares_data.c \
	ares_destroy.c \
	ares_dns_mapping.c \
	ares_dns_name.c \
	ares_dns_parse.c \
	ares_dns_record.c \
	ares_dns_write.c \
	ares_event_epoll.c \
	ares_event_poll.c \
	ares_event_select.c \
	ares_event_thread.c \
	ares_event_wake_pipe.c \
	ares_expand_name.c \
	ares_expand_string.c \
	ares_fds.c \
	ares_free_hostent.c \
	ares_free_string.c \
	ares_freeaddrinfo.c \
	ares_getaddrinfo.c \
	ares_getenv.c \
	ares_gethostbyaddr.c \
	ares_gethostbyname.c \
	ares_getnameinfo.c \
	ares_getsock.c \
	ares_init.c \
	ares_library_init.c \
	ares_math.c \
	ares_create_query.c \
	ares_options.c \
	ares_parse_a_reply.c \
	ares_parse_aaaa_reply.c \
	ares_parse_caa_reply.c \
	ares_parse_mx_reply.c \
	ares_parse_naptr_reply.c \
	ares_parse_ns_reply.c \
	ares_parse_ptr_reply.c \
	ares_parse_soa_reply.c \
	ares_parse_srv_reply.c \
	ares_parse_txt_reply.c \
	ares_parse_uri_reply.c \
	ares_platform.c \
	ares_process.c \
	ares_qcache.c \
	ares_query.c \
	ares_rand.c \
	ares_search.c \
	ares_send.c \
	ares_strcasecmp.c \
	ares_str.c \
	ares_strerror.c \
	ares_strsplit.c \
	ares_sysconfig.c \
	ares_sysconfig_files.c \
	ares_timeout.c \
	ares_update_servers.c \
	ares_version.c \
	inet_net_pton.c \
	inet_ntop.c

DIG_SRCS := ares_strcasecmp.c cmd/ares_getopt.c cmd/adig.c
HOST_SRCS := ares_strcasecmp.c cmd/ares_getopt.c cmd/ahost.c

PRODUCTS := \
	bin/dig \
	bin/host \
	lib/libcares.a \
	lib/pkgconfig/libcares.pc \
	usr/include/ares_build.h \
	usr/include/ares_dns_record.h \
	usr/include/ares_dns.h \
	usr/include/ares_nameser.h \
	usr/include/ares_rules.h \
	usr/include/ares_version.h \
	usr/include/ares.h

LIB_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIB_SRCS)))
DIG_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(DIG_SRCS)))
HOST_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(HOST_SRCS)))
ALL_OBJS := $(LIB_OBJS) $(DIG_OBJS) $(HOST_OBJS)
PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libcares.a: $(LIB_OBJS)
$(DESTDIR)/bin/dig: $(DIG_OBJS) $(DESTDIR)/lib/libcares.a
$(DESTDIR)/bin/host: $(HOST_OBJS) $(DESTDIR)/lib/libcares.a

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
