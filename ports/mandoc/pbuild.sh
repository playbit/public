# mandoc provides /bin/man (which doesn't need nroff, unlike busybox's "man")
# https://mandoc.bsd.lv/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/perl
# perl needed for tests with "make regress"
#
#!DEP ports/libc [transitive]
#!DEP ports/libz
source /p/tools/pbuild.lib.sh

VERSION=1.14.6

pbuild_fetch_and_unpack \
	https://mandoc.bsd.lv/snapshots/mandoc-$VERSION.tar.gz \
	8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c

pbuild_apply_patches

# See configure.local.example
cat <<END > configure.local
PREFIX=/usr
MANDIR=/usr/share/man
LIBDIR=/lib
BINDIR=/bin
SBINDIR=/sbin
CFLAGS="$CFLAGS"
LDFLAGS="$LDFLAGS -ffat-lto-objects"
UTF8_LOCALE="en_US.UTF-8"
MANPATH_DEFAULT="/usr/share/man"
MANPATH_BASE="/usr/share/man"
LN="ln -sf"
OSNAME="Playbit"
HAVE_WCHAR=1
END

# If we are cross compiling, avoid failing configure tests.
# (Found by configuring for native arch with './configure && cat /build/mandoc/config.log')
cat <<END >> configure.local
HAVE_ATTRIBUTE=1
HAVE_CMSG=1
HAVE_DIRENT_NAMLEN=0
HAVE_EFTYPE=0
HAVE_ENDIAN=1
HAVE_ERR=1
HAVE_FTS=1
HAVE_FTS_COMPARE_CONST=0
HAVE_GETLINE=1
HAVE_GETSUBOPT=1
HAVE_ISBLANK=1
HAVE_MKDTEMP=1
HAVE_MKSTEMPS=1
HAVE_NANOSLEEP=1
HAVE_NTOHL=1
HAVE_O_DIRECTORY=1
HAVE_OHASH=0
HAVE_PATH_MAX=1
HAVE_PLEDGE=0
HAVE_PROGNAME=0
HAVE_REALLOCARRAY=1
HAVE_RECALLOCARRAY=0
HAVE_RECVMSG=1
HAVE_REWB_BSD=0
HAVE_REWB_SYSV=1
HAVE_SANDBOX_INIT=0
HAVE_STRCASESTR=1
HAVE_STRINGLIST=0
HAVE_STRLCAT=1
HAVE_STRLCPY=1
HAVE_STRNDUP=1
HAVE_STRPTIME=1
HAVE_STRSEP=1
HAVE_STRTONUM=0
HAVE_SYS_ENDIAN=0
HAVE_VASPRINTF=1
HAVE_WCHAR=1
NEED_GNU_SOURCE=1
END

pbuild_configure_once _x="$(sha1sum configure.local)" \
	./configure

echo "-- build --"
make -j$MAXJOBS

if [ -n "$PBUILD_ENABLE_TESTS" -a $ARCH = $NATIVE_ARCH ] && command -v perl >/dev/null; then
	echo "-- test --"
	LD_LIBRARY_PATH="$PWD" make regress
fi

echo "-- install --"
make -j$MAXJOBS DESTDIR=$DESTDIR base-install

# remove soelim; a tool for replacing ".so filename" with contents of that file during
# man page development
rm -fv $DESTDIR/bin/soelim usr/share/man/man1/soelim.1

# remove makewhatis/whatis and apropos tools and index
for path in \
	bin/apropos  usr/share/man/man1/apropos.1 \
	bin/whatis  usr/share/man/man1/whatis.1 \
	sbin/makewhatis  usr/share/man/man8/makewhatis.8 \
;do
	rm -fv $DESTDIR/$path
done
rmdir $DESTDIR/sbin 2>/dev/null || true
rmdir $DESTDIR/usr/share/man/man8 2>/dev/null || true
