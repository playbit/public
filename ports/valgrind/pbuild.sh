# Tool to help find memory-management problems in programs
# https://valgrind.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/perl if HERMETIC
#
#!DEP ports/libc [transitive]
#
# libc++ needed for 'make check'
#!DEP ports/libcxx
#
source /p/tools/pbuild.lib.sh

VERSION=3.24.0

pbuild_fetch_and_unpack \
	https://sourceware.org/pub/valgrind/valgrind-$VERSION.tar.bz2 \
	71aee202bdef1ae73898ccf7e9c315134fa7db6c246063afc503aef702ec03bd

pbuild_apply_patches

# valgrind expects cc to be gcc and unconditionally passes -lgcc to LDFLAGS
if [ ! -f xlib/libgcc.a ]; then
	mkdir -p xlib
	ln -s $($CC $CFLAGS --print-libgcc-file-name) xlib/libgcc.a
fi
export LDFLAGS="$LDFLAGS -L$PWD/xlib -lc"

# Note: 'make check' requires NDEBUG to NOT be defined
export CFLAGS="${CFLAGS/-DNDEBUG} -fno-stack-protector -U_FORTIFY_SOURCE"
export CXXFLAGS="${CXXFLAGS/-DNDEBUG}"

# --enable-silent-rules enables us to set V=1 (-DV=1 in pbuild) for verbose output
pbuild_configure_once \
	./configure \
		--host=$CHOST \
		--build=$CBUILD \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-silent-rules \
		--without-mpicc

# Build
make -j$MAXJOBS

# Test when pbuild is invoked with '--enable-tests' (takes a very long time)
[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] && make check

# Install
make -j$MAXJOBS install DESTDIR=$DESTDIR
