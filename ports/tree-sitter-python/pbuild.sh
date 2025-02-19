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
curl -L https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v$VERSION.tar.gz > tree-sitter-python.tar.gz
tar -xaf tree-sitter-python.tar.gz
ls -l
cd tree-sitter-python-$VERSION
PREFIX=/usr make -j$MAXJOBS
PREFIX=/usr make -j$MAXJOBS install DESTDIR=$DESTDIR
rm $DESTDIR/$PREFIX/lib/libtree-sitter*.so*
