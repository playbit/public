#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

BROTLI_VERSION=$(grep -F 'BROTLI_VERSION := ' Makefile | cut -d' ' -f3)
BROTLI_TAR=$DOWNLOAD/brotli-$BROTLI_VERSION.tar.xz

if [ ! -f /tmp/brotli-$BROTLI_VERSION/CMakeLists.txt ]; then
  download -o "$BROTLI_TAR" \
    --sha256 e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff \
    "https://github.com/google/brotli/archive/refs/tags/v$BROTLI_VERSION.tar.gz"
  rm -rf /tmp/brotli-$BROTLI_VERSION
  mkdir -p /tmp/brotli-$BROTLI_VERSION
  echo "Extracting $BROTLI_TAR"
  tar -C /tmp/brotli-$BROTLI_VERSION --strip-components=1 -xof "$BROTLI_TAR"
fi

if ! command -v cmake >/dev/null; then echo "apk add cmake" && apk add cmake; fi
if ! command -v ninja >/dev/null; then echo "apk add samurai" && apk add samurai; fi

_pushd /tmp/brotli-$BROTLI_VERSION

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}

  echo "————————— cmake -B build-$arch -G Ninja —————————"
  CFLAGS="--target=$arch-playbit"
  LDFLAGS="--target=$arch-playbit"
  rm -rf build-$arch
  cmake -B build-$arch -G Ninja \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX= \
    -DBUILD_SHARED_LIBS=OFF \
    \
    -DCMAKE_SYSROOT="$DISTROOT" \
    \
    -DCMAKE_C_COMPILER="$TOOLCHAIN/bin/clang" \
    -DCMAKE_CXX_COMPILER="$TOOLCHAIN/bin/clang++" \
    -DCMAKE_ASM_COMPILER="$TOOLCHAIN/bin/clang" \
    -DCMAKE_AR="$TOOLCHAIN/bin/ar" \
    -DCMAKE_RANLIB="$TOOLCHAIN/bin/ranlib" \
    -DCMAKE_LINKER="$TOOLCHAIN/bin/ld" \
    \
    -DCMAKE_C_FLAGS="$CFLAGS" \
    -DCMAKE_CXX_FLAGS="$CFLAGS" \
    -DCMAKE_ASM_FLAGS="$CFLAGS" \
    -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
    -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
    -DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS" \
    \
    -DCMAKE_C_COMPILER_TARGET=$arch-playbit \
    -DCMAKE_CXX_COMPILER_TARGET=$arch-playbit \
    -DCMAKE_ASM_COMPILER_TARGET=$arch-playbit

  echo "————————— ninja -C build-$arch -v | tee build-$arch/build.log —————————"
  ninja -C build-$arch -v | tee build-$arch/build.log

  echo "————————— install -> $PWD/install-$arch —————————"
  DESTDIR="$PWD/install-$arch" cmake --install build-$arch

done
