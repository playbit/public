#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

BUSYBOX_VERSION=$(grep -F 'BUSYBOX_VERSION := ' Makefile | cut -d' ' -f3)
BUSYBOX_TAR=$DOWNLOAD/busybox-$BUSYBOX_VERSION.tar.bz2
BUSYBOX_SRC=$BUILD_DIR/busybox-$BUSYBOX_VERSION

download -o "$BUSYBOX_TAR" \
  --sha256 b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314 \
  "https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2"

echo "Extracting $BUSYBOX_TAR to $BUSYBOX_SRC"
rm -rf "$BUSYBOX_SRC"
mkdir -p "$BUSYBOX_SRC"
tar -C "$BUSYBOX_SRC" --strip-components=1 -xjof "$BUSYBOX_TAR"

# rename busybox's makefile (since we have a Makefile of our own)
mv "$BUSYBOX_SRC/Makefile" "$BUSYBOX_SRC/busybox.mk"

# remove files we know we don't need
rm "$BUSYBOX_SRC/.indent.pro"
rm "$BUSYBOX_SRC/AUTHORS"
rm "$BUSYBOX_SRC/busybox_ldscript.README.txt"
rm "$BUSYBOX_SRC/INSTALL"
rm "$BUSYBOX_SRC/make_single_applets.sh"
rm "$BUSYBOX_SRC/NOFORK_NOEXEC.lst"
rm "$BUSYBOX_SRC/NOFORK_NOEXEC.sh"
rm "$BUSYBOX_SRC/README"
rm "$BUSYBOX_SRC/size_single_applets.sh"
rm "$BUSYBOX_SRC/TODO"
rm "$BUSYBOX_SRC/TODO_unicode"
rm -rf "$BUSYBOX_SRC/arch/i386"
rm -rf "$BUSYBOX_SRC/arch/sparc"
rm -rf "$BUSYBOX_SRC/arch/sparc64"
rm -rf "$BUSYBOX_SRC/configs"
rm -rf "$BUSYBOX_SRC/examples"
rm -rf "$BUSYBOX_SRC/qemu_multiarch_testing"
rm -rf "$BUSYBOX_SRC/shell/ash_test"
rm -rf "$BUSYBOX_SRC/shell/hush_doc.txt" "$BUSYBOX_SRC/shell/hush_test"
rm -rf "$BUSYBOX_SRC/testsuite"

# we need two files in docs dir for busybox's makefile to function
find "$BUSYBOX_SRC/docs" \
  -type f \
  -and -not -path "$BUSYBOX_SRC/docs/busybox_header.pod" \
  -and -not -path "$BUSYBOX_SRC/docs/busybox_footer.pod" \
  -delete

echo "Replacing current source at $PWD"
find . \
  -type f \
  -and -not -path ./Makefile \
  -and -not -path ./upgrade-busybox.sh \
  -and -not -path ./busybox.conf \
  -and -not -path ./progs.txt \
  -delete
find . -type d -empty -delete
cp -RT "$BUSYBOX_SRC" .

# remove any old build from the system
make ARCH=aarch64 clean
make ARCH=x86_64 clean

[ -n "${NO_CLEANUP:-}" ] || rm -rf "$BUSYBOX_SRC"

cat << END
——————————————————————————————————————————————————————————————————————

                       busybox upgrade complete

Next steps:

1. Review changes and update Makefile if needed
   git diff -- ${PWD##$PWD0/}

2. Test build
   make -C ${PWD##$PWD0/} -j$(nproc) ARCH=aarch64
   make -C ${PWD##$PWD0/} -j$(nproc) ARCH=x86_64

3. Check for added or removed programs:
   make -C ${PWD##$PWD0/} check-progs

Tip: You can review past changes like this:
   git log 03aeae493ff4e8872352..HEAD -- ${PWD##$PWD0/}

——————————————————————————————————————————————————————————————————————
END
