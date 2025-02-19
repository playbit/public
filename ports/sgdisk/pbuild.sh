# Text-mode partitioning tool for Globally unique identifier Partition Table (GPT) disks
# https://www.rodsbooks.com/gdisk
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libncurses
#!DEP ports/libc [transitive]
#!DEP ports/libcxx
#!DEP ports/popt
#!DEP ports/util-linux
# note: uses libuuid.a from util-linux
#
source /p/tools/pbuild.lib.sh

VERSION=1.0.10

pbuild_fetch_and_unpack \
	https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/$VERSION/gptfdisk-$VERSION.tar.gz \
	2abed61bc6d2b9ec498973c0440b8b804b7a72d7144069b5a9209b2ad693a282

pbuild_apply_patches

make -j$MAXJOBS

# gptfdisk provides gdisk, cgdisk, sgdisk and fixparts, but we only install gdisk and sgdisk
install -v -D -m0644 -t $DESTDIR/usr/share/man/man8 gdisk.8 sgdisk.8
install -v -D -m0755 -t $DESTDIR/bin                gdisk sgdisk
