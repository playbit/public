# Diagnostic, debugging and instructional userspace tracer
# https://strace.io/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!DEP ports/libc [transitive]
#
# Note: The Alpine port of strace states "strace with libunwind doesn't work right on musl"
# We should test ours to see if we have the same issue.
#
# Note: We statically link libc into strace so that it is completely portable
# and can be used to diagnose issues in scenarios with a missing or broken libc.so.
#
source /p/tools/pbuild.lib.sh

VERSION=6.10

pbuild_fetch_and_unpack \
	https://github.com/strace/strace/releases/download/v$VERSION/strace-$VERSION.tar.xz \
	765ec71aa1de2fe37363c1e40c7b7669fc1d40c44bb5d38ba8e8cd82c4edcf07

pbuild_apply_patches

pbuild_configure_once \
	./configure \
		LDFLAGS="$LDFLAGS -static" \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-mpers=no \
		--disable-gcc-Werror

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR
[ -n "$DEBUG" ] || strip $DESTDIR/bin/strace
