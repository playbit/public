# SSH client & server designed for small memory environments
# https://matt.ucc.asn.au/dropbear/dropbear.html
# License: MIT
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc
#!DEP ports/libz
source /p/tools/pbuild.lib.sh

VERSION=2024.86

pbuild_fetch_and_unpack \
	https://matt.ucc.asn.au/dropbear/releases/dropbear-$VERSION.tar.bz2 \
	e78936dffc395f2e0db099321d6be659190966b99712b55c530dd0a1822e0a5e

pbuild_apply_patches

cat << END > localoptions.h
#define DSS_PRIV_FILENAME "/etc/ssh_dss_host_key"
#define RSA_PRIV_FILENAME "/etc/ssh_rsa_host_key"
#define ECDSA_PRIV_FILENAME "/etc/ssh_ecdsa_host_key"
#define ED25519_PRIV_FILENAME "/etc/ssh_ed25519_host_key"
#define INETD_MODE 0
#define DROPBEAR_SMALL_CODE 0
#define DROPBEAR_PATH_SSH_PROGRAM "/bin/ssh"
#define DEFAULT_PATH "/bin"
#define DEFAULT_ROOT_PATH "/sbin:/bin"
END

pbuild_configure_once ./configure \
	--build=$CBUILD \
	--host=$CHOST \
	--prefix=/usr \
	--datadir=/usr/share \
	--bindir=/bin \
	--sbindir=/sbin \
	--libdir=/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	\
	--enable-bundled-libtom \
	\
	--disable-utmp \
	--disable-wtmp \
	--disable-pututline \
	--disable-lastlog \

PROGRAMS="dropbear dropbearconvert dropbearkey dbclient"

make -j$MAXJOBS MULTI=1 SCPPROGRESS=1 PROGRAMS="$PROGRAMS"
make -j$MAXJOBS MULTI=1 SCPPROGRESS=1 PROGRAMS="$PROGRAMS" DESTDIR=$DESTDIR install

rm -f $DESTDIR/sbin/dropbear
mv $DESTDIR/bin/dropbearmulti $DESTDIR/sbin/dropbear
strip $DESTDIR/sbin/dropbear
ln -fs dropbear $DESTDIR/sbin/ssh-server
ln -fs ../sbin/dropbear $DESTDIR/bin/dropbearkey
ln -fs ../sbin/dropbear $DESTDIR/bin/dropbearconvert
ln -fs ../sbin/dropbear $DESTDIR/bin/ssh-keygen
ln -fs ../sbin/dropbear $DESTDIR/bin/ssh
ln -fs ../sbin/dropbear $DESTDIR/bin/scp
