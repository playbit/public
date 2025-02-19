# GNU tool for automatically configuring source code
# https://www.gnu.org/software/autoconf
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/perl
#!BUILDTOOL ports/m4
#
#!DEP ports/m4 [transitive]
#!DEP ports/perl [transitive]
#
source /p/tools/pbuild.lib.sh

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz \
	afb181a76e1ee72832f6581c0eddf8df032b83e2e0239ef79ebedc4467d92d6e

pbuild_configure_once \
	M4=/bin/m4 \
	./configure \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR
