# BSD line editing library
# https://www.thrysoee.dk/editline
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libncurses [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=20240808-3.1

pbuild_fetch_and_unpack \
	https://www.thrysoee.dk/editline/libedit-$VERSION.tar.gz \
	5f0573349d77c4a48967191cdd6634dd7aa5f6398c6a57fe037cc02696d6099f

pbuild_configure_once \
	CFLAGS="$CFLAGS -D__STDC_ISO_10646__" \
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--disable-shared

make -j$MAXJOBS
[ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] && make -j$MAXJOBS check
make -j$MAXJOBS install DESTDIR=$DESTDIR

# remove libtool file
rm -f $DESTDIR/lib/libedit.la
