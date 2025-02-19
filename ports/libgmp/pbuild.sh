# libgmp is a library for high precision arithmetic
# https://gmplib.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/m4
#
#!DEP ports/libc
#!DEP ports/libcxx
#
source /p/tools/pbuild.lib.sh

VERSION=6.3.0

pbuild_fetch_and_unpack \
	https://gmplib.org/download/gmp/gmp-$VERSION.tar.xz \
	a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898

pbuild_apply_patches

pbuild_configure_once \
	./configure \
		--host=$CHOST \
		--build=$CBUILD \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--disable-shared \
		--enable-cxx \
		--with-pic

make -j$MAXJOBS

[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] && make -j$MAXJOBS check

make -j$MAXJOBS install DESTDIR=$DESTDIR

# remove libtool files
rm -f $DESTDIR/lib/libgmp.la
rm -f $DESTDIR/lib/libgmpxx.la
