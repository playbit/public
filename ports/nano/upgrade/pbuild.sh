#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!DEP ports/libc
#!DEP ports/libncurses
source /p/tools/pbuild.lib.sh

VERSION=8.3
ARCHIVE_URL=https://www.nano-editor.org/dist/v${VERSION%%.*}/nano-$VERSION.tar.xz
ARCHIVE_SHA256=551b717b2e28f7e90f749323686a1b5bbbd84cfa1390604d854a3ca3778f111e

pbuild_fetch_and_unpack "$ARCHIVE_URL" "$ARCHIVE_SHA256"
./configure \
	--host=$CHOST \
	--build=$CBUILD \
	--prefix=/usr \
	--bindir=/bin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--disable-libmagic \
	--disable-nls \
	--disable-extra \
	--enable-utf8 \
	--enable-year2038

make -j1 V=1 > make.log

# extract compiler invocations
grep -E '^clang ' make.log > make.cc.log

# extract compilation commands
grep -F ' -c ' make.cc.log > make.cc-c.log

# extract lib sources
grep -Ev ' -I../lib\b' make.cc-c.log \
| sed -E 's@^.+/'"'"'`@@' \
| sed -E 's@^.+ ([^ ]+\.c).*$@\1@' \
> lib-srcs-$ARCH.log

# extract src sources
grep -E ' -I../lib\b' make.cc-c.log \
| sed -E 's@^.+ ([^ ]+\.c).*$@\1@' \
> src-srcs-$ARCH.log

CFLAGS_RESC=$(echo "$CFLAGS" | sed 's/[]\/$*.^[]/\\&/g')
CPPFLAGS_RESC=$(echo "$CPPFLAGS" | sed 's/[]\/$*.^[]/\\&/g')

# extract all unique CFLAGS used for ./lib/
grep -Ev ' -I../lib\b' make.cc-c.log \
| sed -E -e 's/`[^`]+`//g' \
         -e 's/ [^ ]+\.T?p?[oc]\b/ /g' \
| sort -u \
| sed -E -e "s|$CFLAGS_RESC\b||g" \
         -e "s|$CPPFLAGS_RESC\b||g" \
         -e 's/^clang //' \
         -e 's/ -[Mco][^ ]*\b//g' \
         -e 's/ -I\.+//g' \
         -e 's/ +/ /g' \
> lib-cflags-$ARCH.log

# extract all unique CFLAGS used for ./src/
grep -E ' -I../lib\b' make.cc-c.log \
| sed -E -e 's/`[^`]+`//g' \
         -e 's/ [^ ]+\.T?p?[oc]\b/ /g' \
| sort -u \
| sed -E "s|$CFLAGS_RESC\b||g" \
| sed -E -e "s|$CFLAGS_RESC\b||g" \
         -e "s|$CPPFLAGS_RESC\b||g" \
         -e 's/^clang //' \
         -e 's/ -[Mco][^ ]*\b//g' \
         -e 's/ -I\.+//g' \
         -e 's/ +/ /g' \
> src-cflags-$ARCH.log

echo "$VERSION" > version.txt
