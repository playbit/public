#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

CARES_VERSION=$(grep -F 'CARES_VERSION := ' Makefile | cut -d' ' -f3)
CARES_TAR=$DOWNLOAD/cares-$CARES_VERSION.tar.gz

if [ ! -f /tmp/cares-$CARES_VERSION/configure ]; then
  download -o "$CARES_TAR" \
    --sha256 6fea2aac6a4610fbd0400afb0bcddbe7258a64c63f1f68e5855ebc0c659710cd \
    "https://cares.org/download/cares-$CARES_VERSION.tar.gz"
  rm -rf /tmp/cares-$CARES_VERSION
  mkdir -p /tmp/cares-$CARES_VERSION
  echo "Extracting $CARES_TAR"
  tar -C /tmp/cares-$CARES_VERSION --strip-components=1 -xof "$CARES_TAR"
fi

_pushd /tmp/cares-$CARES_VERSION

for arch in aarch64 x86_64; do
  echo "Configuring for $arch"

  echo "————————— ./configure —————————"

  ./configure \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    CC=$TOOLCHAIN/bin/clang \
    CXX=$TOOLCHAIN/bin/clang++ \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit" \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --disable-tests \
    --with-sysroot=${DISTROOT_PREFIX}$arch

  exit 0 # TODO

  echo "————————— make install DESTDIR=./install —————————"
  mkdir install
  make V=1 DESTDIR=$PWD/install install

done
