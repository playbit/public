# less is more -- a file pager
# https://www.greenwoodsoftware.com/less/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#!DEP ports/libncurses [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=661

pbuild_fetch_and_unpack \
	https://www.greenwoodsoftware.com/less/less-$VERSION.tar.gz \
	2b5f0167216e3ef0ffcb0c31c374e287eb035e4e223d5dae315c2783b6e738ed

pbuild_configure_once \
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--bindir=/bin \
		--libdir=/lib \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var

make -j$MAXJOBS
strip -s less lessecho lesskey
make -j$MAXJOBS install DESTDIR=$DESTDIR
