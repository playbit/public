set -eo pipefail

SRCDIR=$PWD; PKG_SRCDIR=$SRCDIR
PBUILD_SCRIPT=$SRCDIR/$(basename "$0")
PROG=$0


_err() { echo "$PROG: $1" >&2; exit 1; }


pbuild_file_is_older() { # <subj-file> <ref-file>
	[ ! -e "$1" -o "$2" -nt "$1" ]
}


pbuild_unzip() { # <archive> <outdir>
	# unzip program lacks a feature like tar's --strip-components so we do this
	local ARCHIVE=$1
	local OUTDIR=$2
	local OUTDIR_TMP=$OUTDIR.unzip.tmp
	rm -rf "$OUTDIR_TMP"
	mkdir -p "$OUTDIR_TMP"
	unzip -q -d "$OUTDIR_TMP" "$ARCHIVE"
	# check if multiple files were extracted
	if /bin/ls -x /build/sqlite | grep -F ' ' -q; then
		rm -rf "$OUTDIR_TMP"
		_err "pbuild_unzip: ${ARCHIVE##*/} contains multiple files"
	fi
	# cp -aT "$OUTDIR_TMP"/* "$OUTDIR"
	local SRCDIR f name
	for f in $OUTDIR_TMP/*; do
		SRCDIR=$f
	done
	for f in "$SRCDIR"/*; do
		name=${f:$((${#SRCDIR}+1))} # e.g. /foo/bar.unzip/lol/cat => lol/cat
		mkdir -p "$OUTDIR/$(dirname "$name")"
		mv "$f" "$OUTDIR/$name"
	done
	rm -rf "$OUTDIR_TMP"
}


pbuild_unpack() { # <archive> <outdir>
	local ARCHIVE=$1
	local OUTDIR=${2:-$BUILDDIR}
	mkdir -p "$OUTDIR"
	echo "Extracting ${ARCHIVE##*/} -> $OUTDIR"
	case "$ARCHIVE" in
		*.tar*) tar -C "$OUTDIR" --strip-components=1 -xof "$ARCHIVE" ;;
		*.zip)  pbuild_unzip "$ARCHIVE" "$OUTDIR" ;;
		*)      _err "pbuild_unpack: unsupported archive format: ${ARCHIVE##*/}" ;;
	esac
}


pbuild_fetch_and_unpack() { # <url> <sha256> [<archivefile>]
	local URL=$1
	local SHA256=$2
	local ARCHIVE
	case "${3:-}" in
		"")  ARCHIVE=$DOWNLOAD/$(basename "$URL");;
		*/*) ARCHIVE=$3;;
		*)   ARCHIVE=$DOWNLOAD/$3;;
	esac
	if [ ! -f "$BUILDDIR/pbuild_fetch_and_unpack.stamp" ]; then
		download -o "$ARCHIVE" --sha256 "$SHA256" "$URL"
		rm -rf "$BUILDDIR"
		pbuild_unpack "$ARCHIVE" "$BUILDDIR"
		touch "$BUILDDIR/pbuild_fetch_and_unpack.stamp"
	fi
	cd "$BUILDDIR"
	echo "Changed directory to $PWD"
}


pbuild_apply_patches() { # [<patch-source-dir> [<patch-stamp-file>]]
	local DIR=${1:-$PKG_SRCDIR}
	local STAMP=${2:-$BUILDDIR/pbuild_apply_patches.stamp}
	local f
	if [ ! -f "$STAMP" ]; then
		for f in $(find "$DIR" -type f -name \*.patch | xargs -n1 echo | sort); do
			patch -p1 < "$f"
		done
		mkdir -p "$(dirname "$STAMP")"
		touch "$STAMP"
	fi
}


pbuild_run_once() { # <cmd> [<arg> ...]
	local CHECKSUM=$(printf "$@" | sha1sum | cut -d' ' -f1)
	CHECKSUM=${CHECKSUM% *} # "abc -" => "abc"
	local MARK="$BUILDDIR/pbuild_run_once.$CHECKSUM.mark"
	local _f
	if [ -e "$MARK" ]; then
		echo "[pbuild] $1 skipped ('rm $BUILDDIR/pbuild_run_once.*' to re-run)"
	else
		# use env in case command has leading env vars, e.g. "FOO=1 cmd arg" (except for functions)
		case "$(type $1)" in
			*function) "$@" ;;
			*)         env "$@" ;;
		esac
		mkdir -p "$BUILDDIR"
		touch "$MARK"
	fi
}


pbuild_configure_once() { # <cmd> [<arg> ...]
	local CHECKSUM=$(echo "$@" | sha1sum | cut -d' ' -f1)
	CHECKSUM=${CHECKSUM% *} # "abc -" => "abc"
	local MARK=$BUILDDIR/pbuild_configure_once.$CHECKSUM.mark
	if [ -e "$MARK" ]; then
		echo "[pbuild] $1 skipped ('rm $BUILDDIR/pbuild_configure_once.*' to reconfigure)"
	else
		# use env in case command has leading env vars, e.g. "FOO=1 cmd arg" (except for functions)
		case "$(type $1)" in
			*function) "$@" ;;
			*)         env "$@" ;;
		esac
		mkdir -p "$BUILDDIR"
		touch "$MARK"
	fi
}


pbuild_checksum_files() { # <file> ...
	local paths=$(find $SRCDIR -type f -not -name .\*)
	local path
	for path in "$@"; do
		[ -e "$path" ] || path=/dev/null
		paths="$paths $path"
	done
	sha256sum $paths | sha256sum | cut -d' ' -f1
}
