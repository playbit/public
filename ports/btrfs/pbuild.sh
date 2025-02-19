# BTRFS filesystem utilities
# https://btrfs.wiki.kernel.org
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/pkgconf
#
#!DEP ports/libc [transitive]
#!DEP ports/libz
#!DEP ports/libzstd
#!DEP ports/util-linux
#
# Note: util-linux provides libuuid and libblkid
#
source /p/tools/pbuild.lib.sh

VERSION=6.10.1

pbuild_fetch_and_unpack \
	https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v$VERSION.tar.xz \
	25684696bc5b5d07c98f19d4bf7a48b53ab94870ca4c468a68af3df9e2c8a35e

pbuild_apply_patches

# building documentation requires Python & the Python module "Sphinx"
# if command -v python >/dev/null; then
# 	echo "Temporarily installing sphinx in virtualenv at $PWD/pyenv"
# 	mkdir pipcache
# 	export XDG_CACHE_HOME=$PWD/pipcache
# 	python -m venv pyenv
# 	source pyenv/bin/activate
# 	pip install Sphinx
# 	CONFIGURE_ARGS=
# else
CONFIGURE_ARGS="--disable-python --disable-documentation"
# fi

pbuild_configure_once ./configure \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-shared \
	--disable-zoned \
	--disable-libudev \
	--disable-backtrace \
	--disable-convert \
	--disable-lzo \
	$CONFIGURE_ARGS

make -j$MAXJOBS
make -j$MAXJOBS install DESTDIR=$DESTDIR

for exe in \
	btrfs \
	btrfs-find-root \
	btrfs-image \
	btrfs-map-logical \
	btrfs-select-super \
	btrfstune \
	mkfs.btrfs \
;do
	strip $DESTDIR/bin/$exe
done
