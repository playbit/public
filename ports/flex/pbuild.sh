# a tool for generating text-scanning programs
# https://github.com/westes/flex
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/m4
#!DEP ports/libc [transitive]
source /p/tools/pbuild.lib.sh

VERSION=2.6.4

pbuild_fetch_and_unpack \
	https://github.com/westes/flex/releases/download/v$VERSION/flex-$VERSION.tar.gz \
	e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995

pbuild_apply_patches

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-shared

make -j$MAXJOBS install DESTDIR=$DESTDIR
[ -n "$DEBUG" ] || strip $DESTDIR/bin/flex

# don't keep libfl
rm $DESTDIR/lib/libfl.*
rm $DESTDIR/usr/include/FlexLexer.h
