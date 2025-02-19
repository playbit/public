#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

VERSION=$(grep -F 'VERSION := ' Makefile | cut -d' ' -f3)
LIBELF_SRCDIR=$PWD

if [ ! -f /tmp/libelf-$VERSION/configure ]; then
  TAR=$DOWNLOAD/libelf-$VERSION.tar.bz2
  download -o "$TAR" \
    --sha256 df76db71366d1d708365fc7a6c60ca48398f14367eb2b8954efc8897147ad871 \
    "https://sourceware.org/elfutils/ftp/$VERSION/elfutils-$VERSION.tar.bz2"
  rm -rf /tmp/libelf-$VERSION
  mkdir -p /tmp/libelf-$VERSION
  echo "Extracting $TAR"
  tar -C /tmp/libelf-$VERSION --strip-components=1 -xof "$TAR"
fi

_pushd /tmp/libelf-$VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}

  ARGP_INCDIR=$SRCDIR/libelf/argp-standalone/include
  ARGP_LIBDIR=$BUILD_DIR/libelf-$VERSION-$arch
  if [ ! -f $ARGP_LIBDIR/libargp.a ]; then
    echo "————————— make -C $SRCDIR/libelf ARCH=$arch argp —————————"
    make -C $SRCDIR/libelf ARCH=$arch argp
  fi

  OBSTACK_INCDIR=$SRCDIR/libelf/musl-obstack
  OBSTACK_LIBDIR=$BUILD_DIR/libelf-$VERSION-$arch
  if [ ! -f $OBSTACK_LIBDIR/musl-obstack.a ]; then
    echo "————————— make -C $SRCDIR/libelf ARCH=$arch obstack —————————"
    make -C $SRCDIR/libelf ARCH=$arch obstack
  fi

  echo "————————— make clean > make-clean.log —————————"
  make clean > make-clean.log || true

  echo "————————— ./configure ($arch) —————————"
  ./configure \
    CC=$TOOLCHAIN/bin/clang \
    CXX=$TOOLCHAIN/bin/clang++ \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit -I$ARGP_INCDIR -I$OBSTACK_INCDIR" \
    LDFLAGS="-L$DISTROOT/lib -L$ARGP_LIBDIR -L$OBSTACK_LIBDIR -lmusl-obstack" \
    PKG_CONFIG_LIBDIR=$DISTROOT/lib/pkgconfig \
    PKG_CONFIG_PATH=$DISTROOT/lib/pkgconfig \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    \
    --disable-dependency-tracking \
    --disable-demangler \
    --disable-textrelcheck \
    --disable-nls \
    --disable-libdebuginfod \
    --disable-debuginfod \
    --with-zstd ZSTD_COMPRESS_LIBS=-lzstd

  cp -v config.h $LIBELF_SRCDIR/config.h
  cp -v config/libelf.pc $LIBELF_SRCDIR/libelf.pc
  # cp -v doc/elf_*.3 $LIBELF_SRCDIR/

  exit 0
done
