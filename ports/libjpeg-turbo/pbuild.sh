# Accelerated baseline JPEG compression and decompression library
# https://libjpeg-turbo.org/
# license: BSD-3-Clause, IJG, Zlib
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/cmake
#
#!DEP ports/libc
#
source /p/tools/pbuild.lib.sh

VERSION=3.0.3

pbuild_fetch_and_unpack \
	https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/$VERSION/libjpeg-turbo-$VERSION.tar.gz \
	343e789069fc7afbcdfe44dbba7dbbf45afa98a15150e079a38e60e44578865d

pbuild_apply_patches

CMAKE_ARGS=
if [ $ARCH != $NATIVE_ARCH ]; then
	CMAKE_ARGS="-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_HOST_SYSTEM_NAME=Linux"
	# workaround for a bug(?) in CMakeLists.txt 'string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} ...'
	CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_SYSTEM_PROCESSOR=$ARCH"
fi

pbuild_configure_once \
	cmake -B build \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=/lib \
		-DBUILD_SHARED_LIBS=False \
		-DENABLE_SHARED=False \
		-DENABLE_STATIC=True \
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DWITH_JPEG8=1 \
		$CMAKE_ARGS

cd build

# Testing disabled because it takes FOREVER to run.
# cmake --build .
# # random checksum failures
# ctest --output-on-failure \
# 	-E '(djpeg-shared-3x2-float-prog-cmp|example-12bit-shared-decompress-cmp)'

# Build only libturbojpeg and perform manual install.
# Note that running 'DESTDIR=$DESTDIR cmake --install .' will build all other programs
# and libs, which we don't need.
cmake --build . --target turbojpeg-static --parallel $NJOBS

install -v -D -m0644 libturbojpeg.a $DESTDIR/lib/libturbojpeg.a
install -v -D -m0644 pkgscripts/libturbojpeg.pc $DESTDIR/lib/pkgconfig/libturbojpeg.pc
install -v -D -m0644 ../turbojpeg.h $DESTDIR/usr/include/turbojpeg.h
