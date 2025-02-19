# GNU macro processor
# https://www.gnu.org/software/m4
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=1.4.19

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/m4/m4-$VERSION.tar.gz \
	3be4a26d825ffdfda52a56fc43246456989a3630093cced3fbddf4771ee58a70

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

rm -rf $DESTDIR/lib/charset.alias
