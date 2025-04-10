# Syntax highlighting library: JSON plugin
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/tree-sitter
source /p/tools/pbuild.lib.sh

VERSION=0.24.8

pbuild_fetch_and_unpack \
    https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v$VERSION.tar.gz \
    42 \
    tree-sitter-json-$VERSION.tar.gz

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
