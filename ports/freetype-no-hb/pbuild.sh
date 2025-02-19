# TrueType font rendering library
# https://www.freetype.org/
#
# Note: this is a special package only used while building harfbuzz, since harfbuzz needs
# freetype to build with freetype APIs and freetype needs harfbuzz to build with hb APIs.
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#
source /p/tools/pbuild.lib.sh
VERSION=$(grep -E '^VERSION=' ../freetype/pbuild.sh | cut -d= -f2)

pbuild_fetch_and_unpack \
	https://download.savannah.gnu.org/releases/freetype/freetype-$VERSION.tar.xz \
	12991c4e55c506dd7f9b765933e62fd2be2e06d421505d7950a132e4f1bb484d

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
	--enable-static

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR
