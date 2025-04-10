# Syntax highlighting library: Bash plugin
# https://tree-sitter.github.io/tree-sitter/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/tree-sitter
source /p/tools/pbuild.lib.sh

VERSION=0.23.3

pbuild_fetch_and_unpack \
    https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v$VERSION.tar.gz \
    c682b81d0fe953d19f6632db3ba6e4f2db1efe1784f7a28bc5fcf6355d67335b \
    tree-sitter-bash-$VERSION.tar.gz

PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
