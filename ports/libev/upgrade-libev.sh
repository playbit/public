#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

LIBEV_VERSION=$(grep -F 'LIBEV_VERSION := ' Makefile | cut -d' ' -f3)
LIBEV_TAR=$DOWNLOAD/libev-$LIBEV_VERSION.tar.gz

if [ ! -f /tmp/libev-$LIBEV_VERSION/configure ]; then
  download -o "$LIBEV_TAR" \
    --sha256 507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea \
    "http://dist.schmorp.de/libev/Attic/libev-$LIBEV_VERSION.tar.gz"
  rm -rf /tmp/libev-$LIBEV_VERSION
  mkdir -p /tmp/libev-$LIBEV_VERSION
  echo "Extracting $LIBEV_TAR"
  tar -C /tmp/libev-$LIBEV_VERSION --strip-components=1 -xof "$LIBEV_TAR"
fi

_pushd /tmp/libev-$LIBEV_VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}

  echo "————————— ./configure ($arch) —————————"
  ./configure \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --with-sysroot=$DISTROOT \
    CC=$TOOLCHAIN/bin/clang \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit" \
    LDFLAGS="-L$DISTROOT/lib" \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static

  echo "————————— make 2> make-err.log —————————"
  make V=1 2> make-err.log

  echo "————————— make install DESTDIR=./install —————————"
  rm -rf install
  mkdir install
  make V=1 DESTDIR=$PWD/install install

done
