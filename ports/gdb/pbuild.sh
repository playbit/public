# GNU debugger
# https://www.sourceware.org/gdb/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#!DEP ports/libcxx
#!DEP ports/python
#!DEP ports/libgmp
#!DEP ports/libmpfr
#!DEP ports/libncurses
#!DEP ports/libz
#
source /p/tools/pbuild.lib.sh

VERSION=14.2

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/gdb/gdb-$VERSION.tar.xz \
	2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772

pbuild_apply_patches

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
		--disable-nls \
		--disable-werror \
		--with-python=$DESTDIR/usr/bin/python \
		--with-python-libdir=$DESTDIR/lib \
		--with-system-zlib \
		--with-system-gdbinit=/etc/gdbinit \
		--enable-compressed-debug-sections=all \
		--enable-default-compressed-debug-sections-algorithm=zlib \
		--enable-lto

make -j$MAXJOBS

# Note: testing disabled because it requires GNU Check to be installed
# [ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] && make -j$MAXJOBS check

make -j$MAXJOBS install DESTDIR=$DESTDIR

rm -f $DESTDIR/bin/run
strip $DESTDIR/bin/gdb
strip $DESTDIR/bin/gdbserver
strip $DESTDIR/lib/libinproctrace.so

# remove development files
for path in \
    /lib/libbfd.a \
    /lib/libbfd.la \
    /lib/libctf-nobfd.a \
    /lib/libctf-nobfd.la \
    /lib/libctf.a \
    /lib/libctf.la \
    /lib/libopcodes.a \
    /lib/libopcodes.la \
    /lib/libsframe.a \
    /lib/libsframe.la \
    /lib/libsim.a \
    /usr/include/ansidecl.h \
    /usr/include/bfd.h \
    /usr/include/bfdlink.h \
    /usr/include/ctf-api.h \
    /usr/include/ctf.h \
    /usr/include/diagnostics.h \
    /usr/include/dis-asm.h \
    /usr/include/gdb/jit-reader.h \
    /usr/include/plugin-api.h \
    /usr/include/sframe-api.h \
    /usr/include/sframe.h \
    /usr/include/sim/callback.h \
    /usr/include/sim/sim.h \
    /usr/include/symcat.h \
;do
	rm -f ${DESTDIR}$path
done

# remove empty directories
find $DESTDIR/usr/include/sim -empty -type d -delete
find $DESTDIR/usr/include/gdb -empty -type d -delete
