#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

NGHTTP2_VERSION=$(grep -F 'NGHTTP2_VERSION := ' Makefile | cut -d' ' -f3)
NGHTTP2_TAR=$DOWNLOAD/nghttp2-$NGHTTP2_VERSION.tar.xz

if [ ! -f /tmp/nghttp2-$NGHTTP2_VERSION/configure ]; then
  download -o "$NGHTTP2_TAR" \
    --sha256 c0e660175b9dc429f11d25b9507a834fb752eea9135ab420bb7cb7e9dbcc9654 \
    "https://github.com/nghttp2/nghttp2/releases/download/v$NGHTTP2_VERSION/nghttp2-$NGHTTP2_VERSION.tar.xz"
  rm -rf /tmp/nghttp2-$NGHTTP2_VERSION
  mkdir -p /tmp/nghttp2-$NGHTTP2_VERSION
  echo "Extracting $NGHTTP2_TAR"
  tar -C /tmp/nghttp2-$NGHTTP2_VERSION --strip-components=1 -xof "$NGHTTP2_TAR"
fi

_pushd /tmp/nghttp2-$NGHTTP2_VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}
  echo "————————— make clean —————————"
  make clean || true

  echo "————————— ./configure ($arch) —————————"
  ./configure \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    CC=$TOOLCHAIN/bin/clang \
    CXX=$TOOLCHAIN/bin/clang++ \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit" \
    LDFLAGS="-L$DISTROOT/lib" \
    PKG_CONFIG_LIBDIR=$DISTROOT/lib/pkgconfig \
    PKG_CONFIG_PATH=$DISTROOT/lib/pkgconfig \
    --disable-dependency-tracking \
    --disable-examples \
    --disable-http3 \
    --disable-werror \
    --disable-assert \
    --disable-failmalloc \
    --disable-shared \
    --enable-static \
    --enable-threads \
    --disable-app \
    --with-libcares \
    --with-libev \
    --with-openssl \
    --without-jansson \
    --without-jemalloc \
    --without-libbpf \
    --without-libnghttp3 \
    --without-libngtcp2 \
    --without-libxml2 \
    --without-mruby \
    --without-neverbleed \
    --without-systemd \
    --without-cunit \
    ZLIB_LIBS="-lz" \
    OPENSSL_LIBS="-lssl -lcrypto" \
    LIBCARES_LIBS="-lcares" \
    LIBEV_LIBS="-lev" \

  echo "————————— make 2> make-err.log | tee make.log —————————"
  make V=1 2> make-err.log | tee make.log

  echo "————————— make install DESTDIR=./install | tee install.log —————————"
  rm -rf install
  mkdir install
  make V=1 DESTDIR=$PWD/install install | tee install.log

  exit

done
