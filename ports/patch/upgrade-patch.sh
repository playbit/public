#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

PATCH_VERSION=$(grep -F 'VERSION := ' Makefile | cut -d' ' -f3)
PATCH_TAR=$DOWNLOAD/patch-$PATCH_VERSION.tar.gz
PATCH_SRC=$PWD

if [ ! -f /tmp/patch-$PATCH_VERSION/configure ]; then
  download -o "$PATCH_TAR" \
    --sha256 ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd \
    "https://ftp.gnu.org/gnu/patch/patch-$PATCH_VERSION.tar.xz"
  rm -rf /tmp/patch-$PATCH_VERSION
  mkdir -p /tmp/patch-$PATCH_VERSION
  echo "Extracting $PATCH_TAR"
  tar -C /tmp/patch-$PATCH_VERSION --strip-components=1 -xof "$PATCH_TAR"

  _pushd /tmp/patch-$PATCH_VERSION

  for f in $(echo $PATCH_SRC/patches/*.patch | xargs -n1 echo | sort); do
    echo "applying patch $f"
    patch -p1 < "$f"
  done

  # needs autoconf & automake :(
  apk add autoconf automake
  aclocal && autoheader && autoconf && automake --add-missing
else
  _pushd /tmp/patch-$PATCH_VERSION
fi


for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}

  echo "————————— make clean > make-clean.log —————————"

  make clean > make-clean.log || true

  echo "————————— ./configure $arch-playbit > configure.out —————————"

  touch Makefile

  CC=$TOOLCHAIN/bin/clang \
  CXX=$TOOLCHAIN/bin/clang++ \
  CPPFLAGS="--target=$arch-playbit" \
  CFLAGS="--target=$arch-playbit -O2" \
  LDFLAGS="-L$DISTROOT/lib" \
  PKG_CONFIG_LIBDIR=$DISTROOT/lib/pkgconfig \
  PKG_CONFIG_PATH=$DISTROOT/lib/pkgconfig \
  gl_cv_func_gettimeofday_clobber=no \
  gl_cv_func_tzset_clobber=no \
  ./configure \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --prefix=/usr \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --localstatedir=/var \
    --disable-xattr \
    > configure.out

  # --disable-xattr to silence warning that libattr can't be found

  echo "————————— make > make-$arch.out —————————"

  make V=1 > make-$arch.out

  # echo "————————— make install DESTDIR=install-$arch > make-install-$arch.out —————————"
  # rm -rf install-$arch
  # mkdir install-$arch
  # make V=1 DESTDIR=$PWD/install-$arch install > make-install-$arch.out

  echo "————————— finding used source files —————————"

  grep -E "^$TOOLCHAIN/bin/clang .* -c " make-$arch.out > cc.out
  grep -Fv ' -I../lib ' cc.out | sed -E 's/^.+ ([^ ]+\.c).*$/lib\/\1/' > srcs.txt
  grep -F ' -I../lib ' cc.out | sed -E 's/^.+ ([^ ]+\.c).*$/src\/\1/' >> srcs.txt
  mv srcs.txt srcs1.txt

  cat srcs1.txt \
  | xargs -n1 realpath \
  | sort -u \
  | sed "s@^$PWD/@@" \
  | grep -Fxv lib/xalloc-die.c \
  > srcs.txt
  # lib/xalloc-die.c: overridden by impl in src/util.o

  SRC_DEP_FILES=()
  LIB_DEP_FILES=()
  for f in $(cat srcs.txt); do
    d=${f%/*}     # a/b/c => a/b
    p=${f%*.*}.Po # a/b.c => a/b.Po
    p=${p##*/}    # a/b.Po => b.Po
    case $f in
      src/*) SRC_DEP_FILES+=( .deps/$p ) ;;
      lib/*) LIB_DEP_FILES+=( .deps/$p ) ;;
      *)     _err "unexpected source $f" ;;
    esac
  done

  rm -f deps.txt
  (cd src && cat "${SRC_DEP_FILES[@]}" \
    | grep -v '^#' \
    | sed -E 's/^[^:]+://' \
    | tr '\n' ' ' \
    | sed -E 's/[ \\]+/ /g' \
    | tr ' ' '\n' \
    | sort -u \
    | xargs -n1 realpath \
    | grep -v "^$TOOLCHAIN" \
    | grep -v "^$DISTROOT" \
    | sort -u \
    >> ../deps.txt)
  (cd lib && cat "${LIB_DEP_FILES[@]}" \
    | grep -v '^#' \
    | sed -E 's/^[^:]+://' \
    | tr '\n' ' ' \
    | sed -E 's/[ \\]+/ /g' \
    | tr ' ' '\n' \
    | sort -u \
    | xargs -n1 realpath \
    | grep -v "^$TOOLCHAIN" \
    | grep -v "^$DISTROOT" \
    | sort -u \
    >> ../deps.txt)
  sort -u deps.txt srcs.txt | sed "s@^$PWD/@@" > files.txt

  echo
  echo "————————— srcs —————————"
  cat srcs.txt

  echo
  echo "————————— files.txt —————————"
  cat files.txt

  SRC=$PWD
  _pushd "$PATCH_SRC"

  echo "———— removing files from $PWD ————"

  find . -type f \
    -and -not -path ./Makefile \
    -and -not -path ./upgrade-patch.sh \
    -and -not -path ./patches/\* \
    -delete
  find . -type d -empty -delete

  echo "———— copying files to $PWD ————"

  mkdir -p lib/sys
  cp $SRC/patch.man patch.1

  while IFS= read -r f; do
    case "$f" in
      src/*) cp $SRC/$f ${f#*/} ;;
      */*)   mkdir -p ${f%/*} && cp $SRC/$f $f ;;
      *)     cp $SRC/$f $f ;;
    esac
  done < $SRC/files.txt
  # grep '^src/' files.txt | sed 's/^src\///' | xattr echo cp
  cp $SRC/COPYING license.txt

  echo "———— source files ————"
  # filter out .c files, and exclude those are not compilation units
  grep -v '^lib/' $SRC/srcs.txt | sed 's/^src\///' | awk '{printf "\t%s \\\n", $0}'
  grep    '^lib/' $SRC/srcs.txt                    | awk '{printf "\t%s \\\n", $0}'

  exit

done

_popd
