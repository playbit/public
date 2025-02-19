# multiple-precision floating-point computations
# https://www.mpfr.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libgmp
#
source /p/tools/pbuild.lib.sh

VERSION=4.2.1

pbuild_fetch_and_unpack \
	https://www.mpfr.org/mpfr-current/mpfr-$VERSION.tar.xz \
	277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2

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
		--disable-shared

make -j$MAXJOBS
[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] &&
	make -j$MAXJOBS check
make -j$MAXJOBS install DESTDIR=$DESTDIR

# remove libtool files
rm -f $DESTDIR/lib/libmpfr.la
