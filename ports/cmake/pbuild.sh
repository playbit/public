# build system
# https://www.cmake.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#!DEP ports/libcxx
#!DEP ports/libz
#!DEP ports/libzstd
#!DEP ports/libnghttp2
#!DEP ports/openssl [transitive]
#!DEP ports/xz
#!DEP ports/bzip2
#!DEP ports/libncurses
#
source /p/tools/pbuild.lib.sh

VERSION=3.30.2
VER2=${VERSION%.*}

pbuild_fetch_and_unpack \
	https://www.cmake.org/files/v$VER2/cmake-$VERSION.tar.gz \
	46074c781eccebc433e98f0bbfa265ca3fd4381f245ca3b140e7711531d60db2

pbuild_apply_patches

mkdir -p /tmp/cmake-doc

pbuild_configure_once \
	CFLAGS="$CFLAGS" \
	CXXFLAGS="$CXXFLAGS" \
	LDFLAGS="$LDFLAGS" \
	./bootstrap \
		--prefix= \
		--bindir=/bin \
		--mandir=/usr/share/man \
		--datadir=/usr/share/cmake \
		--xdgdatadir=/usr/share \
		--docdir=/tmp/cmake-doc \
		\
		--no-system-cppdap \
		--no-system-curl \
		--no-system-expat \
		--no-system-jsoncpp \
		--no-system-libarchive \
		--no-system-libuv \
		--no-system-librhash \
		\
		--system-bzip2 \
		--system-liblzma \
		--system-nghttp2 \
		--system-zlib \
		--system-zstd \
		\
		--parallel=$MAXJOBS \
		\
		-- \
		\
		-DZLIB_LIBRARY=$DESTDIR/lib/libz.a \
		-DZLIB_INCLUDE_DIR=$DESTDIR/usr/include \
		\
		-DZSTD_LIBRARY=$DESTDIR/lib/libzstd.a \
		-DZSTD_INCLUDE_DIR=$DESTDIR/usr/include \
		\
		-DNGHTTP2_LIBRARY=$DESTDIR/lib/libnghttp2.a \
		-DNGHTTP2_INCLUDE_DIR=$DESTDIR/usr/include \
		\
		-DBZIP2_LIBRARIES=$DESTDIR/lib/libbz2.a \
		-DBZIP2_INCLUDE_DIR=$DESTDIR/usr/include \
		\
		-DLIBLZMA_LIBRARY=$DESTDIR/lib/liblzma.a \
		-DLIBLZMA_INCLUDE_DIR=$DESTDIR/usr/include \


make -j$MAXJOBS
make -j$MAXJOBS DESTDIR=$DESTDIR install

# Note: cmake executable must be in the same prefix (parent) directory
# as its "modules" directory. I.e. /bin/cmake will look for /share/cmake,
# /foo/bar/bin/cmake will look for /foo/bar/share/cmake, and so on.
# The following error happens if cmake can't find its "support files":
#   CMake Error: Could not find CMAKE_ROOT !!!
#   CMake has most likely not been installed correctly.
#   Modules directory not found in
#   /share/cmake
#

# Test if cmake works
echo "testing if cmake works"
mkdir /tmp/cmake-test
cat << END > /tmp/cmake-test/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(HelloWorld)
add_executable(hello hello.c)
END
cat << END > /tmp/cmake-test/hello.c
#include <stdio.h>
int main() {
  printf("Hello, World!\n");
  return 0;
}
END
cd /tmp/cmake-test
$DESTDIR/bin/cmake .
