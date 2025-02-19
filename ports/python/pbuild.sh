# High-level scripting language
# https://www.python.org/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/pkgconf
#!BUILDTOOL ports/python if ARCH != NATIVE_ARCH
#
#!DEP ports/libc [transitive]
#!DEP ports/openssl [transitive]
#!DEP ports/libz
#!DEP ports/libncurses
#!DEP ports/readline
#!DEP ports/bzip2
#!DEP ports/libffi
#!DEP ports/sqlite
#
source /p/tools/pbuild.lib.sh

VERSION=3.12.6

ENABLE_PGO=${ENABLE_PGO:-1}  # if "1", try to use Profile Guided Optimization
ENABLE_LTO=${ENABLE_LTO:-1}  # if "1", try to use Link Time Optimization

pbuild_fetch_and_unpack \
	https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz \
	1999658298cf2fb837dffed8ff3c033ef0c98ef20cf73c5d5f66bed5ab89697c

pbuild_apply_patches

# Ignore preprocessor, compiler and linker flags set by pbuild
export CPPFLAGS=""
export CFLAGS=""
export LDFLAGS="-Wl,--compress-debug-sections=zlib"

# Setup configure args that depend on if we are cross compiling or not
# See https://docs.python.org/3/using/configure.html#cross-compiling-options
CONFIG_ARGS=
CONFIG_SITE=
if [ $ARCH != $NATIVE_ARCH ]; then
	# Cross compiling
	CONFIG_ARGS="$CONFIG_ARGS --host=$CHOST --build=$NATIVE_ARCH"
	CONFIG_ARGS="$CONFIG_ARGS --with-build-python=/bin/python"
	cat << END > CONFIG_SITE
CFLAGS="--target=$ARCH-unknown-playbit"
LDFLAGS="--target=$ARCH-unknown-playbit"
ac_cv_build=$NATIVE_ARCH-unknown-playbit
ac_cv_host=$ARCH-unknown-playbit
ac_cv_buggy_getaddrinfo=no
ac_cv_file__dev_ptmx=yes
ac_cv_file__dev_ptc=no
ax_cv_c_float_words_bigendian=no
END
elif [ "$ENABLE_PGO" = 1 ]; then
	# Enable Profile Guided Optimization (PGO) for native (non-cross) builds
	CONFIG_ARGS="$CONFIG_ARGS --enable-optimizations"
fi
if [ "$ENABLE_LTO" = 1 ]; then
	CONFIG_ARGS="$CONFIG_ARGS --with-lto=thin"
fi

# THREAD_STACK_SIZE: [alpine] set thread stack size to 2MB so we don't segfault before we hit
# sys.getrecursionlimit() Note: raised from 1 as we ran into some stack limit on x86_64 too
# sometimes, but not recursion.

# Note: If configuration fails with an error about ax_cv_c_float_words_bigendian not being
# inferred, then the issue is with AX_C_FLOAT_WORDS_BIGENDIAN in aclocal.m4.
# A workaround is to set environment variable
#   ax_cv_c_float_words_bigendian=no (or yes)
# when calling ./configure.

pbuild_configure_once \
	CONFIG_SITE="$CONFIG_SITE" \
	CPPFLAGS="$CPPFLAGS" \
	CFLAGS="$CFLAGS" \
	LDFLAGS="$LDFLAGS" \
	CFLAGS_NODIST="-O2 -DTHREAD_STACK_SIZE=0x200000" \
	CXXFLAGS_NODIST="-O2" \
	LDFLAGS_NODIST="" \
	LIBFFI_CFLAGS="" \
	LIBFFI_LIBS="-lffi" \
	LIBREADLINE_CFLAGS="" \
	LIBREADLINE_LIBS="-lreadline -lncursesw" \
	./configure \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-ipv6 \
		--with-computed-gotos \
		--with-dbmliborder=gdbm:ndbm \
		--with-readline \
		--without-ensurepip \
		--disable-test-modules \
		--enable-loadable-sqlite-extensions \
		$CONFIG_ARGS

# build
if [ $ARCH = $NATIVE_ARCH -a "$ENABLE_PGO" = 1 ]; then
	make -j$MAXJOBS PROFILE_TASK="-m test.regrtest --pgo -j$MAXJOBS"
else
	# TODO: Figure out how to enable PGO when cross compiling
	make -j$MAXJOBS
fi

# install
make -j$MAXJOBS install DESTDIR=$DESTDIR

# strip executables
VER2=${VERSION%.*} # e.g. 1.2 when VERSION=1.2.3
echo "strip $DESTDIR/bin/python${VER2}"
strip $DESTDIR/bin/python${VER2}

# strip shared libraries (saves about 5M on aarch64)
for f in $DESTDIR/lib/python${VER2}/lib-dynload/*.so; do
	echo "strip $f"
	strip $f
done

# /bin/python -> pythonX
VER1=${VERSION%%.*} # e.g. 1 when VERSION=1.2.3
ln -sfv python${VER1} $DESTDIR/bin/python
ln -sfv python${VER1}-config $DESTDIR/bin/python-config

# Rename "idle" utility which has a confusing name when installed system-wide.
# Yeah, this might break some random shell script out there, but how confusing isn't it
# to find something called "idle3" on PATH?!
mv $DESTDIR/bin/idle$VER2 $DESTDIR/bin/pyidle$VER2
rm -v $DESTDIR/bin/idle$VER1
ln -sfv pyidle$VER2 $DESTDIR/bin/pyidle$VER1

# check that libffi was correctly enabled (will exit 1 if not)
if [ $ARCH = $NATIVE_ARCH ]; then
	echo "CHECK python -c 'import ctypes'"
	chroot $DESTDIR /bin/python -c 'import ctypes'
fi

# # remove bytecode .pyc files (saves about 40M on aarch64)
# for d in $(cd $DESTDIR && find lib/python$VER2 -type d -name __pycache__); do
# 	echo "rm -rf $DESTDIR/$d"
# 	rm -rf $DESTDIR/$d
# done

# Note: bin/pip is not installed since we don't want to encourage system-wide
# python package installation. Instead the user should use venv, e.g.
#   python -m venv ~/my-venv
#   . ~/my-venv/bin/activate
#   pip install somepackage
