# Creates PKZIP-compatible .zip files
# http://www.info-zip.org/pub/infozip/Zip.html
# license: custom "Info-ZIP"
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=3.0
DLVER=${VERSION%.*}${VERSION##*.}  # e.g. "3.0" => "30"

pbuild_fetch_and_unpack \
	https://downloads.sourceforge.net/infozip/zip${DLVER}.tar.gz \
	f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369

pbuild_apply_patches

make -f unix/Makefile -j$MAXJOBS LOCAL_ZIP="$CFLAGS $CPPFLAGS" prefix=/usr generic
make -f unix/Makefile prefix=$DESTDIR/usr MANDIR=$DESTDIR/usr/share/man/man1 install
strip $DESTDIR/bin/zip $DESTDIR/bin/zipcloak $DESTDIR/bin/zipnote $DESTDIR/bin/zipsplit
