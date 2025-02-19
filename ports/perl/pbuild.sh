# perl -- Practical Extraction and Report Language
# https://www.perl.org/
#
# Note: BOOTSTRAP to avoid cyclic dependency: perl <- openssl <- curl
#!BOOTSTRAP
#!BUILDTOOL toolchain
#!DEP ports/libc
#!DEP ports/libz
#!DEP ports/bzip2
source /p/tools/pbuild.lib.sh

[ $ARCH = $NATIVE_ARCH ] || _err "cross-compling perl is not yet implemented"

VERSION=5.40.0

pbuild_fetch_and_unpack \
	https://www.cpan.org/src/5.0/perl-$VERSION.tar.gz \
	c740348f357396327a9795d3e8323bafd0fe8a5c7835fc1cbaba0cc8dfe7161f

pbuild_apply_patches

# ensure that we never accidentally bundle zlib or bzip2
rm -rf cpan/Compress-Raw-Zlib/zlib-src
rm -rf cpan/Compress-Raw-Bzip2/bzip2-src
sed -i '/\(bzip2\|zlib\)-src/d' MANIFEST

_privlib=/usr/share/perl5/core_perl
_archlib=/lib/perl5/core_perl

export BUILD_ZLIB=0
export BUILD_BZIP2=0
export BZIP2_LIB=$DESTDIR/lib
export BZIP2_INCLUDE=$DESTDIR/usr/include
export ZLIB_LIB=$DESTDIR/lib
export ZLIB_INCLUDE=$DESTDIR/usr/include

pbuild_configure_once ./Configure \
	-des \
	-Dcccdlflags='-fPIC' \
	-Dccdlflags='-rdynamic' \
	-Dprefix=/usr \
	-Dlibdir=/lib \
	-Dbindir=/bin \
	-Dprivlib=$_privlib \
	-Darchlib=$_archlib \
	-Dvendorprefix=/usr \
	-Dvendorlib=/usr/share/perl5/vendor_perl \
	-Dvendorarch=/lib/perl5/vendor_perl \
	-Dsiteprefix=/usr \
	-Dsitelib=/usr/share/perl5/site_perl \
	-Dsitearch=/lib/perl5/site_perl \
	-Dlocincpth='/usr/include' \
	-Doptimize="$CFLAGS" \
	-Duselargefiles \
	-Dusethreads \
	-Duseshrplib \
	-Dd_semctl_semun \
	-Dman1dir=/usr/share/man/man1 \
	-Dman3dir=/usr/share/man/man3 \
	-Dinstallman1dir=/usr/share/man/man1 \
	-Dinstallman3dir=/usr/share/man/man3 \
	-Dman1ext='1' \
	-Dman3ext='3pm' \
	-Dcf_by='Playbit' \
	-Ud_csh \
	-Ud_fpos64_t \
	-Ud_off64_t \
	-Dusenm \
	-Duse64bitint \
	-Dlibpth='/lib' \
	-Dlibspath=' /lib' \
	-Dusrinc='/usr/include'

make -j$MAXJOBS libperl.so || _err "'make libperl.so' failed"
make -j$MAXJOBS || _err "'make' failed"

# install into temporary directory and then copy only what we need
IDIR=$PWD/install_tmp
mkdir -p $IDIR/usr $IDIR/bin
ln -sfT ../bin $IDIR/usr/bin
ln -sfT ../lib $IDIR/usr/lib
make -j$MAXJOBS install DESTDIR=$IDIR || _err "'make install' failed"

mkdir -p $DESTDIR/lib $DESTDIR/bin $DESTDIR/usr/share

rm -rf $DESTDIR/lib/perl5
rm -rf $IDIR/lib/perl5/core_perl/CORE/*.h
mv -v $IDIR/lib/perl5 $DESTDIR/lib/perl5

mv -v $IDIR/bin/perl${VERSION} $DESTDIR/bin/perl${VERSION}
ln -sfv perl${VERSION} $DESTDIR/bin/perl

for exe in enc2xs h2xs perldoc perlivp pod2html pod2man pod2text pod2usage podchecker; do
	mv -v $IDIR/bin/$exe $DESTDIR/bin/$exe
done

# Remove development files
rm -rf ${IDIR}$_privlib/Encode
# rm -rf ${DESTDIR}$_archlib/Devel
# rm -rf $DESTDIR/bin/{h2xs,perlivp,enc2xs,xsubpp}
# rm -rf $DESTDIR/lib/perl5/core_perl/CORE/*.h

rm -rf $DESTDIR/usr/share/perl5
mv -v $IDIR/usr/share/perl5 $DESTDIR/usr/share/perl5

# omit global flto afterward
# perl saves compile-time cflags and applies them to every future build
sed -i -e "s| -flto=thin||g" $DESTDIR/lib/perl5/core_perl/Config_heavy.pl

# test if it works
if [ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ]; then
	chroot $DESTDIR /bin/perl --version | head -n2 | tail -n1
fi
