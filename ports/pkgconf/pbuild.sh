# development framework configuration tools
# https://gitea.treehouse.systems/ariadne/pkgconf
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#
#!ENV PKG_CONFIG_LIBDIR=${DESTDIR}/lib/pkgconfig
#
source /p/tools/pbuild.lib.sh

VERSION=2.3.0

pbuild_fetch_and_unpack \
	https://distfiles.ariadne.space/pkgconf/pkgconf-$VERSION.tar.xz \
	3a9080ac51d03615e7c1910a0a2a8df08424892b5f13b0628a204d3fcce0ea8b

pbuild_configure_once ./configure \
  --host=$CHOST \
  --prefix=/usr \
  --bindir=/bin \
  --libdir=/lib \
  --sysconfdir=/etc \
  --mandir=/usr/share/man \
  --localstatedir=/var \
  --disable-shared \
  --enable-static \
  --with-pkg-config-dir=/lib/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig

make -j$MAXJOBS

# Manual install instead of 'make install' since we only want /bin/pkgconf.
# make -j$MAXJOBS install DESTDIR=$DESTDIR
install -D -m644 man/pkgconf.1 $DESTDIR/usr/share/man/man1/pkgconf.1
install -D -m644 pkg.m4        $DESTDIR/usr/share/aclocal/pkg.m4
install -D -s -m755 pkgconf    $DESTDIR/bin/pkgconf
ln -sf pkgconf                 $DESTDIR/bin/pkg-config
