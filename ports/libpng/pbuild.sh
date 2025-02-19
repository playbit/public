# Portable Network Graphics library
# http://www.libpng.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libz
#
source /p/tools/pbuild.lib.sh

VERSION=1.6.43

pbuild_fetch_and_unpack \
	https://downloads.sourceforge.net/libpng/libpng-$VERSION.tar.gz \
	e804e465d4b109b5ad285a8fb71f0dd3f74f0068f91ce3cdfde618180c174925

pbuild_apply_patches

# enable animated PNG support
if [ ! -e apng.patch.gz ]; then
	download -o apng.patch.gz \
		https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-$VERSION-apng.patch.gz
	gzip -cd apng.patch.gz | patch -p1
fi

CONFIGURE_ARGS=
[ $ARCH = aarch64 ]     && CONFIGURE_ARGS=--enable-arm-neon
[ $ARCH = x86_64 ]      && CONFIGURE_ARGS=--enable-intel-sse
[ $ARCH != $NATIVE_ARCH ] && CONFIGURE_ARGS="$CONFIGURE_ARGS --disable-tests"

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

rm $DESTDIR/lib/libpng*.la
