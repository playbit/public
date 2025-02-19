# collection of Linux utilities
# https://git.kernel.org/cgit/utils/util-linux/util-linux.git
# Note: We only build what we need (libuuid and libblkid)
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/bash
#!DEP ports/libc [transitive]
source /p/tools/pbuild.lib.sh

VERSION=2.40.2

pbuild_fetch_and_unpack \
	https://www.kernel.org/pub/linux/utils/util-linux/v${VERSION%.*}/util-linux-$VERSION.tar.xz \
	d78b37a66f5922d70edf3bdfb01a6b33d34ed3c3cafd6628203b2a2b67c8e8b3

pbuild_apply_patches

# There's no --disable-setarch so we patch configure
pbuild_run_once \
	sed -i -e 's/build_setarch=yes/build_setarch=no/g' configure

pbuild_configure_once \
	CFLAGS="$CFLAGS -static" \
	LDFLAGS="$CFLAGS --static" \
	./configure \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--sbindir=/sbin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		\
		--disable-raw \
		\
		--without-python \
		--without-econf \
		--without-systemd \
		\
		--enable-static \
		--disable-shared \
		\
		--disable-all-programs \
		--enable-libblkid \
		--enable-libuuid \
		\
		--disable-chfn-chsh \
		--disable-uuidd \
		--disable-nls \
		--disable-tls \
		--disable-kill \
		--disable-login \
		--disable-last \
		--disable-sulogin \
		--disable-su \
		--disable-plymouth_support \
		--disable-bash-completion \
		--disable-libmount \
		--disable-liblastlog2 \

make -j$MAXJOBS

exit 0

mkdir -p $DESTDIR/bin $DESTDIR/sbin
[ -L $DESTDIR/usr/bin ] || ln -s ../bin $DESTDIR/usr/bin
[ -L $DESTDIR/usr/sbin ] || ln -s ../sbin $DESTDIR/usr/sbin
make -j$MAXJOBS DESTDIR=$DESTDIR install
