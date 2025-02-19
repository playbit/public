#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

LLVM_VERSION=17.0.3
LIBCXX_ABI_VERSION=1
LIBCXX=$BUILD_DIR/libcxx-$LLVM_VERSION
LIBCXXABI=$BUILD_DIR/libcxxabi-$LLVM_VERSION
LIBUNWIND=$BUILD_DIR/libunwind-$LLVM_VERSION

_fetch_source() { # <component> <sha256>
  local COMPONENT=$1
  local SHA256=$2
  local SRCDIR=$BUILD_DIR/$COMPONENT-$LLVM_VERSION
  local TAR=$COMPONENT-$LLVM_VERSION.src.tar.xz
  if [ -d "$SRCDIR" ]; then
    echo "Using $SRCDIR"
  else
    download -o "$DOWNLOAD/$TAR" \
      --sha256 "$SHA256" \
      "https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVM_VERSION/$TAR"
    echo "Extracting $DOWNLOAD/$TAR to $SRCDIR"
    rm -rf "$SRCDIR"
    mkdir -p "$SRCDIR"
    tar -C "$SRCDIR" --strip-components=1 -xJof "$DOWNLOAD/$TAR"
  fi
}

_fetch_source libcxx    8bde61132a396ae33df4f8c4ba092a3a0edd0139318e2f7c64ca522b26842584
_fetch_source libcxxabi 30c04d6fd2d554b209de7deee6c24275aeb5269f0df1ca2e3b25169679b7fad8
_fetch_source libunwind fbd663c0bdbbb1be7d628529394339c4c3ef9cfd9f02779bb15e540ec9821844

LIBUNWIND_OUT=/tmp/libunwind-out
rm -rf $LIBUNWIND_OUT
cp -R $LIBUNWIND/src $LIBUNWIND_OUT
cp -R $LIBUNWIND/include $LIBUNWIND_OUT/include
cp $LIBUNWIND/CMakeLists.txt $LIBUNWIND_OUT/libunwind.cmake
rm $LIBUNWIND_OUT/*AIXExtras*

LIBCXXABI_OUT=/tmp/libcxxabi-out
rm -rf $LIBCXXABI_OUT
cp -R $LIBCXXABI/src $LIBCXXABI_OUT
cp -RT $LIBCXXABI/include $LIBCXXABI_OUT/include
cp $LIBCXXABI/CMakeLists.txt $LIBCXXABI_OUT/libcxxabi.cmake
rm $LIBCXXABI_OUT/demangle/cp-to-llvm.sh
rm $LIBCXXABI_OUT/demangle/.clang-format

LIBCXX_OUT=/tmp/libcxx-out
rm -rf $LIBCXX_OUT
cp -R $LIBCXX/src $LIBCXX_OUT
cp -R $LIBCXX/include $LIBCXX_OUT/include.c++.v1
cp $LIBCXX/CMakeLists.txt $LIBCXX_OUT/libcxx.cmake
rm $LIBCXX_OUT/pstl/libdispatch.cpp
rm $LIBCXX_OUT/filesystem/int128_builtins.cpp # non-compiler-rt
rm -r $LIBCXX_OUT/experimental
rm -r $LIBCXX_OUT/support/win32
rm -r $LIBCXX_OUT/support/ibm
rm    $LIBCXX_OUT/include.c++.v1/CMakeLists.txt
rm -r $LIBCXX_OUT/include.c++.v1/__support/android
rm -r $LIBCXX_OUT/include.c++.v1/__support/fuchsia
rm -r $LIBCXX_OUT/include.c++.v1/__support/ibm
rm -r $LIBCXX_OUT/include.c++.v1/__support/newlib
rm -r $LIBCXX_OUT/include.c++.v1/__support/openbsd
rm -r $LIBCXX_OUT/include.c++.v1/__support/win32
rm -r $LIBCXX_OUT/include.c++.v1/__support/xlocale

LIBUNWIND_DESTDIR=$(realpath ..)/libunwind
LIBCXXABI_DESTDIR=$(realpath ..)/libcxxabi
LIBCXX_DESTDIR=$PWD

echo "Replacing current source at $LIBUNWIND_DESTDIR"
cd "$LIBUNWIND_DESTDIR"
find . -type f -and -not -path ./Makefile -delete
find . -type d -empty -delete
cp -RT $LIBUNWIND_OUT .

echo "Replacing current source at $LIBCXXABI_DESTDIR"
cd "$LIBCXXABI_DESTDIR"
find . -type f -and -not -path ./Makefile -delete
find . -type d -empty -delete
cp -RT $LIBCXXABI_OUT .

echo "Replacing current source at $LIBCXX_DESTDIR"
cd "$LIBCXX_DESTDIR"
find . -type f \
  -and -not -path ./Makefile \
  -and -not -path ./upgrade-\*.sh \
  -and -not -path ./include.c++.v1/__config_site \
  -delete
find . -type d -empty -delete
cp -RT $LIBCXX_OUT .
mv include.c++.v1/__config_site.in __config_site.in

cat << END
——————————————————————————————————————————————————————————————————————
    Done copying new sources for: libunwind, libcxxabi, libcxx

Next steps:

1. Review changes and update Makefile if needed
   git diff -- $LIBUNWIND_DESTDIR
   git diff -- $LIBCXXABI_DESTDIR
   git diff -- $LIBCXX_DESTDIR

2. Look at __config_site.in and see if there are any changes
     compared to __config_site.ARCH.in

3. Test build
   make -j$(nproc) -C $LIBUNWIND_DESTDIR
   make -j$(nproc) -C $LIBCXXABI_DESTDIR
   make -j$(nproc) -C $LIBCXX_DESTDIR

——————————————————————————————————————————————————————————————————————
END
