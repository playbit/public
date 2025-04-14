# QUIC library
# https://github.com/microsoft/msquic
# license: MIT
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#!BUILDTOOL ports/git
#!BUILDTOOL ports/cmake
#!BUILDTOOL ports/perl
#
#!DEP ports/libc [transitive]
#!DEP ports/openssl [transitive]
#!DEP ports/libcxx
#
# note: perl is needed by submodules/openssl3 during its configuration phase
#
source /p/tools/pbuild.lib.sh

VERSION=2.4.8
SRCDIR=$PWD

if [ ! -e "$BUILDDIR/pb_clone_ok" ]; then
	rm -rf "$BUILDDIR"
	mkdir -p "$(dirname "$BUILDDIR")"
	git clone --depth=1 -b v$VERSION -c advice.detachedHead=false \
		https://github.com/microsoft/msquic.git \
		"$BUILDDIR"
	cd "$BUILDDIR"

	# Clone submodule openssl3 (github.com/quictls/openssl.git)
	# msquic documentation suggests a recursive clone, but that pulls down a TON of files
	# from 10 different repos. However, only cloning submodules/openssl3 seems to be enough
	# to build msquic for our configuration.
	#
	# git submodule update --init --recursive --depth 1 submodules/openssl3
	#   submodules/openssl3                     github.com/quictls/openssl.git
	#   submodules/openssl3/gost-engine         github.com/gost-engine/engine
	#   submodules/openssl3/krb5                github.com/krb5/krb5
	#   submodules/openssl3/oqs-provider        github.com/open-quantum-safe/oqs-provider.git
	#   submodules/openssl3/pyca-cryptography   github.com/pyca/cryptography.git
	#   submodules/openssl3/python-ecdsa        github.com/tlsfuzzer/python-ecdsa
	#   submodules/openssl3/tlsfuzzer           github.com/tlsfuzzer/tlsfuzzer
	#   submodules/openssl3/tlslite-ng          github.com/tlsfuzzer/tlslite-ng
	#   submodules/openssl3/wycheproof          github.com/google/wycheproof
	#   submodules/openssl3/gost-engine/libprov github.com/provider-corner/libprov.git
	#
	git submodule update --init --depth 1 submodules/openssl3

	sed -i 's/ -Werror / /g' CMakeLists.txt
	touch pb_clone_ok
else
	cd "$BUILDDIR"
fi

pbuild_configure_once \
	cmake -S . -B build \
		-DQUIC_BUILD_SHARED=OFF \
		-DQUIC_TLS=openssl3 \
		-DCMAKE_C_FLAGS=-Wno-invalid-unevaluated-string

cmake --build build

DESTDIR=$DESTDIR cmake --install build --prefix /usr

# remove unwanted Windows-specific header file
rm -f $DESTDIR/usr/include/msquic_winuser.h

# remove unwanted cmake file
rm -f $DESTDIR/usr/share/msquic/msquic-config.cmake
find $DESTDIR/usr/share/msquic -empty -type d -delete

echo "INSTALL $DESTDIR/lib/pkgconfig/msquic.pc"
sed "s/@VERSION@/$VERSION/" $SRCDIR/msquic.pc > $DESTDIR/lib/pkgconfig/msquic.pc
