# A modern and intuitive terminal-based text editor
# https://micro-editor.github.io/
# license: MIT
#
#!BUILDTOOL ports/busybox
#!BUILDTOOL ports/curl if HERMETIC
source /p/tools/pbuild.lib.sh

VERSION=2.0.14
ARCH2=${ARCH/aarch64/arm64}

ARCHIVE=
CHECKSUM=
case $ARCH in
	aarch64)
		ARCHIVE=micro-$VERSION-linux-arm64.tar.gz
		CHECKSUM=2e01b3ea62cdea3e62eb3ee99f6bffe84de06f689cf479173c4e7221b6613d06
		;;
	x86_64)
		ARCHIVE=micro-$VERSION-linux64-static.tar.gz
		CHECKSUM=da6fefe16f09f90ae07d32f7c6be811a0acfd3e8edadfefccc9991ae78e9b229
		;;
esac

pbuild_fetch_and_unpack \
	https://github.com/zyedidia/micro/releases/download/v$VERSION/$ARCHIVE \
	"$CHECKSUM"

install -v -D -m0755 micro $DESTDIR/bin/micro
install -v -D -m0644 micro.1 $DESTDIR/usr/share/man/man1/micro.1
