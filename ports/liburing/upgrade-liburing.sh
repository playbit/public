#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

USE_LATEST_SOURCE=${USE_LATEST_SOURCE:-1}
DOWNLOAD_ARGS=
if [ "$USE_LATEST_SOURCE" = 1 ]; then
  LIBURING_VERSION=$(git ls-remote https://github.com/axboe/liburing master | cut -f1)
  URL_PATH=$LIBURING_VERSION.tar.gz
else
  LIBURING_VERSION=$(grep -F 'LIBURING_VERSION := ' Makefile | cut -d' ' -f3)
  URL_PATH=refs/tags/liburing-$LIBURING_VERSION.tar.gz
  DOWNLOAD_ARGS="--sha256 456f5f882165630f0dc7b75e8fd53bd01a955d5d4720729b4323097e6e9f2a98"
fi
LIBURING_TAR=$DOWNLOAD/liburing-$LIBURING_VERSION.tar.gz
if [ ! -f /tmp/liburing-$LIBURING_VERSION/configure ]; then
  download -o "$LIBURING_TAR" ${DOWNLOAD_ARGS[@]} \
    "https://github.com/axboe/liburing/archive/$URL_PATH"
  rm -rf /tmp/liburing-$LIBURING_VERSION
  mkdir -p /tmp/liburing-$LIBURING_VERSION
  echo "Extracting $LIBURING_TAR"
  tar -C /tmp/liburing-$LIBURING_VERSION --strip-components=1 -xof "$LIBURING_TAR"
fi

_pushd /tmp/liburing-$LIBURING_VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}
  echo "——————— make clean > make-clean.log ———————"
  make clean > make-clean.log || true

  echo "——————— ./configure > configure-$arch.out ———————"
  ./configure \
    --cc="$TOOLCHAIN/bin/clang --target=$arch-playbit" \
    --cxx="$TOOLCHAIN/bin/clang++ --target=$arch-playbit" \
    --use-libc \
    --prefix=/usr \
    --libdir=/lib > configure.out

  grep -vE '^(#|libgcc_link_flag |CC |CXX )' configure.out > configure-$arch.out
  grep -vE '^(#|libgcc_link_flag=|CC=|CXX=)' config-host.mak > config-host-$arch.mak
  grep '^#' config-host.h > config-host-$arch.h

  echo "——————— make -C src > make-$arch.log 2> make-$arch-err.log ———————"
  make -C src ENABLE_SHARED=0 V=1 liburing.a > make-$arch.log 2> make-$arch-err.log

  # find sources
  grep -F ' -c ' make-$arch.log \
  | sed -E 's/^.+ ([^ ]+\.c)$/\1/' \
  | sort -u \
  > srcs-$arch

  # find cflags
  grep -F ' -c ' make-$arch.log \
  | sed -E 's/^.+\/clang (.+) -c .+$/\1/' \
  | sed -E 's/-MT ".+" -MMD -MP -MF ".+" //' \
  | sed -E 's/--target=[^ ]+ //' \
  | sort -u \
  > cflags-$arch

  echo "——————— make DESTDIR=install-$arch install > install-$arch.log ———————"
  rm -rf install-$arch
  mkdir install-$arch
  make V=1 DESTDIR=$PWD/install-$arch ENABLE_SHARED=0 install \
  > install-$arch.log \
  2> install-$arch-err.log
done

echo "checking if config-host.mak differs per arch..."
if ! diff -q config-host-aarch64.mak config-host-x86_64.mak; then
  echo "——————— diff -u config-host-{aarch64,x86_64}.mak ———————"
  diff -u config-host-aarch64.mak config-host-x86_64.mak
fi

echo "checking if config-host.h differs per arch..."
if ! diff -q config-host-aarch64.h config-host-x86_64.h; then
  echo "——————— diff -u config-host-{aarch64,x86_64}.h ———————"
  diff -u config-host-aarch64.h config-host-x86_64.h
fi

echo "checking if configure output differs per arch..."
if ! diff -q configure-aarch64.out configure-x86_64.out; then
  echo "——————— diff -u configure-{aarch64,x86_64}.out ———————"
  diff -u configure-aarch64.out configure-x86_64.out
fi

echo "checking if sources differs per arch..."
if ! diff -q srcs-aarch64 srcs-x86_64; then
  echo "——————— diff -u srcs-{aarch64,x86_64} ———————"
  diff -u srcs-aarch64 srcs-x86_64
fi

echo "checking if CFLAGS differs per arch..."
if ! diff -q cflags-aarch64 cflags-x86_64; then
  echo "——————— diff -u cflags-{aarch64,x86_64} ———————"
  diff -u cflags-aarch64 cflags-x86_64
fi

echo "——————— SRCS ———————"
tr ' ' '\n' < srcs-aarch64 | awk '{printf "  %s \\\n", $1}'

echo "——————— CFLAGS ———————"
sed -E 's/-include [^ ]+ //' cflags-aarch64 \
| tr ' ' '\n' \
| grep -v '^ *$' \
| awk '{printf "  %s \\\n", $1}'

grep -E '^#define' config-host.h | sort -u | sed -E 's/^#define (.+)$/  -D\1 \\/'

B=/tmp/liburing-$LIBURING_VERSION
_popd

echo "——————— Replacing current source at $PWD ———————"
find . -type f \
  -and -not -path ./Makefile \
  -and -not -path ./license.txt \
  -and -not -path ./upgrade-\*.sh \
  -delete
find . -type d -empty -delete
rm -rf $B/src/install-*
for f in $(cd $B && find src -type f \( -name \*.c -or -name \*.h \) ); do
  dst=${f:4} # src/foo/bar -> foo/bar
  mkdir -p $(dirname $dst)
  cp -v $B/$f $dst
done
cp -v $B/install-aarch64/usr/lib/pkgconfig/liburing.pc liburing.pc
cp -v $B/install-aarch64/usr/man/man7/io_uring.7       io_uring.7
