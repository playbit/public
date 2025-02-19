# GNU readline library
# https://tiswww.cwru.edu/php/chet/readline/rltop.html
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libncurses [transitive]
#
source /p/tools/pbuild.lib.sh

VERSION=8.2.13
VER2=${VERSION%.*} # e.g. 8.2 in 8.2.13
PATCHLEVEL=${VERSION##*.} # e.g. 13 in 8.2.13

pbuild_fetch_and_unpack \
	https://ftp.gnu.org/gnu/readline/readline-$VER2.tar.gz \
	3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35

_fetch_and_apply_patches() {
	local _i=1
	local name
	local file
	while [ $_i -le $PATCHLEVEL ]; do
		# patch filenames look like this: "readline82-012" for 8.2 patch 12
		name=$(printf "readline%s-%03d" ${VER2//./} $_i)
		file=$DOWNLOAD/$name
		download -o "$file" "https://ftp.gnu.org/gnu/readline/readline-$VER2-patches/$name"
		patch -p0 < "$file"
		_i=$((_i+1))
	done
}

pbuild_run_once _fetch_and_apply_patches

pbuild_configure_once \
	./configure \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--infodir=/tmp \
		--docdir=/tmp \
		--enable-static \
		--disable-shared \
		--disable-install-examples

# since we are installing static version of readline,
# and since some users of pkg-config don't pass --static when asking for --libs,
# we add ncurses explicitly
sed -i -E 's|^Libs:.+$|\0 -lncursesw|' readline.pc

make -j$MAXJOBS install DESTDIR=$DESTDIR
