#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

MAKE_VERSION=$(grep -F 'MAKE_VERSION := ' Makefile | cut -d' ' -f3)
MAKE_TAR=$DOWNLOAD/make-$MAKE_VERSION.tar.gz

if [ ! -d /tmp/make-$MAKE_VERSION ]; then
  download -o "$MAKE_TAR" \
    --sha256 dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3 \
    "https://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz"
  rm -rf /tmp/make-$MAKE_VERSION
  mkdir -p /tmp/make-$MAKE_VERSION
  echo "Extracting $MAKE_TAR"
  tar -C /tmp/make-$MAKE_VERSION --strip-components=1 -xzof "$MAKE_TAR"
fi

_pushd /tmp/make-$MAKE_VERSION

rm -rf staging
mkdir -p staging/lib

for arch in aarch64 x86_64; do
  echo "Configuring for $arch"
  CC=$TOOLCHAIN/bin/clang \
  CXX=$TOOLCHAIN/bin/clang++ \
  CPPFLAGS="--target=$arch-playbit" \
  CFLAGS="--target=$arch-playbit -static -MMD" \
  LDFLAGS=--static \
  ./configure \
    --prefix= \
    --enable-silent-rules \
    --without-guile \
    --disable-nls \
    --disable-dependency-tracking \
    --without-libiconv-prefix \
    --without-libintl-prefix \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl >/dev/null

  echo "Building for $arch"
  make clean >/dev/null
  make V=1 > makeout-$arch.txt

  # find included files
  rm -f deps-*.txt
  i=0

  cat src/*.d \
    | sed -E 's/^[^:]+://' \
    | tr '\n' ' ' \
    | sed -E 's/[ \\]+/ /g' \
    | tr ' ' '\n' \
    | sort -u \
    | xargs -n1 realpath \
    | grep -v "^$TOOLCHAIN" \
    | sed "s@^/tmp/make-$MAKE_VERSION/@@" \
    > deps1.txt &

  (cd lib && cat *.d \
    | sed -E 's/^[^:]+://' \
    | tr '\n' ' ' \
    | sed -E 's/[ \\]+/ /g' \
    | tr ' ' '\n' \
    | sort -u \
    | xargs -n1 realpath \
    | grep -v "^$TOOLCHAIN" \
    | sed "s@^/tmp/make-$MAKE_VERSION/@@" \
    | sort -u > ../deps2.txt)
  wait
  sort -u deps1.txt deps2.txt > deps.txt
  # cat deps.txt

  # extract "compile C" invocations
  grep -E "^$TOOLCHAIN/bin/clang .* -c " makeout-$arch.txt > cc.txt

  # "lib" sources
  LIB_SRCS=($(grep -F -e '-o libgnu_a' cc.txt | sed -E 's/^.+`([^ ]+\.c)/lib\/\1/'))
  # "src" sources
  SRCS=($(grep -F -v -e '-o libgnu_a' cc.txt | sed -E 's/^.+ -c .+ (src\/[^ ]+\.c)$/\1/'))

  sed -E "s@^$TOOLCHAIN/bin/clang (.+) -c .+\$@\1@" cc.txt | sort -u > cflags.txt

  # echo "———— deps ———"
  # cat deps.txt
  # echo
  # echo "———— cflags ———"
  # cat cflags.txt
  # echo
  # echo "———— cc invocations by cflags ———"
  # i=1
  # while IFS= read -r cflags; do
  #   echo "CFLAGS$i :="
  #   echo $cflags | tr ' -' '\n-'
  #   grep -F -e "$cflags" makeout-$arch.txt | sed -E 's/^.+ -c +(.+)$/  cc \1/'
  #   echo
  #   i=$(( i + 1 ))
  # done < cflags.txt
  # echo "———— link command ———"
  # grep -F " -o make " makeout-$arch.txt

  echo "recording of make ARCH=$arch" > staging/make-rec-$arch.txt
  echo >> staging/make-rec-$arch.txt
  echo "--------------------------------------" >> staging/make-rec-$arch.txt
  echo "compilations grouped by unique CFLAGS:" >> staging/make-rec-$arch.txt
  while IFS= read -r cflags; do
    echo "CFLAGS$i :="
    echo $cflags | tr ' -' '\n-'
    grep -F -e "$cflags" makeout-$arch.txt | sed -E 's/^.+ -c +(.+)$/  cc \1/'
    echo
    i=$(( i + 1 ))
  done < cflags.txt >> staging/make-rec-$arch.txt
  echo >> staging/make-rec-$arch.txt
  echo "--------------------------------------" >> staging/make-rec-$arch.txt
  echo "link command:" >> staging/make-rec-$arch.txt
  grep -F " -o make " makeout-$arch.txt >> staging/make-rec-$arch.txt
  # cat staging/make-rec-$arch.txt

  cp COPYING staging/
  mkdir staging/$arch
  cp ${SRCS[@]} staging/
  cp ${LIB_SRCS[@]} staging/lib/
  for f in $(grep '^src/' deps.txt); do cp $f staging/$(basename "$f"); done
  for f in $(grep -v '^src/' deps.txt); do cp $f staging/$f; done
  rm -f staging/config.h
  cp src/config.h staging/$arch/config.h
done

cp doc/make.1 staging/make.1

_popd

echo "Replacing current source at $PWD"
find . -type f -and -not -path ./Makefile -and -not -path ./upgrade-make.sh -delete
find . -type d -empty -delete
cp -RT /tmp/make-$MAKE_VERSION/staging .

[ -n "${NO_CLEANUP:-}" ] || rm -rf /tmp/make-$MAKE_VERSION

cat << END
——————————————————————————————————————————————————————————————————————

                         Done upgrading make

Next steps:

1. Review changes, in particular recorded make output in make-rec-ARCH.txt,
   and update Makefile if needed
     git diff -- $PWD

2. Test build
   make -j$(nproc) -C $PWD ARCH=aarch64
   make -j$(nproc) -C $PWD ARCH=x86_64

——————————————————————————————————————————————————————————————————————
END
