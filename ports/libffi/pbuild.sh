# portable, high level programming interface to various calling conventions
# https://sourceware.org/libffi/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#
source /p/tools/pbuild.lib.sh

VERSION=3.4.6

pbuild_fetch_and_unpack \
	https://github.com/libffi/libffi/releases/download/v$VERSION/libffi-$VERSION.tar.gz \
	b0dea9df23c863a7a50e825440f3ebffabd65df1497108e5d437747843895a4e

pbuild_apply_patches

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--libdir=/lib \
	--disable-shared \
	--enable-static \
	--enable-pax_emutramp \
	--enable-portable-binary \
	--disable-exec-static-tramp

make -j$MAXJOBS

[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] &&
	make -j$MAXJOBS check

make -j$MAXJOBS install DESTDIR=$DESTDIR
