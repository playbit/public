#!/bin/bash
set -euo pipefail
PWD0=$PWD
cd "$(dirname "$0")"
source ../lib.sh
export PATH=$BUILD_TOOLS:$TOOLCHAIN/bin:$PATH
WASI_VERSION=$(grep -F 'WASI_VERSION := ' Makefile | cut -d' ' -f3)
WASI_TAR=$DOWNLOAD/wasi-$WASI_VERSION.tar.gz
WASI_SRC=$BUILD_DIR/wasi-$WASI_VERSION
LIBC_SRC_DIR=$PWD
MAKEFILE_TEMPLATE=$PWD/wasi-makefile-template.mk

# sha256 for wasi sdk-21
download -o "$WASI_TAR" \
  --sha256 4a2a3e3b120ba1163c57f34ac79c3de720a8355ee3a753d81f1f0c58c4cf6017 \
  "https://github.com/WebAssembly/wasi-libc/archive/refs/tags/wasi-$WASI_VERSION.tar.gz"

if [ -e "$LIBC_SRC_DIR/wasi-backup" ]; then
  echo "$0: Refusing to continue: $LIBC_SRC_DIR/wasi-backup exists" >&2
  echo "Delete $LIBC_SRC_DIR/wasi-backup and retry" >&2
  exit 1
fi

if [ -n "${NO_CLEAN:-}" -a -d "$WASI_SRC" ]; then
  _pushd "$WASI_SRC"
else
  echo "Extracting $WASI_TAR to $WASI_SRC"
  rm -rf "$WASI_SRC"
  mkdir -p "$WASI_SRC"
  _pushd "$WASI_SRC"
  tar --strip-components=1 -xzof "$WASI_TAR"
fi

# Silence comments
sed -i -E -e 's/\t#/\t@#/' Makefile

OUT_SYSROOT=$PWD/sysroot-from-recorded-build
if [ -z "${NO_RECORDMAKE:-}" -o ! -f makeout.txt ]; then
  echo "Recording \"make\" ..."
  mkdir -p obj sysroot/share/wasi
  make -j$(nproc) \
    CC="$TOOLCHAIN/bin/clang" \
    AR="$TOOLCHAIN/bin/llvm-ar" \
    NM="$TOOLCHAIN/bin/llvm-nm" \
    SYSROOT="$OUT_SYSROOT" \
    SYSROOT_LIB="$OUT_SYSROOT/lib" \
    SYSROOT_INC="$OUT_SYSROOT/include" \
    SYSROOT_SHARE="$OUT_SYSROOT/share" \
    OBJDIR=obj \
    > makeout.txt
fi

# extract CC invocations
grep "^$TOOLCHAIN/bin/clang .*-c " makeout.txt \
| sort -u \
| sed -E 's/ obj\// $(OBJ)\//g' \
> cc.txt

# extract AR invocations
grep -E "^$TOOLCHAIN/bin/llvm-ar [^ ]+ [^ ]+\.a ." makeout.txt \
| sort -u \
| sed -E "s@$OUT_SYSROOT/@\$(OUT)/@" \
| sed -E 's/ obj\// $(OBJ)\//g' \
> ar.txt

# extract libs from AR invocations
sed -i -E -e 's/\/[^ ]+\/llvm-ar +[crs]+ +//' ar.txt
while IFS= read -r line; do
  echo ${line%% *}
done < ar.txt | sort -u > libs.txt

# find common CC prefix used for all cc invocations
# e.g. "clang -O2 --target=wasm32-wasi -Wall -Wextra"
COMMON_CC_PREFIX=$(awk 'NR==1{p=$0} {while(p != substr($0,1,length(p))){p=substr(p,1,length(p)-1)}} END{print p}' cc.txt)
# strip trailing "-"
case "$COMMON_CC_PREFIX" in
  *-) COMMON_CC_PREFIX=$(echo ${COMMON_CC_PREFIX:0:-1}) ;;
esac

# find included files
rm -f deps-*.txt
i=0
for f in $(find obj -type f -name \*.d); do
  grep '^  ' $f \
  | sed 's/^  //' \
  | sed 's/ \\$//' \
  | grep -v "^$OUT_SYSROOT" \
  | grep -v "^$TOOLCHAIN" \
  >> deps-$i.txt &
  i=$(( i + 1 ))
