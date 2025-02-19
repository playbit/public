# commandline option parser
# https://github.com/rpm-software-management/popt
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=1.19

pbuild_fetch_and_unpack \
	http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.19.tar.gz \
	c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9

pbuild_apply_patches

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--enable-static \
	--disable-shared \
	--disable-nls

make -j$MAXJOBS
make -j$MAXJOBS DESTDIR=$DESTDIR install
