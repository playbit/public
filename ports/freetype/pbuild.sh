# TrueType font rendering library
# https://www.freetype.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/pkgconf
#
#!DEP ports/libc
#!DEP ports/libz
#!DEP ports/brotli
#!DEP ports/harfbuzz
source /p/tools/pbuild.lib.sh

VERSION=2.13.2

pbuild_fetch_and_unpack \
	https://download.savannah.gnu.org/releases/freetype/freetype-$VERSION.tar.xz \
	12991c4e55c506dd7f9b765933e62fd2be2e06d421505d7950a132e4f1bb484d

pbuild_apply_patches

# Workaround for harfbuzz without freetype.
# Explanation: harfbuzz depends on freetype, which leads to freetype's configure script failing
# to "detect" harfbuzz since it runs "pkg-config --cflags 'harfbuzz >= 2.0.0'" to do so, which
# in turn fails since pkg-config won't find freetype. So we create a temporary version of
# harfbuzz.pc that doesn't declare that dependency.
mkdir -p pbuild_pkgconfig
sed 's|Requires.private:.*||' $DESTDIR/lib/pkgconfig/harfbuzz.pc > pbuild_pkgconfig/harfbuzz.pc

pbuild_configure_once \
	HARFBUZZ_CFLAGS= \
	HARFBUZZ_LIBS=-lharfbuzz \
	PKG_CONFIG_PATH="$PWD/pbuild_pkgconfig:$PKG_CONFIG_PATH" \
	./configure \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--disable-shared \
		--enable-static \
		--with-harfbuzz=yes \
		--with-brotli=yes \
		--with-zlib=yes \
		--disable-freetype-config

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR

rm $DESTDIR/lib/libfreetype.la
