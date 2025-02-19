# git -- Distributed version control system
# https://www.git-scm.com/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libz
#!DEP ports/openssl [transitive]
#!DEP ports/libcurl
#
# Perl is required for diff-highlight (which is a perl script)
#!DEP ports/perl [transitive]
#
# Optional:
#--!DEP ports/python [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=2.46.0

pbuild_fetch_and_unpack \
	https://www.kernel.org/pub/software/scm/git/git-$VERSION.tar.xz \
	7f123462a28b7ca3ebe2607485f7168554c2b10dfc155c7ec46300666ac27f95

pbuild_apply_patches

# Note: we can't ask $(DESTDIR)/bin/curl-config since we might be cross compling, so assume
# that libcurl for NATIVE_ARCH needs the same libs for ARCH.
# We must take care of excluding -L flags (i.e. -L/lib) to not link with the wrong arch libs.
# To be extra sure, we remove /lib/libcurl.a when building in a sandbox.
CURL_LIBS=$(curl-config --libs | sed -E 's/-L[^ ]+ *//')
echo "CURL_LIBS=$CURL_LIBS"
[ -z "$PBUILD_CHROOT" ] || rm -vf /lib/libcurl.a

# Note: for config documentation, see comments in git source Makefile
cat > config.mak <<-EOF
	CC=$CC
	CXX=$CXX
	CFLAGS=$CFLAGS
	LDFLAGS=$LDFLAGS
	INSTALL_SYMLINKS=1
	INSTALL_STRIP=-s
	CURL_LDFLAGS=$CURL_LIBS
	NO_GETTEXT=1
	NO_SVN_TESTS=1
	NO_SYS_POLL_H=1
	NO_PERL=1
	NO_TCLTK=1
	ICONV_OMITS_BOM=Yes
	PYTHON_PATH=/bin/python3
	PERL_PATH=/bin/perl
EOF
# echo NO_ICONV=1 >> config.mak
[ -x $DESTDIR/bin/python ] || echo NO_PYTHON=1 >> config.mak
[ -x $DESTDIR/bin/perl ] || echo NO_PERL=1 >> config.mak

# fix incorrect curl libs in curl configure test (it does not use CURL_LDFLAGS)
if [ ! -f configure.orig ]; then
	cp configure configure.orig
	sed -i -E 's@LIBS="-lcurl\s+\$LIBS"@LIBS="'"$CURL_LIBS"' \$LIBS"@' configure
fi

pbuild_configure_once \
	_ID$(cat config.mak configure | sha1sum | cut -d' ' -f1)=1 \
	./configure \
		--host=$CHOST \
		--build=$CBUILD \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		NO_ICONV=1 \
		ac_cv_fread_reads_directories=true \
		ac_cv_snprintf_returns_bogus=false \
		CURL_LDFLAGS="$CURL_LIBS" \

make -j$MAXJOBS

make -j$MAXJOBS install INSTALL_STRIP=-s DESTDIR=$DESTDIR

make -C contrib/subtree -j$MAXJOBS prefix=/usr DESTDIR=$DESTDIR
make -C contrib/subtree -j$MAXJOBS install prefix=/usr DESTDIR=$DESTDIR

make -C contrib/diff-highlight -j$MAXJOBS prefix=/usr DESTDIR=$DESTDIR
install -v -D -m755 contrib/diff-highlight/diff-highlight -t $DESTDIR/bin

# fix messed up symlinks in /usr/libexec/git-core
# e.g. "git -> ../..//bin/git" => "git -> ../../bin/git"
for f in "$DESTDIR"/usr/libexec/git-core/*; do
	if [ -L "$f" ]; then
		ln -sf $(readlink "$f" | sed -E 's|/{2,}|/|g') "$f"
	fi
done

# install default gitconfig
install -v -D -m644 $SRCDIR/system-gitconfig $DESTDIR/etc/gitconfig
install -v -D -m644 $SRCDIR/user-gitconfig   $DESTDIR/home/root/.gitconfig
