#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

PLAYBIT_BASH_SRC_DIR=$PWD

VERSION=$(grep -F 'VERSION := ' Makefile | cut -d' ' -f3)
VERSION2=${VERSION%.*} # e.g. "5.2.26" => "5.2"

if [ ! -f /tmp/bash-$VERSION/configure ]; then
  TAR=$DOWNLOAD/bash-$VERSION.tar.gz
  download -o "$TAR" \
    --sha256 a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb \
    "https://ftp.gnu.org/gnu/bash/bash-$VERSION2.tar.gz"

  rm -rf /tmp/bash-$VERSION
  mkdir -p /tmp/bash-$VERSION
  echo "Extracting $TAR"
  tar -C /tmp/bash-$VERSION --strip-components=1 -xof "$TAR"

  _pushd /tmp/bash-$VERSION

  _patchlevel=${VERSION##*.}
  _patchbase=${VERSION2/./}
  _i=1
  mkdir -p patches
  while [ $_i -le $_patchlevel ]; do
    url=$(printf "https://ftp.gnu.org/gnu/bash/bash-%s-patches/bash%s-%03d" \
          "$VERSION2" "$_patchbase" $_i)
    dstname=$(basename "$url")
    echo "Fetching & applying patch $dstname"
    dstfile=patches/$dstname.patch
    download -o "$dstfile" "$url"
    patch -p0 -i "$dstfile"
    _i=$(( _i + 1))
  done
else
  _pushd /tmp/bash-$VERSION
fi

for arch in aarch64 x86_64; do
  DISTROOT=${DISTROOT_PREFIX}${arch}

  # if false; then # XXX

  echo "————————— make clean > make-clean.log —————————"
  make clean > make-clean.log || true

  # -DCONF_HOSTTYPE='"aarch64"'
  # -DCONF_OSTYPE='"linux-musl"'
  # -DCONF_MACHTYPE='"aarch64-unknown-linux-musl"'
  # -DCONF_VENDOR='"unknown"'
  # -DLOCALEDIR='"/usr/share/locale"'

  echo "————————— ./configure ($arch) —————————"
  ./configure \
    CC=$TOOLCHAIN/bin/clang \
    CXX=$TOOLCHAIN/bin/clang++ \
    CPPFLAGS="--target=$arch-playbit" \
    CFLAGS="--target=$arch-playbit -Wno-deprecated-non-prototype -Wno-parentheses" \
    LDFLAGS="-L$DISTROOT/lib" \
    PKG_CONFIG_LIBDIR=$DISTROOT/lib/pkgconfig \
    PKG_CONFIG_PATH=$DISTROOT/lib/pkgconfig \
    --host=$NATIVE_ARCH-unknown-linux-musl \
    --build=$arch-unknown-linux-musl \
    --prefix=/usr \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    \
    --with-curses \
    --disable-nls \
    --enable-readline \
    --without-bash-malloc \

  echo "————————— make 2> make-err.log > make.log —————————"
  MACHTYPE=$arch-playbit

  # parallel build workarounds
  if ! make MACHTYPE="$MACHTYPE" V=1 y.tab.c \
       1> make.log \
       2> make-err.log
  then
    echo "'make y.tab.c' failed." >&2
    echo "See make-err.log for full log. Last 10 lines:" >&2
    tail -n10 make-err.log >&2
    exit 1
  fi

  if ! make MACHTYPE="$MACHTYPE" V=1 builtins/libbuiltins.a \
       1>> make.log \
       2>> make-err.log
  then
    echo "'make builtins/libbuiltins.a' failed." >&2
    echo "See make-err.log for full log. Last 10 lines:" >&2
    tail -n10 make-err.log >&2
    exit 1
  fi

  if ! make MACHTYPE="$MACHTYPE" V=1 -j$NCPU \
       1>> make.log \
       2>> make-err.log
  then
    echo "'make' failed." >&2
    echo "See make-err.log for full log. Last 10 lines:" >&2
    tail -n10 make-err.log >&2
    exit 1
  fi

  echo "————————— make install DESTDIR=./install > install.log —————————"
  rm -rf install
  mkdir install
  make MACHTYPE="$MACHTYPE" V=1 DESTDIR=$PWD/install install > install.log

  rm install/lib/bash/Makefile.inc
  rm install/lib/bash/Makefile.sample
  rm install/lib/bash/loadables.h
  # strip install/lib/bash/*
  # strip install/bin/bash

  # fi # XXX

  echo "————————— copy source —————————"

  SRC=$PWD
  _pushd "$PLAYBIT_BASH_SRC_DIR"

  echo "Replacing current source at $PWD"
  find . -type f \
    -and -not -path ./Makefile \
    -and -not -path ./upgrade-bash.sh \
    -and -not -path ./bashrc \
    -delete
  find . -type d -empty -delete

  cp $SRC/install/usr/share/man/man1/bash.1 bash.1
  cp $SRC/Makefile bash.make
  cp $SRC/COPYING LICENSE
  cp $SRC/mksignames .
  cp $SRC/mksyntax .
  cp $SRC/*.c .
  cp $SRC/*.h .

  rm -rf include
  cp -R $SRC/include include

  for subdir in \
    builtins \
    lib/glob \
    lib/intl \
    lib/readline \
    lib/sh \
    lib/termcap \
    lib/tilde \
    lib/malloc \
  ;do
    rm -rf $subdir
    mkdir -p $subdir
    for f in $SRC/$subdir/*.def; do
      if [ -e "$f" ]; then cp $SRC/$subdir/*.def $subdir/; fi; break
    done
    for f in $SRC/$subdir/*.s; do
      if [ -e "$f" ]; then cp $SRC/$subdir/*.s $subdir/; fi; break
    done
    for f in $SRC/$subdir/*.h; do
      if [ -e "$f" ]; then cp $SRC/$subdir/*.h $subdir/; fi; break
    done
    for f in $SRC/$subdir/*.sh; do
      if [ -e "$f" ]; then cp $SRC/$subdir/*.sh $subdir/; fi; break
    done
    cp $SRC/$subdir/*.c $subdir/
    cp $SRC/$subdir/Makefile $subdir/
  done

  cp $SRC/lib/readline/COPYING lib/readline/LICENSE

  rm -rf support
  cp -R $SRC/support support

  # update bash.make
  sed -i -E 's/^config.status:.+/config.status:/' bash.make
  sed -i -E 's/^\t\$\(SHELL\) .\/config.status --recheck/\ttouch $@/' bash.make
  sed -i -E 's/^VENDOR = .+$/VENDOR = Playbit/' bash.make
  sed -i -E 's/^MACHTYPE = .+$/MACHTYPE = aarch64-playbit/' bash.make

  _popd


  # echo "————————— list of what's installed in lib/bash/ —————————"
  # ls -1 install/lib/bash | sort

  echo "exit 0"; exit 0
done
