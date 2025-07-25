# Go programming language compiler
# https://go.dev/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
source /p/tools/pbuild.lib.sh

VERSION=1.24.5

case "$ARCH" in
	aarch64)
		_arch=arm64
		_hash=0df02e6aeb3d3c06c95ff201d575907c736d6c62cfa4b6934c11203f1d600ffa
		;;
	x86_64)
		_arch=amd64
		_hash=10ad9e86233e74c0f6590fe5426895de6bf388964210eac34a6d83f38918ecdc
		;;
esac

pbuild_fetch_and_unpack \
	https://go.dev/dl/go$VERSION.linux-$_arch.tar.gz \
	$_hash \
	go$VERSION.linux-$_arch.tar.gz

mkdir -p $DESTDIR/bin
rm -rf   $DESTDIR/bin/go
cp -R .  $DESTDIR/bin/go

