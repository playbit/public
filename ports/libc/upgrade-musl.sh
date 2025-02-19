#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH
MUSL_VERSION=$(grep -F 'MUSL_VERSION := ' Makefile | cut -d' ' -f3)
MUSL_TAR=$DOWNLOAD/musl-$MUSL_VERSION.tar.gz
MUSL_SRC=$BUILD_DIR/musl-$MUSL_VERSION

# sha256 for musl 1.2.5
download -o "$MUSL_TAR" \
  --sha256 a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4 \
  "https://musl.libc.org/releases/musl-$MUSL_VERSION.tar.gz"

echo "Extracting $MUSL_TAR to $MUSL_SRC"
rm -rf "$MUSL_SRC"
mkdir -p "$MUSL_SRC"
tar -C "$MUSL_SRC" --strip-components=1 -xzof "$MUSL_TAR"

echo "Running $MUSL_SRC/configure > $MUSL_SRC/configure.log"
# note: we unconditionally pass "--target=aarch64-playbit" to configure, even for x86.
# Later we override the make variable it sets (ARCH) during make.
(cd "$MUSL_SRC" && ./configure \
  --target=aarch64-playbit \
  --build=$(uname -m)-playbit \
  --prefix="" \
  --sysconfdir=/etc \
  --bindir=/bin \
  --libdir=/lib \
  --syslibdir=/lib \
  --includedir=/usr/include \
  --mandir=/share/man \
  --infodir=/share/info \
  --localstatedir=/var \
  CC="$TOOLCHAIN/bin/clang" \
  LDFLAGS="-Wl,-soname,libc.so" \
  LIBCC="$TOOLCHAIN/lib/clang/lib/libclang_rt.builtins.a" \
  CROSS_COMPILE="$TOOLCHAIN/bin/" \
  > "$MUSL_SRC/configure.log" )

echo "genh: \$""(GENH)" >> "$MUSL_SRC/Makefile"
echo ".PHONY: genh" >> "$MUSL_SRC/Makefile"

for arch in aarch64 x86_64; do
  echo "Generating $arch headers"
  rm -rf "$MUSL_SRC"/obj/include/bits
  make -C "$MUSL_SRC" ARCH=$arch genh > "$MUSL_SRC/make-$arch.log"
  mv "$MUSL_SRC"/obj/include/bits/*.h "$MUSL_SRC"/arch/$arch/bits/
  rm "$MUSL_SRC"/arch/$arch/bits/*.h.in
done

echo "Removing current sources from ./"
find . \
  -type f \
  -and -not -path ./Makefile \
  -and -not -path ./musl.mk \
  -and -not -path ./upgrade-\*.sh \
  -and -not -path ./wasi\* \
  -and -not -path ./src/execinfo/\* \
  -and -not -path ./src/fts/\* \
  -and -not -path ./man/fts\* \
  -and -not -path ./include/execinfo.h \
  -and -not -path ./include/fts.h \
  -and -not -path ./include/sys/cdefs.h \
  -and -not -path ./include/sys/queue.h \
  -and -not -path ./include/sys/tree.h \
  -delete
find . -type d -empty -delete

echo "Copying new musl sources into ./"
mkdir -p arch crt
cp -R  "$MUSL_SRC"/COPYRIGHT      COPYRIGHT
cp -R  "$MUSL_SRC"/dynamic.list   dynamic.list
cp -R  "$MUSL_SRC"/Makefile       new-musl-Makefile
cp -R  "$MUSL_SRC"/config.mak     new-musl-config.mak
cp -RT "$MUSL_SRC"/arch/generic   arch/generic
cp -RT "$MUSL_SRC"/arch/aarch64   arch/aarch64
cp -RT "$MUSL_SRC"/arch/x86_64    arch/x86_64
cp -RT "$MUSL_SRC"/compat         compat
cp -R  "$MUSL_SRC"/crt/*.c        crt/
cp -RT "$MUSL_SRC"/crt/aarch64    crt/aarch64
cp -RT "$MUSL_SRC"/crt/x86_64     crt/x86_64
cp -RT "$MUSL_SRC"/include        include
cp -RT "$MUSL_SRC"/ldso           ldso
cp -RT "$MUSL_SRC"/src            src
rm -rf src/malloc/oldmalloc

# remove the #warning in sys/cdefs.h since unfortunately a lot of stuff we build use it
grep -v -F '#warning usage of non-standard' "$MUSL_SRC"/include/sys/cdefs.h > sys/cdefs.h

echo "Generating src/internal/version.h"
echo "#define VERSION \"$MUSL_VERSION\"" > src/internal/version.h

[ -n "${NO_CLEANUP:-}" ] || rm -rf "$BUILD_DIR"/musl-$MUSL_VERSION-*

cat << END
——————————————————————————————————————————————————————————————————————
——————————— Please inspect the following files for changes ———————————
  new-musl-Makefile
  new-musl-config.mak

Update $PWD/Makefile as needed.
When you are done, test build and remove the \"new\" files:
  make -C $PWD ARCH=aarch64
  make -C $PWD ARCH=x86_64
  rm new-musl-*

——————————————————————————————————————————————————————————————————————
END
