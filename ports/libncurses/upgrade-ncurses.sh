#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

VERSION=$(grep -F 'VERSION := ' Makefile | cut -d' ' -f3)

if [ ! -f /tmp/ncurses-$VERSION/configure ]; then
  TAR=ncurses-$VERSION.tgz
  download "https://invisible-mirror.net/archives/ncurses/current/$TAR" \
    --sha256 abf30fcb0f97706cb3f62703595c561515f6b7c257dce2e3c8dee7d83afdfa76
  rm -rf /tmp/ncurses-$VERSION
  mkdir -p /tmp/ncurses-$VERSION
  echo "Extracting $TAR"
  tar -C /tmp/ncurses-$VERSION --strip-components=1 -xof "$DOWNLOAD/$TAR"
fi

_pushd /tmp/ncurses-$VERSION

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
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    \
    --without-ada \
    --without-tests \
    --disable-termcap \
    --disable-root-access \
    --disable-rpath-hack \
    --disable-setuid-environ \
    --disable-stripping \
    --without-cxx-binding \
    --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo" \
    --enable-pc-files \
    --without-shared \
    --enable-widec \
    --without-manpages

  echo "————————— make 2> make-err.log | tee make.log —————————"
  make V=1 2> make-err.log | tee make.log

  echo "————————— make install DESTDIR=./install | tee install.log —————————"
  rm -rf install
  mkdir install
  make V=1 DESTDIR=$PWD/install install | tee install.log

  # Install basic terms in /etc/terminfo
  for i in \
    ansi console dumb linux vt100 vt102 \
    vt200 vt220 xterm xterm-color xterm-256color \
    tmux tmux-256color vte vte-256color screen screen-256color
  do
    for termfile in $(find install/usr/share/terminfo/ -name "$i" 2>/dev/null); do
      basedir=$(basename "$(dirname "$termfile")")
      mkdir -p install/etc/terminfo/$basedir
      mv "$termfile" install/etc/terminfo/$basedir/
    done
  done
  rm -rf install/usr/share/terminfo

  exit
done
