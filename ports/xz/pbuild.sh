# Library and CLI tools for XZ and LZMA compression
# https://tukaani.org/xz/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#
source /p/tools/pbuild.lib.sh

VERSION=5.6.2

pbuild_fetch_and_unpack \
	https://tukaani.org/xz/xz-$VERSION.tar.xz \
	a9db3bb3d64e248a0fae963f8fb6ba851a26ba1822e504dc0efd18a80c626caf

pbuild_apply_patches

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-shared \
	--enable-static \
	--enable-threads=yes \
	--disable-rpath \
	--disable-werror \
	--disable-doc \
	--disable-nls \
	--enable-sandbox=landlock

make -j$MAXJOBS
[ $ARCH != $NATIVE_ARCH ] || make -j$MAXJOBS check
make -j$MAXJOBS DESTDIR=$DESTDIR install

for exe in lzmadec lzmainfo xz xzdec; do
  echo strip "$DESTDIR/bin/$exe"
  strip "$DESTDIR/bin/$exe"
done
