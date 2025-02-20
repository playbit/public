# Syntax highlighting library: C plugin
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/tree-sitter
source /p/tools/pbuild.lib.sh

VERSION=0.23.4

pbuild_fetch_and_unpack \
	https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v$VERSION.tar.gz \
	b66c5043e26d84e5f17a059af71b157bcf202221069ed220aa1696d7d1d28a7a \
	tree-sitter-c-$VERSION.tar.gz

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
