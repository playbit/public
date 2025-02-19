# IANA timezone data
# https://www.iana.org/time-zones
# license: public domain
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
source /p/tools/pbuild.lib.sh

VERSION=2024b

download --sha256 5e438fc449624906af16a18ff4573739f0cda9862e5ec28d3bcb19cbaed0f672 \
	https://www.iana.org/time-zones/repository/releases/tzcode${VERSION}.tar.gz

download --sha256 70e754db126a8d0db3d16d6b4cb5f7ec1e04d5f261255e4558a67fe92d39e550 \
	https://www.iana.org/time-zones/repository/releases/tzdata${VERSION}.tar.gz

rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"
tar -C "$BUILDDIR" -xof "$DOWNLOAD/tzcode${VERSION}.tar.gz"
tar -C "$BUILDDIR" -xof "$DOWNLOAD/tzdata${VERSION}.tar.gz"
cd "$BUILDDIR"

make -j$MAXJOBS \
	cc="$CC" \
	CFLAGS="$CFLAGS -DHAVE_STDINT_H=1" \
	TZDIR="/usr/share/timezone"

rm -rf "$DESTDIR"/usr/share/timezone
mkdir -p "$DESTDIR"/usr/share/timezone

# Note: See ./zic.8.txt for usage
./zic -d "$DESTDIR"/usr/share/timezone -L leapseconds \
	africa \
	antarctica \
	asia \
	australasia \
	europe \
	northamerica \
	southamerica \
	etcetera \
	backward

# Note: ./zone.tab is the legacy ASCII-only database, zone1970.tab is the new UTF-8 one
install -v -m444 zone1970.tab "$DESTDIR"/usr/share/timezone/zone.tab
install -v -m444 iso3166.tab "$DESTDIR"/usr/share/timezone/iso3166.tab
ln -sf zone.tab "$DESTDIR"/usr/share/timezone/zone1970.tab

strip zdump
install -D -m755 zdump "$DESTDIR"/sbin/tzdump
sed -E 's/\bzdump\b/tzdump/' zdump.8 > tzdump.8
install -D -m644 tzdump.8 "$DESTDIR"/usr/share/man/man8/tzdump.8