done
wait
cat deps-*.txt | sort -u > deps.txt
rm -f deps-*.txt

# sum of all involved files; files we need to save
cp deps.txt allfiles.txt
# add cc files
sed -E 's/^.+ -c +([^ ]+).*$$/\1/' cc.txt >> allfiles.txt
# canonicalize filenames
FILTER_PREFIX=$WASI_SRC/
while IFS= read -r f; do
  f=$(realpath "$f")
  case "$f" in
    "$FILTER_PREFIX"*) echo "${f:${#FILTER_PREFIX}}";;
  esac
done < allfiles.txt > allfiles1.txt
# remove duplicates and empty lines
sort -u allfiles1.txt | awk NF > allfiles.txt && rm allfiles1.txt

# # rewrite filenames
# rm -f filemap.txt
# touch filemap.txt
# while IFS= read -r orig; do
#   newname=
#   case "$orig" in
#     libc-bottom-half/cloudlibc/src/libc/*) newname="src/${orig:36}" ;;
#     libc-bottom-half/sources/*)            newname="src/${orig:25}" ;;
#     libc-bottom-half/signal/*)             newname="src/${orig:24}" ;;
#     libc-bottom-half/mman/*)               newname="src/${orig:22}" ;;
#     libc-bottom-half/clocks/*)             newname="src/${orig:24}" ;;
#     libc-bottom-half/*)                    newname="${orig:17}" ;;
#   esac
#   if [ -n "$newname" ]; then
#     if grep -q -F ":$newname" filemap.txt; then
#       echo "Duplicate renamed file: $newname (skipping $orig)" >&2
#     else
#       echo $orig:$newname >> filemap.txt
#     fi
#   fi
# done < allfiles.txt

# copy files
rm -rf /tmp/wasi-upgrade
mkdir -p /tmp/wasi-upgrade
while IFS= read -r src; do
  dst=/tmp/wasi-upgrade/$src
  (mkdir -p "$(dirname "$dst")" && cp "$src" "$dst") &
done < allfiles.txt
wait
rm -f /tmp/wasi-upgrade/include # make sure it doesn't exist (no -r on purpose)
cp -R "$OUT_SYSROOT/include" /tmp/wasi-upgrade/include

# generate makefile
CC_PREFIX=$(echo $COMMON_CC_PREFIX | sed -E "s@$OUT_SYSROOT/@@")
STRIP_CC_PREFIX=$TOOLCHAIN/bin/ # /build/distroot/bin/clang -> clang
CC_PREFIX=${CC_PREFIX:${#STRIP_CC_PREFIX}}
CFLAGS_ALL="-nostdlibinc"
# echo "COMMON_CC_PREFIX=$COMMON_CC_PREFIX"
# echo "CC_PREFIX=$CC_PREFIX $CFLAGS_ALL"

awk \
  -v CC="$CC_PREFIX $CFLAGS_ALL" \
  -v STATIC_LIBS="$(cat libs.txt | xargs echo)" \
'
  {gsub(/@CC@/, CC); gsub(/@STATIC_LIBS@/, STATIC_LIBS); print}
' < "$MAKEFILE_TEMPLATE" > new.mk


# generate "CC" rules
# rm -f odirs.txt
# rm -f ofiles.txt
while IFS= read -r line; do
  line=$(echo $line | sed -E 's/ -M[DP]//g')
  # line=$(echo $line | sed -E 's/ obj\// $(OBJ)\//g')
  srcfile=$(echo "$line" | sed -E 's/^.+ -c +([^ ]+).*$$/\1/')
  ofile=$(echo "$line" | sed -E 's/^.+ -o +([^ ]+).*$$/\1/')
  # echo "$(dirname "$ofile")" >> odirs.txt
  # echo "$ofile" >> ofiles.txt
  case "$line" in
    "$COMMON_CC_PREFIX"*)
      echo "$ofile: | \$(OBJ)/mkdirs.ok" >> new.mk
      echo -e "\t@echo \"CC $srcfile\"" >> new.mk
      echo -e "\t\$(Q)\$(CC) ${line:${#COMMON_CC_PREFIX}}" >> new.mk
      ;;
    *)
      echo -e "\t@echo \"CC $srcfile\"" >> new.mk
      echo "$ofile: | \$(OBJ)/mkdirs.ok" >> new.mk
      echo -e "\t\$(Q)\$(CC) $line" >> new.mk
      ;;
  esac
