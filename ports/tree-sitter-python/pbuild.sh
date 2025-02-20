# Syntax highlighting library: Python plugin
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/tree-sitter
source /p/tools/pbuild.lib.sh

VERSION=0.23.6

pbuild_fetch_and_unpack \
	https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v$VERSION.tar.gz \
	630a0f45eccd9b69a66a07bf47d1568e96a9c855a2f30e0921c8af7121e8af96 \
	tree-sitter-python-$VERSION.tar.gz

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
