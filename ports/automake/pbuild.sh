# GNU tool for automatically creating Makefiles
# https://www.gnu.org/software/automake
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/perl
#!BUILDTOOL ports/autoconf
#
#!DEP ports/perl [transitive]
#
source /p/tools/pbuild.lib.sh

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz \
	397767d4db3018dd4440825b60c64258b636eaf6bf99ac8b0897f06c89310acd

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
