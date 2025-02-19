# The GNU general-purpose parser generator
# https://www.gnu.org/software/bison/bison.html
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/perl
#!BUILDTOOL ports/m4
#
#!DEP ports/m4 [transitive]
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=3.8.2

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/bison/bison-$VERSION.tar.xz \
	9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2

pbuild_apply_patches

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var

make -j$MAXJOBS install DESTDIR=$DESTDIR
[ -n "$DEBUG" ] || strip $DESTDIR/bin/bison

# don't keep examples
rm -rf $DESTDIR/usr/share/doc/bison/examples
