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
curl -L https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v$VERSION.tar.gz > tree-sitter-c.tar.gz
tar -xaf tree-sitter-c.tar.gz
ls -l
cd tree-sitter-c-$VERSION
PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
