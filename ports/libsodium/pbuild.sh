# NaCl-based crypto library
# https://github.com/jedisct1/libsodium
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=1.0.20

pbuild_fetch_and_unpack \
    https://github.com/jedisct1/libsodium/releases/download/$VERSION-RELEASE/libsodium-$VERSION.tar.gz \
    ebb65ef6ca439333c2bb41a0c1990587288da07f6c7fd07cb3a18cc18d30ce19

pbuild_apply_patches

pbuild_configure_once ./configure \
    --build=$CBUILD \
    --host=$CHOST \
    --prefix=/usr \
    --datadir=/usr/share \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --disable-shared \
    --enable-static \

make -j$MAXJOBS install DESTDIR=$DESTDIR