done < cc.txt
echo >> new.mk

# generate "AR" rules
# We need to unify the ar invocations. WASI's makefile employs a workaround
# for MS Windows that splits up ar into multiple invocation for the same lib.
# echo "cat libs.txt" ; cat libs.txt
while IFS= read -r lib; do
  echo "$lib: \\"
  for obj in $(grep -F "$lib " ar.txt | sed "s@$lib @@g"); do
    echo "  $obj \\"
  done
  echo
done < libs.txt >> new.mk
echo >> new.mk

echo "OBJ_DIRS := \$(OUT)/lib \\" >> new.mk
sed -E 's/^.+ -o +([^ ]+)\/[^\/\]+.*$$/  \1 \\/' cc.txt | sort -u >> new.mk
echo >> new.mk

echo '$(OBJ)/mkdirs.ok: $(OBJ_DIRS)' >> new.mk
echo -e "\t\$(Q)touch \"\$@\"" >> new.mk
echo >> new.mk

echo '$(OBJ_DIRS):' >> new.mk
echo -e "\t\$(Q)mkdir -p \"\$@\"" >> new.mk
echo >> new.mk

echo '$(ALL_LIBS): | $(OBJ_DIRS)' >> new.mk
echo >> new.mk

cp new.mk /tmp/wasi-upgrade/Makefile

# deduplicate files
make -C "$BUILD_TOOLS" dirdedup
echo "Deduplicating files inside wasi tree"
rm -rf /tmp/wasi-upgrade/out
dirdedup -m -v /tmp/wasi-upgrade

# test build
echo "Performing test build (make -C /tmp/wasi-upgrade) ..."
mkdir -p /tmp/wasi-upgrade/out
if ! make -C /tmp/wasi-upgrade -j$(nproc) > /tmp/wasi-upgrade/out/make.log; then
  echo "make FAILED. See /tmp/wasi-upgrade/out/make.log for log" >&2
  exit 1
fi
echo "test build OK"
rm -rf /tmp/wasi-upgrade/out

# copy extra files
for f in $(cd "$WASI_SRC" && find . -type f -name LICENSE\*); do
  case "$f" in
    tools/*) continue;;
  esac
  f=${f:2} # ./foo -> foo
  mkdir -p $(dirname "/tmp/wasi-upgrade/$f")
  cp "$WASI_SRC/$f" "/tmp/wasi-upgrade/$f"
done
cp -R "$OUT_SYSROOT/share" /tmp/wasi-upgrade/share

# replace old libc/wasi directory
if [ -d "$LIBC_SRC_DIR/wasi" ]; then
  mv "$LIBC_SRC_DIR/wasi" "$LIBC_SRC_DIR/wasi-backup"
fi
cp -R /tmp/wasi-upgrade "$LIBC_SRC_DIR/wasi"

# The below is DISABLED since creating symlinks from wasi source to musl source means
# that upgrading musl would require also upgrading wasi (i.e. re-creating wasi dir.)
## create symlinks to musl sources
#echo "Deduplicating files in libc/wasi which are present in libc"
#dirdedup -m -v "$LIBC_SRC_DIR/wasi" "$LIBC_SRC_DIR"

[ -n "${NO_CLEANUP:-}" ] ||
  rm -rf /tmp/wasi-upgrade "$WASI_SRC" "$BUILD_DIR"/wasi-$WASI_VERSION-*

cat << END
——————————————————————————————————————————————————————————————————————————
                           wasi upgrade complete

WASI $WASI_VERSION is now at $LIBC_SRC_DIR/wasi

Now, please test the build:
  make -C $LIBC_SRC_DIR ARCH=wasm32

——————————————————————————————————————————————————————————————————————————
END
