#!BUILDTOOL toolchain
#!DEP ports/libc [transitive]
#!DEP ports/openssl [transitive]
#!DEP ports/libz
#!DEP ports/libzstd
#!DEP ports/libcares
#!DEP ports/libnghttp2
#!DEP ports/brotli
# TODO: nghttp3
include ../../tools/playbit.defs.mk
CURL_VERSION := 8.7.1

PRODUCTS := \
	bin/curl \
	bin/curl-config \
	lib/libcurl.a \
	lib/pkgconfig/libcurl.pc \
	usr/share/man/man1/curl.1.gz \
	usr/include/curl/curl.h \
	usr/include/curl/curlver.h \
	usr/include/curl/easy.h \
	usr/include/curl/header.h \
	usr/include/curl/mprintf.h \
	usr/include/curl/multi.h \
	usr/include/curl/options.h \
	usr/include/curl/stdcheaders.h \
	usr/include/curl/system.h \
	usr/include/curl/typecheck-gcc.h \
	usr/include/curl/urlapi.h \
	usr/include/curl/websockets.h

CFLAGS += \
	-Iinclude \
	-Ilib \
	-DHAVE_CONFIG_H \
	-DCURL_STATICLIB \
	-Qunused-arguments \
	-Wno-pointer-bool-conversion

CFLAGS_LIB := -fvisibility=hidden -DCURL_HIDDEN_SYMBOLS -DBUILDING_LIBCURL
CFLAGS_CURL := -I. -DBUILDING_CURL

LDFLAGS += \
	-lcares \
	-lnghttp2 \
	-lssl -lcrypto \
	-lzstd \
	-lz \
	-lbrotlicommon -lbrotlidec

LIB_SRCS := \
	lib/altsvc.c \
	lib/asyn-ares.c \
	lib/asyn-thread.c \
	lib/base64.c \
	lib/bufq.c \
	lib/bufref.c \
	lib/c-hyper.c \
	lib/cf-h1-proxy.c \
	lib/cf-h2-proxy.c \
	lib/cf-haproxy.c \
	lib/cf-https-connect.c \
	lib/cf-socket.c \
	lib/cfilters.c \
	lib/conncache.c \
	lib/connect.c \
	lib/content_encoding.c \
	lib/cookie.c \
	lib/curl_addrinfo.c \
	lib/curl_des.c \
	lib/curl_endian.c \
	lib/curl_fnmatch.c \
	lib/curl_get_line.c \
	lib/curl_gethostname.c \
	lib/curl_gssapi.c \
	lib/curl_memrchr.c \
	lib/curl_multibyte.c \
	lib/curl_ntlm_core.c \
	lib/curl_ntlm_wb.c \
	lib/curl_path.c \
	lib/curl_range.c \
	lib/curl_rtmp.c \
	lib/curl_sasl.c \
	lib/curl_sha512_256.c \
	lib/curl_sspi.c \
	lib/curl_threads.c \
	lib/curl_trc.c \
	lib/cw-out.c \
	lib/dict.c \
	lib/doh.c \
	lib/dynbuf.c \
	lib/dynhds.c \
	lib/easy.c \
	lib/easygetopt.c \
	lib/easyoptions.c \
	lib/escape.c \
	lib/file.c \
	lib/fileinfo.c \
	lib/fopen.c \
	lib/formdata.c \
	lib/ftp.c \
	lib/ftplistparser.c \
	lib/getenv.c \
	lib/getinfo.c \
	lib/gopher.c \
	lib/hash.c \
	lib/headers.c \
	lib/hmac.c \
	lib/hostasyn.c \
	lib/hostip.c \
	lib/hostip4.c \
	lib/hostip6.c \
	lib/hostsyn.c \
	lib/hsts.c \
	lib/http.c \
	lib/http1.c \
	lib/http2.c \
	lib/http_aws_sigv4.c \
	lib/http_chunks.c \
	lib/http_digest.c \
	lib/http_negotiate.c \
	lib/http_ntlm.c \
	lib/http_proxy.c \
	lib/idn.c \
	lib/if2ip.c \
	lib/imap.c \
	lib/inet_ntop.c \
	lib/inet_pton.c \
	lib/krb5.c \
	lib/ldap.c \
	lib/llist.c \
	lib/macos.c \
	lib/md4.c \
	lib/md5.c \
	lib/memdebug.c \
	lib/mime.c \
	lib/mprintf.c \
	lib/mqtt.c \
	lib/multi.c \
	lib/netrc.c \
	lib/nonblock.c \
	lib/noproxy.c \
	lib/openldap.c \
	lib/parsedate.c \
	lib/pingpong.c \
	lib/pop3.c \
	lib/progress.c \
	lib/psl.c \
	lib/rand.c \
	lib/rename.c \
	lib/request.c \
	lib/rtsp.c \
	lib/select.c \
	lib/sendf.c \
	lib/setopt.c \
	lib/sha256.c \
	lib/share.c \
	lib/slist.c \
	lib/smb.c \
	lib/smtp.c \
	lib/socketpair.c \
	lib/socks.c \
	lib/socks_gssapi.c \
	lib/socks_sspi.c \
	lib/speedcheck.c \
	lib/splay.c \
	lib/strcase.c \
	lib/strdup.c \
	lib/strerror.c \
	lib/strtok.c \
	lib/strtoofft.c \
	lib/telnet.c \
	lib/tftp.c \
	lib/timediff.c \
	lib/timeval.c \
	lib/transfer.c \
	lib/url.c \
	lib/urlapi.c \
	lib/vauth/cleartext.c \
	lib/vauth/cram.c \
	lib/vauth/digest.c \
	lib/vauth/digest_sspi.c \
	lib/vauth/gsasl.c \
	lib/vauth/krb5_gssapi.c \
	lib/vauth/krb5_sspi.c \
	lib/vauth/ntlm.c \
	lib/vauth/ntlm_sspi.c \
	lib/vauth/oauth2.c \
	lib/vauth/spnego_gssapi.c \
	lib/vauth/spnego_sspi.c \
	lib/vauth/vauth.c \
	lib/version.c \
	lib/vquic/curl_msh3.c \
	lib/vquic/curl_ngtcp2.c \
	lib/vquic/curl_osslq.c \
	lib/vquic/curl_quiche.c \
	lib/vquic/vquic-tls.c \
	lib/vquic/vquic.c \
	lib/vssh/libssh.c \
	lib/vssh/libssh2.c \
	lib/vssh/wolfssh.c \
	lib/vtls/bearssl.c \
	lib/vtls/gtls.c \
	lib/vtls/hostcheck.c \
	lib/vtls/keylog.c \
	lib/vtls/mbedtls.c \
	lib/vtls/mbedtls_threadlock.c \
	lib/vtls/openssl.c \
	lib/vtls/schannel.c \
	lib/vtls/schannel_verify.c \
	lib/vtls/sectransp.c \
	lib/vtls/vtls.c \
	lib/vtls/wolfssl.c \
	lib/vtls/x509asn1.c \
	lib/warnless.c \
	lib/ws.c

