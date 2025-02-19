# Port of OpenBSD's free SSH release
# https://www.openssh.com/portable.html
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/autoconf
#!BUILDTOOL ports/automake
#
#!DEP ports/libc
#!DEP ports/libz
#!DEP ports/openssl [transitive]
#!DEP ports/libedit
#
source /p/tools/pbuild.lib.sh

VERSION=9.8_p1
VER_URL=${VERSION%_*}${VERSION#*_} # e.g. "9.8p1" when VERSION=9.8_p1

pbuild_fetch_and_unpack \
	https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$VER_URL.tar.gz \
	dd8bd002a379b5d499dfb050dd1fa9af8029e80461f4bb6c523c49973f5a39f3

pbuild_apply_patches

pbuild_run_once autoreconf

pbuild_configure_once ./configure \
	--build=$CBUILD \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--sbindir=/sbin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	\
	--with-pid-dir=/run \
	--with-mantype=doc \
	--with-cflags="$CFLAGS" \
	--with-ldflags="$LDFLAGS" \
	--disable-utmp \
	--disable-wtmp \
	--disable-lastlog \
	--disable-strip \
	--with-privsep-path=/var/empty \
	--with-xauth=/bin/xauth \
	--with-default-path='/sbin:/bin' \
	--with-privsep-user=sshd \
	--with-ssl-engine \
	--with-libedit \
	\
	--without-kerberos5 \
	--without-pam \


make -j$MAXJOBS

mkdir -p /var/empty

if [ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ]; then
	# run tests only when ssh changed to speed up rebuilds (testing takes a very long time)
	sha256sum ssh > pbuild_ssh_checksum.new
	if ! diff -q pbuild_ssh_checksum pbuild_ssh_checksum.new 2>&1 >/dev/null; then
		TESTS="file-tests interop-tests unit"
		# TESTS="$TESTS t-exec" # this test takes a VERY VERY long time
		TEST_SSH_UNSAFE_PERMISSIONS=1 make -j1 $TESTS
		mv pbuild_ssh_checksum.new pbuild_ssh_checksum
	fi
fi

make -j$MAXJOBS install INSTALL_STRIP=-s DESTDIR=$DESTDIR

install -v -D -m755 $BUILDDIR/contrib/ssh-copy-id   $DESTDIR/usr/bin/ssh-copy-id
install -v -D -m755 $BUILDDIR/contrib/ssh-copy-id.1 $DESTDIR/usr/share/man/man1/ssh-copy-id.1
install -v -D -m755 $BUILDDIR/contrib/findssl.sh    $DESTDIR/bin/findssl.sh
install -v -D -m755 $BUILDDIR/ssh-pkcs11-helper     $DESTDIR/bin/ssh-pkcs11-helper
