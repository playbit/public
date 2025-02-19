# Syntax highlighting library
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
source /p/tools/pbuild.lib.sh

VERSION=0.25.1

pbuild_fetch_and_unpack \
	https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v$VERSION.tar.gz \
	99a2446075c2edf60e82755c48415d5f6e40f2d9aacb3423c6ca56809b70fe59

pbuild_apply_patches

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
