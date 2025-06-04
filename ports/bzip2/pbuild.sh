# bzip2 -- A high-quality data compression program
# http://sources.redhat.com/bzip2
#
#!BOOTSTRAP
#!BUILDTOOL toolchain
#!DEP ports/libc
source /p/tools/pbuild.lib.sh

VERSION=1.0.8

pbuild_fetch_and_unpack \
    https://files.playb.it/mirror/bzip2-$VERSION.tar.gz \
    ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269

pbuild_apply_patches

# Fix man path: Generate relative symlinks
sed -i \
    -e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
    -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' \
    Makefile

# fixup broken version stuff
sed -i \
    -e "s:1\.0\.4:$VERSION:" \
    bzip2.1 bzip2.txt Makefile-libbz2_so manual.*

make -j$MAXJOBS CC=cc

[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] &&
    make CC=cc check >/dev/null

# make install fails if run twice from ...
#   ln -s bzip2.1 /distroot/usr/share/man/man1/bunzip2.1
#   ln: /distroot/usr/share/man/man1/bunzip2.1: File exists
# ... so we remove the symlinks first if they exist.
rm -f $DESTDIR/usr/share/man/man1/bunzip2.1 \
      $DESTDIR/usr/share/man/man1/bzcat.1 \
      $DESTDIR/usr/share/man/man1/bzip2recover.1 \
      $DESTDIR/bin/bzcmp \
      $DESTDIR/bin/bzegrep \
      $DESTDIR/bin/bzfgrep \
      $DESTDIR/bin/bzless

# make sure $DESTDIR/usr/bin & lib are symlinks
if [ ! -L $DESTDIR/usr/bin ]; then
    rm -rf $DESTDIR/usr/bin
    ln -s ../bin $DESTDIR/usr/bin
fi
if [ ! -L $DESTDIR/usr/lib ]; then
    rm -rf $DESTDIR/usr/lib
    ln -s ../lib $DESTDIR/usr/lib
fi

# TODO: Figure out a way to install into /bin & /lib and not have to rely on symlinks from rootfs
make CC=cc DESTDIR=$DESTDIR PREFIX=$DESTDIR/usr install
