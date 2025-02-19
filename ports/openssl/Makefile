# openssl "reach out" build
# When upgrading, please run 'make test'
#
# Note: BOOTSTRAP because ports/curl requires openssl to build, and we need curl to
# fetch the openssl sources.
#!BOOTSTRAP
#!BUILDTOOL toolchain
#!BUILDTOOL ports/perl
#!DEP ports/libc [transitive]
#
include ../../tools/playbit.defs.mk

OPENSSL_VERSION := 3.3.0
STAGINGDIR := $(BUILDDIR)/install
CONFIGURE_ARGS :=
ifeq ($(ARCH),x86_64)
	CONFIGURE_ARGS += enable-ec_nistp_64_gcc_128
endif
ifeq ($(filter $(ARCH),aarch64 x86_64),)
$(error invalid ARCH=$(ARCH))
endif

INSTALLFILES := \
	etc/ssl/openssl.cnf \
	etc/ssl/ct_log_list.cnf \
	lib/libssl.a \
	lib/libssl.so \
	lib/libssl.so.3 \
	lib/libcrypto.a \
	lib/libcrypto.so \
	lib/libcrypto.so.3 \
	lib/pkgconfig/libcrypto.pc \
	lib/pkgconfig/libssl.pc \
	lib/pkgconfig/openssl.pc \
	bin/openssl

HEADERFILES := \
	aes.h asn1.h asn1_mac.h asn1err.h asn1t.h async.h asyncerr.h bio.h bioerr.h \
	blowfish.h bn.h bnerr.h buffer.h buffererr.h camellia.h cast.h cmac.h cmp.h \
	cmp_util.h cmperr.h cms.h cmserr.h comp.h comperr.h conf.h conf_api.h conferr.h \
	configuration.h conftypes.h core.h core_dispatch.h core_names.h core_object.h \
	crmf.h crmferr.h crypto.h cryptoerr.h cryptoerr_legacy.h ct.h cterr.h decoder.h \
	decodererr.h des.h dh.h dherr.h dsa.h dsaerr.h dtls1.h e_os2.h e_ostime.h \
	ebcdic.h ec.h ecdh.h ecdsa.h ecerr.h encoder.h encodererr.h engine.h \
	engineerr.h err.h ess.h esserr.h evp.h evperr.h fips_names.h fipskey.h hmac.h \
	hpke.h http.h httperr.h idea.h kdf.h kdferr.h lhash.h macros.h md2.h md4.h \
	md5.h mdc2.h modes.h obj_mac.h objects.h objectserr.h ocsp.h ocsperr.h \
	opensslconf.h opensslv.h ossl_typ.h param_build.h params.h pem.h pem2.h \
	pemerr.h pkcs12.h pkcs12err.h pkcs7.h pkcs7err.h prov_ssl.h proverr.h \
	provider.h quic.h rand.h randerr.h rc2.h rc4.h rc5.h ripemd.h rsa.h rsaerr.h \
	safestack.h seed.h self_test.h sha.h srp.h srtp.h ssl.h ssl2.h ssl3.h sslerr.h \
	sslerr_legacy.h stack.h store.h storeerr.h symhacks.h thread.h tls1.h trace.h \
	ts.h tserr.h txt_db.h types.h ui.h uierr.h whrlpool.h x509.h x509_vfy.h \
	x509err.h x509v3.h x509v3err.h

INSTALLFILES += $(addprefix usr/include/openssl/,$(HEADERFILES))
DESTFILES := $(addprefix $(DESTDIR)/,$(INSTALLFILES))

all: $(DESTFILES)
install: $(DESTFILES)
clean:
	$(Q)rm -rf $(BUILDDIR) $(STAGINGDIR) $(DESTFILES)
clean-build:
	$(Q)rm -rf $(BUILDDIR) $(STAGINGDIR)
uninstall:
	$(Q)rm -rfv $(DESTFILES)
test: check-HEADERFILES $(BUILDDIR)/libssl.so
	$(Q)# removing test broken when compiling with clang
	$(Q)rm -f $(BUILDDIR)/test/recipes/01-test_symbol_presence.t
	$(Q)# remvoing AFALG test which have a sporadic test failure, according to aports
	$(Q)rm -f $(BUILDDIR)/test/recipes/30-test_afalg.t
	$(MAKE) -C $(BUILDDIR) test

$(DESTDIR)/bin/%: $(STAGINGDIR)/usr/bin/%
	$(QLOG) INSTALL $@
	$(Q)install -m0755 -D $< "$@"
