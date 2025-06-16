# Text shaping library
# https://harfbuzz.github.io/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libcxx
#!DEP ports/libz
#!DEP ports/freetype-no-hb
source /p/tools/pbuild.lib.sh

VERSION=8.2.2

pbuild_fetch_and_unpack \
	https://github.com/harfbuzz/harfbuzz/releases/download/$VERSION/harfbuzz-$VERSION.tar.xz \
	e433ad85fbdf57f680be29479b3f964577379aaf319f557eb76569f0ecbc90f3

pbuild_apply_patches

pbuild_configure_once \
	FREETYPE_CFLAGS=-I$DESTDIR/usr/include/freetype2 \
	FREETYPE_LIBS="-lfreetype -lz" \
	CFLAGS="-D HB_NO_MT" \
	CXXFLAGS="-D HB_NO_MT" \
	./configure \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-freetype \
		--disable-shared \
		--enable-static \
		--disable-gtk-doc \
		--with-cairo=no

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR

rm $DESTDIR/lib/libharfbuzz.la
rm $DESTDIR/lib/libharfbuzz-cairo.*  $DESTDIR/lib/pkgconfig/harfbuzz-cairo.*
rm $DESTDIR/lib/libharfbuzz-subset.* $DESTDIR/lib/pkgconfig/harfbuzz-subset.*

rm -r $DESTDIR/lib/cmake/harfbuzz
find $DESTDIR/lib/cmake -empty -type d -delete

rm -r $DESTDIR/usr/share/gtk-doc/html/harfbuzz
find $DESTDIR/usr/share/gtk-doc -empty -type d -delete
