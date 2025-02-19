#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH

VERSION=$(grep -F 'VERSION := ' Makefile | cut -d' ' -f3)
TAR=$DOWNLOAD/openldap-$VERSION.tgz

if [ ! -f /tmp/openldap-$VERSION/configure ]; then
  # alt. use src:
  # https://git.openldap.org/openldap/openldap/-/archive/master/openldap-master.tar.gz
  download -o "$TAR" \
    --sha256 48969323e94e3be3b03c6a132942dcba7ef8d545f2ad35401709019f696c3c4e \
    "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-$VERSION.tgz"
  rm -rf /tmp/openldap-$VERSION
  mkdir -p /tmp/openldap-$VERSION
  echo "Extracting $TAR"
  tar -C /tmp/openldap-$VERSION --strip-components=1 -xof "$TAR"
fi

SRC=/tmp/openldap-$VERSION/libraries/liblmdb

echo "Removing current sources from ./"
find . \
  -type f \
  -and -not -path ./Makefile \
  -and -not -path ./cmd/Makefile \
  -and -not -path "./$(basename "$0")" \
  -delete
find . -type d -empty -delete

cp $SRC/LICENSE .
cp $SRC/lmdb.h .
cp $SRC/mdb.c .
cp $SRC/midl.c .
cp $SRC/midl.h .

mkdir cmd
cp $SRC/mdb_*.c $SRC/mdb_*.1 cmd/

cp $SRC/Makefile upstream-makefile.make

[ -n "${NO_CLEANUP:-}" ] || rm -rf /tmp/openldap-$VERSION
