# WebP image library
# https://developers.google.com/speed/webp
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libz
#
source /p/tools/pbuild.lib.sh

VERSION=1.5.0

pbuild_fetch_and_unpack \
	https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$VERSION.tar.gz \
	7d6fab70cf844bf6769077bd5d7a74893f8ffd4dfb42861745750c63c2a5c92c

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
	--disable-tools \
	$CONFIGURE_ARGS

make -j$MAXJOBS
[ $ARCH != $NATIVE_ARCH ] || make -j$MAXJOBS check
make -j$MAXJOBS DESTDIR=$DESTDIR install
