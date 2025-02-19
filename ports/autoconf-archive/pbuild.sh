# Collection of re-usable GNU Autoconf macros
# https://www.gnu.org/software/autoconf
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/autoconf [transitive]
#
source /p/tools/pbuild.lib.sh

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2023.02.20.tar.xz \
	71d4048479ae28f1f5794619c3d72df9c01df49b1c628ef85fde37596dc31a33

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR
