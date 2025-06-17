# Tools for squashfs, like mksquashfs
# https://github.com/plougher/squashfs-tools
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!DEP ports/libc [transitive]
#!DEP ports/libz
#!DEP ports/libzstd
source /p/tools/pbuild.lib.sh

VERSION=4.6.1

pbuild_fetch_and_unpack \
	https://github.com/plougher/squashfs-tools/releases/download/$VERSION/squashfs-tools-$VERSION.tar.gz \
	94201754b36121a9f022a190c75f718441df15402df32c2b520ca331a107511c \
	squashfs-tools-$VERSION.tar.gz

CPPFLAGS="$CPPFLAGS -O2 -flto=thin" \
make -j$NJOBS -C squashfs-tools ZSTD_SUPPORT=1

make -j$NJOBS -C squashfs-tools \
	INSTALL_MANPAGES_DIR="$DESTDIR/usr/share/man/man1" \
	INSTALL_PREFIX="$DESTDIR/usr" \
	USE_PREBUILT_MANPAGES=y \
	install
