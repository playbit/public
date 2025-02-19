#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

CURL_VERSION=$(grep -F 'CURL_VERSION := ' Makefile | cut -d' ' -f3)
CURL_TAR=$DOWNLOAD/curl-$CURL_VERSION.tar.xz

if [ ! -f /tmp/curl-$CURL_VERSION/configure ]; then
  download -o "$CURL_TAR" \
    --sha256 6fea2aac6a4610fbd0400afb0bcddbe7258a64c63f1f68e5855ebc0c659710cd \
    "https://curl.se/download/curl-$CURL_VERSION.tar.xz"
  rm -rf /tmp/curl-$CURL_VERSION
  mkdir -p /tmp/curl-$CURL_VERSION
  echo "Extracting $CURL_TAR"
  tar -C /tmp/curl-$CURL_VERSION --strip-components=1 -xof "$CURL_TAR"
fi

_pushd /tmp/curl-$CURL_VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}
  echo "————————— make clean > make-clean.log —————————"
  make clean > make-clean.log || true

  echo "————————— ./configure ($arch) —————————"
  ./configure \
    CC=$TOOLCHAIN/bin/clang \
    CXX=$TOOLCHAIN/bin/clang++ \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit" \
    LDFLAGS="-L$DISTROOT/lib" \
    PKG_CONFIG_LIBDIR=$DISTROOT/lib/pkgconfig \
    PKG_CONFIG_PATH=$DISTROOT/lib/pkgconfig \
    --with-sysroot=$DISTROOT \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    --enable-optimize \
    --enable-static \
    --disable-shared \
    --enable-ipv6 \
    --enable-unix-sockets \
    --enable-websockets \
    --enable-ares=$DISTROOT \
    --with-openssl=$DISTROOT \
    --with-nghttp2=$DISTROOT \
    --with-nghttp2=$DISTROOT \
    --disable-ldap \
    --disable-ldaps \
    --disable-rtsp \
    --disable-proxy \
    --disable-dict \
    --disable-telnet \
    --disable-pop3 \
    --disable-imap \
    --disable-smb \
    --disable-smtp \
    --disable-gopher \
    --disable-manual \
    --without-libssh2 \
    --enable-progress-meter \
    --with-ca-bundle=/etc/ssl/cert.pem \
    --with-ca-fallback

  echo "————————— make 2> make-err.log | tee make.log —————————"
  make V=1 2> make-err.log | tee make.log

  echo "————————— make install DESTDIR=./install | tee install.log —————————"
  rm -rf install
  mkdir install
  make V=1 DESTDIR=$PWD/install install | tee install.log

  exit
done
