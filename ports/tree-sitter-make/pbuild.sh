# Syntax highlighting library: Makefile plugin
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/tree-sitter
source /p/tools/pbuild.lib.sh

VERSION=1.1.1

pbuild_fetch_and_unpack \
    https://github.com/tree-sitter-grammars/tree-sitter-make/archive/refs/tags/v$VERSION.tar.gz \
    31affca06041623cfa5f6a728cb3f0f2a8eb7fd01607e1a2681ea1f318367211 \
    tree-sitter-make-$VERSION.tar.gz

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