$(DESTDIR)/lib/libcrypto.so: $(STAGINGDIR)/lib/libcrypto.so.3
$(DESTDIR)/lib/libssl.so: $(STAGINGDIR)/lib/libssl.so.3
$(DESTDIR)/lib/%.so: $(STAGINGDIR)/lib/%.so.3 | $(DESTDIR)/lib
	$(QLOG) "SYMLINK $@ -> $(<F)"
	$(Q)ln -sf $(<F) $@
$(DESTDIR)/lib/%.so.3: $(STAGINGDIR)/lib/%.so.3 | $(DESTDIR)/lib
	$(QLOG) INSTALL $@
	$(Q)install -m0755 -D $< "$@"
$(DESTDIR)/bin/%: $(STAGINGDIR)/bin/% | $(DESTDIR)/bin
	$(QLOG) INSTALL $@
	$(Q)install -m0755 -D $< "$@"
$(DESTDIR)/%: $(STAGINGDIR)/%
	$(QLOG) INSTALL $@
	$(Q)install -m0644 -D $< "$@"

$(DESTDIR)/lib:
	mkdir -p "$@"

$(DESTDIR)/bin:
	mkdir -p "$@"

$(DESTFILES): $(STAGINGDIR)/ok
$(addprefix $(STAGINGDIR)/,$(INSTALLFILES)): $(BUILDDIR)/ok

# install into temporary directory
$(STAGINGDIR)/ok: $(BUILDDIR)/ok
	$(QLOG) "MAKE install -> $(STAGINGDIR)"
	$(Q)rm -rf $(STAGINGDIR)
	$(Q)mkdir -p $(STAGINGDIR)
	$(Q)$(MAKE) -C $(BUILDDIR) DESTDIR=$(STAGINGDIR) install
	$(Q)mv $(STAGINGDIR)/usr/bin $(STAGINGDIR)/bin
	$(Q)touch $@

# build
$(BUILDDIR)/ok: $(BUILDDIR)/configdata.pm
	$(QLOG) "MAKE build"
	$(Q)$(MAKE) -C $(BUILDDIR)
	$(Q)touch $@

# configure
# See https://github.com/openssl/openssl/blob/master/INSTALL.md#configuration-options
$(BUILDDIR)/configdata.pm: $(BUILDDIR)/Configure
	$(QLOG) CONFIGURE openssl
	$(Q)cd $(BUILDDIR) && \
		perl Configure \
			linux-$(ARCH) \
			--prefix=/usr \
			--libdir=/lib \
			--openssldir=/etc/ssl \
			CC=clang \
			CXX=clang++ \
			AS=clang \
			CPPFLAGS="--target=$(ARCH)-playbit" \
			CFLAGS="--target=$(ARCH)-playbit" \
			CXXFLAGS="--target=$(ARCH)-playbit" \
			LDFLAGS="-Wa,--noexecstack" \
			enable-ktls \
			shared \
			no-zlib \
			no-async \
			no-comp \
			no-idea \
			no-mdc2 \
			no-rc5 \
			no-ssl3 \
			no-seed \
			no-weak-ssl-ciphers \
			no-module \
			$(CONFIGURE_ARGS)

$(BUILDDIR)/Configure:
	download -o "$(DOWNLOAD)/openssl-$(OPENSSL_VERSION).tar.gz" \
		--sha256 53e66b043322a606abf0087e7699a0e033a37fa13feb9742df35c3a33b18fb02 \
		"https://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz"
	mkdir -p "$(BUILDDIR)"
	tar -C "$(BUILDDIR)" --strip-components=1 -xozf \
		"$(DOWNLOAD)/openssl-$(OPENSSL_VERSION).tar.gz"

# utility for upgrading openssl; checks if HEADERFILES needs updating
check-HEADERFILES: $(STAGINGDIR)/lib/libssl.so
	$(Q)# Checking if HEADERFILES are up to date
	$(Q)ls -1 $(STAGINGDIR)/usr/include/openssl | sort -u > $(STAGINGDIR)/headers2.txt
	$(Q)rm -f $(STAGINGDIR)/headers1.txt
	$(foreach a,$(HEADERFILES),$(NEWLINE)@echo $(a) >> $(STAGINGDIR)/headers1.txt)
	$(Q)diff -u \
		-L "Makefile HEADERFILES" $(STAGINGDIR)/headers1.txt \
		-L "Files at $(STAGINGDIR)/usr/include/openssl/" $(STAGINGDIR)/headers2.txt

print-DESTFILES:
	@echo "DESTFILES ="
	$(foreach a,$(DESTFILES),$(NEWLINE)@echo "  $(a)")

.PHONY: all install clean clean-build uninstall test check-HEADERFILES print-DESTFILES