CURL_SRCS := \
  lib/base64.c \
  lib/curl_multibyte.c \
  lib/dynbuf.c \
  lib/nonblock.c \
  lib/strtoofft.c \
  lib/timediff.c \
  lib/warnless.c \
  tool_binmode.c \
  tool_bname.c \
  tool_cb_dbg.c \
  tool_cb_hdr.c \
  tool_cb_prg.c \
  tool_cb_rea.c \
  tool_cb_see.c \
  tool_cb_wrt.c \
  tool_cfgable.c \
  tool_dirhie.c \
  tool_doswin.c \
  tool_easysrc.c \
  tool_filetime.c \
  tool_findfile.c \
  tool_formparse.c \
  tool_getparam.c \
  tool_getpass.c \
  tool_help.c \
  tool_helpers.c \
  tool_hugehelp.c \
  tool_ipfs.c \
  tool_libinfo.c \
  tool_listhelp.c \
  tool_main.c \
  tool_msgs.c \
  tool_operate.c \
  tool_operhlp.c \
  tool_paramhlp.c \
  tool_parsecfg.c \
  tool_progress.c \
  tool_setopt.c \
  tool_sleep.c \
  tool_stderr.c \
  tool_strdup.c \
  tool_urlglob.c \
  tool_util.c \
  tool_vms.c \
  tool_writeout.c \
  tool_writeout_json.c \
  tool_xattr.c \
  slist_wc.c \
  var.c

# Note: we use a special prefix "tool-" for CURL_OBJS objects since some of the
# source files are the same as those for lib, but uses different cflags.
# This means we also need a custom %.o:%.c make rule.

LIB_OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(LIB_SRCS)))
CURL_OBJS := $(addprefix $(BUILDDIR)/tool-,$(patsubst %,%.o,$(CURL_SRCS)))
ALL_OBJS := $(LIB_OBJS) $(CURL_OBJS)
PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(BUILDDIR)/lib/asyn-ares.c.o: CFLAGS += -Wno-deprecated-declarations

$(LIB_OBJS): CFLAGS += $(CFLAGS_LIB)
$(CURL_OBJS): CFLAGS += $(CFLAGS_CURL)
$(DESTDIR)/lib/libcurl.a: $(LIB_OBJS)
$(DESTDIR)/bin/curl: $(CURL_OBJS) $(DESTDIR)/lib/libcurl.a
$(DESTDIR)/bin/curl-config: curl-config
	$(QLOG) INSTALL $@
	$(Q)install -m0755 $< $@

$(BUILDDIR)/tool-%.c.o: %.c
	$(QLOG) CC $<
	$(Q)$(CC) $(CFLAGS) -MMD -MP -c -o "$@" $<

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall

