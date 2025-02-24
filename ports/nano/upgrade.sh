#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# for arch in aarch64; do
for arch in aarch64 x86_64; do
	echo "pbuild --arch=$arch --clean ./upgrade"
	../../tools/pbuild --arch=$arch --clean ./upgrade
	out=$(../../tools/pbuild --arch=$arch ./upgrade --print-out-dir)/build/upgrade
	cp $out/config.h          config-$arch.h
	cp $out/lib/libc-config.h libc-config-$arch.h
	#cp $out/Makefile          Makefile-$arch.mk
	echo ""
	echo "# $arch"
	echo -n "LIB_CFLAGS := "; cat $out/lib-cflags-$arch.log
	echo -n "EXE_CFLAGS := "; cat $out/src-cflags-$arch.log
	echo ""
done

echo "SRCS := \\"
cat $out/lib-srcs-$arch.log | awk '{print "\tlib/" $1 " \\"}'
cat $out/src-srcs-$arch.log | awk '{print "\tsrc/" $1 " \\"}'
echo ""

# set -x

rm -rf lib src syntax
mkdir -p lib src syntax

for f in $(cd $out/lib && find . -type f -name \*.h -or -name \*.c); do
	case "$f" in
		*config.h) ;;
		*) install -D -m0644 $out/lib/$f lib/$f ;;
	esac
done
# for f in $(cat $out/lib-srcs-$arch.log); do
# 	install -D -m0644 $out/lib/$f lib/$f
# done

for f in $(cd $out/src && find . -type f -name \*.h -or -name \*.c); do
	case "$f" in
		*config.h) ;;
		*) install -D -m0644 $out/src/$f src/$f ;;
	esac
done
# for f in $(cat $out/src-srcs-$arch.log); do
# 	install -D -m0644 $out/src/$f src/$f
# done

rm syntax/*.nanorc
cp $out/syntax/*.nanorc syntax/

# cp $out/doc/sample.nanorc.in stock-nanorc

cp $out/doc/nano.1 nano.1
sed -E -i \
	-e 's/(VERSION *\:= *)(.+)$/\1'"$(cat $out/version.txt)"'/' \
	Makefile
