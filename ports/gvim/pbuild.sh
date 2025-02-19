# GVIM is a text editor
# https://www.vim.org
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/autoconf
#
#!DEP ports/libc [transitive]
#!DEP ports/libncurses [transitive]
#!DEP flute [transitive] if HERMETIC
#
source /p/tools/pbuild.lib.sh

VERSION=9.0

pbuild_fetch_and_unpack \
	https://ftp.nluug.nl/pub/vim/unix/vim-$VERSION.tar.bz2 \
	a6456bc154999d83d0c20d968ac7ba6e7df0d02f3cb6427fb248660bacfb336e

pbuild_apply_patches

cd src

_configure() {
	rm -f auto/config.cache
	autoconf configure.ac > auto/configure

	# configure script can't run certain tests when cross compiling
	CONFIG=
	if [ $ARCH != $NATIVE_ARCH ]; then
		# These were found by configuring for NATIVE_ARCH and then looking at
		# "Cache variables" in /build/gvim/src/config.log
		CONFIG="$CONFIG vim_cv_toupper_broken=no"
		CONFIG="$CONFIG vim_cv_terminfo=yes"
		CONFIG="$CONFIG vim_cv_tgetent=non-zero"
		CONFIG="$CONFIG vim_cv_getcwd_broken=no"
		CONFIG="$CONFIG vim_cv_stat_ignores_slash=no"
		CONFIG="$CONFIG vim_cv_memmove_handles_overlap=yes"
	fi

	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--datadir=/usr/share \
		--bindir=/bin \
		--libdir=/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-gui=playbit \
		--with-x=no \
		--enable-fontset=no \
		--enable-xim=no \
		--with-tlib=ncurses \
		--disable-netbeans \
		--disable-gtktest \
		--disable-nls \
		$CONFIG
}

pbuild_configure_once _configure

make -j$MAXJOBS

rm -f $DESTDIR/bin/gvim
rm -f $DESTDIR/bin/gview
make -j$MAXJOBS install DESTDIR=$DESTDIR

mkdir -p $DESTDIR/Workspace/Applications/GVIM.pbapp
cat <<EOF > $DESTDIR/Workspace/Applications/GVIM.pbapp/binary_any
#!/bin/sh
/bin/gvim -f
EOF

cat <<EOF > $DESTDIR/Workspace/Applications/GVIM.pbapp/manifest.conf
id=org.vim.GVIM
EOF

mkdir -p $DESTDIR/usr/share/vim
cat <<EOF > $DESTDIR/usr/share/vim/vimrc
set nocompatible
set directory=/tmp//
set backupdir=/tmp//
set cursorline
set number
set tabstop=4
set shiftwidth=4
syntax enable
colorscheme slate
EOF

chmod 0755 $DESTDIR/Workspace/Applications/GVIM.pbapp/binary_any
cp $SRCDIR/icon.vec $DESTDIR/Workspace/Applications/GVIM.pbapp/icon
