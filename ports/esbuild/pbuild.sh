# JavaScript & TypeScript compiler/bundler
# https://esbuild.github.io/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
source /p/tools/pbuild.lib.sh

VERSION=0.24.2

# See https://github.com/evanw/esbuild/tree/v0.24.2/npm/%40esbuild
case "$ARCH" in
	aarch64) _arch=arm64 ;;
	x86_64)  _arch=x64 ;;
esac

pbuild_fetch_and_unpack \
	https://registry.npmjs.org/@esbuild/linux-$_arch/-/linux-$_arch-$VERSION.tgz \
	7df901475cebc48a59a7ea64fcc75c9a95018fc56faa721ccc1f4cbf213f0e16 \
	esbuild-$_arch-$VERSION.tar.gz

install -v -D -m0755 bin/esbuild $DESTDIR/bin/esbuild
