# pbuild

pbuild is a build tool which resolves dependencies by parsing [special comments](#directives)
in `Makefiles` and `pkgbuild.sh` files. It then sets up a sandbox using overlayfs and
runs `make` or `pkgbuild.sh` with `chroot`, capturing modifications in an overlayfs
"upper" directory, called `out`. The `out` directory is then used as a layer ("lowerdir") in
sandboxes of dependants.

pbuild takes a directory as the input, considered a "package".
A package is really just a source directory containing either a `Makefile` or `pkgbuild.sh`
file (referred to as an "index file.")

Dependencies are declared with comments at the beginning of the index file that look like this: `#!DEPENDS some/package`.

Invocation examples:

- `pbuild` -- builds the package in the current directory
- `pbuild example` -- builds a package in the directory `./example`
- `pbuild a b c` -- builds packages a, b and c
- `pbuild -f example` -- builds package `example` even if its output is up-to date with source
- `pbuild -i example` -- enters an interactive shell inside package `example`'s build sandbox
- `pbuild -v example` -- builds package `example` and prints output of build process
- `pbuild -c 'ls -l' example` -- runs shell command `ls -l` inside package `example`'s build sandbox
- `pbuild --list-deps example` -- prints dependencies of package `example`
- `pbuild --clean example` -- builds package `example` from scratch
- `pbuild --arch=x86_64 example` -- builds package `example` for the `x86_64` architecture
- `pbuild --dry-run example` -- simulate build but don't actually build anything
- `pbuild --debug example` -- build with `DEBUG=1` passed to make, using a separate sandbox
- `pbuild --skip-deps example` -- builds package `example` without checking dependencies
- `pbuild -DFOO=bar example` -- builds package `example`, passing `FOO=bar` to `make`


Files & directories:

- All pbuild state & output is placed under a build directory, `/var/pbuild`.
  Build directory can be specified with `--build-dir` and printed with `--print-build-dir`.
  Subsequently, `rm -rf /var/pbuild` resets all state and removes all build products.
- File system modifications from a build are available at `/var/pbuild/PACKAGE/out`.
  Modifications to `/p` (project source root) are available at `/var/pbuild/PACKAGE/srcroot`.
  It's in a different directory simply because `/p` is a separate mount in the sandbox.
- Installed output (exported to dependants) is available at `/var/pbuild/PACKAGE/out/distroot`
- Output from the most recent build invocation is recorded at `/var/pbuild/PACKAGE/build.log`


Files and directories in sandbox:

| Path in sandbox           | Path outside                           | Description
| ------------------------- | -------------------------------------- | ----------------------------
| `/`                       | `/var/pbuild/PACKAGE/out`              | State of PACKAGE
| `/distroot/`              | `/var/pbuild/PACKAGE/out/distroot/`    | Products of PACKAGE
| `/build/pbuild_deps`      | `/var/pbuild/PACKAGE/out/pbuild_deps`  | Status of dependencies
| `/p/`                     | `/var/pbuild/PACKAGE/p/`               | Changes made to project root
| `/p/`                     | `<project source root>/`               | Project root (read only)
| `/build/shared/`          | `/var/pbuild/_pbuild.shared/`          | State shared by all packages
| `/build/shared/download/` | `/var/pbuild/_pbuild.shared/download/` | Downloaded files


Environment variables in sandbox:

| Variable        | Value (example)           | Description
| --------------- | ------------------------- | --------------------------------------------------
| `PBUILD_CHROOT` | `1`                       | Can be used for testing if running in pbuild
| `SRCDIR`        | `/p/some/package`         | Path to package source directory (initial WD)
| `DESTDIR`       | `/distroot`               | Installation prefix for package products
| `BUILDDIR`      | `/build/PACKAGE`          | Directory for build files (just a convenience)
| `DOWNLOAD`      | `/build/shared/download`  | Downloaded files like source archives
| `ARCH`          | `aarch64`                 | Target architecture (DESTDIR/bin, DESTDIR/lib)
| `NATIVE_ARCH`   | `aarch64`                 | Build system architecture (/bin, /lib)
| `NJOBS`         | `30`                      | Max number of parallel processes to run (-j)
| `CHOST`         | `x86_64-unknown-linux`    | Autoconf-compatible `--host=` value
| `CBUILD`        | `aarch64-unknown-linux`   | Autoconf-compatible `--build=` value
| `ASFLAGS`       | `-O2 -g -DNDEBUG`         | Default arguments for assembler
| `CPPFLAGS`      | `-O2 -g -DNDEBUG`         | Default arguments for C pre processor
| `CFLAGS`        | `-O2 -g -DNDEBUG`         | Default arguments for C compiler
| `CXXFLAGS`      | `-O2 -g -DNDEBUG`         | Default arguments for C++ compiler
| `LDFLAGS`       | `--target=x86_64-playbit` | Default arguments for linker

For a complete list, run `env` inside the sanbox, e.g. `pbuild src/rootfs -c env`


## Example

File `example/Makefile`:

```make
#!BUILDTOOL src/cc
#!BUILDTOOL ports/make
#!DEPENDS src/libc
#!DEPENDS ports/libzstd [build]

CFLAGS += -std=c17 -O2 -g --target=$(ARCH)-playbit
$(DESTDIR)/example: example.c
	$(CC) $(CFLAGS) $< -o $@ -lzstd
```

File `example/example.c`:

```c
#include <stdio.h>
int main(int argc, char* argv[]) {
  printf("hello from %s\n", argv[0]);
  return 0;
}
```

Build:

```shell
$ tools/pbuild example
building src/cc-aarch64 needed by example
building src/libc-aarch64 needed by ports/make
building ports/libunwind-aarch64 needed by ports/make
building ports/make-aarch64 needed by ports/libzstd
building ports/libzstd-aarch64 needed by example
building example-aarch64 -> /var/pbuild/example-aarch64/out/distroot
$
```

Test by running the output in the sandbox:

```shell
$ tools/pbuild --skip-deps -c /distroot/example example
hello world from /distroot/example
$
```

We can even enter an interactive session and run it that way:

```shell
$ tools/pbuild --skip-deps -i example
example-aarch64: entering interactive shell in sandbox
(chroot) example $ /distroot/example
hello from /distroot/example
(chroot) example $ ^D
$
```

If we try to build it again, nothing happens since the output is up-to date with the source:

```shell
$ tools/pbuild example
ports/libzstd: checking sources
src/cc: checking sources
src/libc: checking sources
ports/make: checking sources
example: checking sources
ports/libunwind: checking sources
example-aarch64: up-to-date /var/pbuild/example-aarch64/out/distroot
$
```

Modifying any source file of any dependency will trigger a rebuild of anything that depends on it:

```shell
$ touch src/libc/include/stdio.h
$ tools/pbuild example
ports/libunwind: checking sources
ports/libzstd: checking sources
ports/make: checking sources
src/libc: checking sources
example: checking sources
src/cc: checking sources
building src/libc-aarch64 needed by ports/make
building ports/libunwind-aarch64 needed by ports/make
building ports/make-aarch64 needed by ports/libzstd
building ports/libzstd-aarch64 needed by example
building example-aarch64 -> /var/pbuild/example-aarch64/out/distroot
$
```

Notice how not only `example` were rebuilt, but also other dependants of `libc`.


Explanation of pbuild directives in `example/Makefile`:

```make
#!BUILDTOOL src/cc
#!BUILDTOOL ports/make
#!DEPENDS src/libc
#!DEPENDS ports/libzstd [build]
...
```

- `#!BUILDTOOL src/cc`
  means "I need the package `src/cc` installed at / for the host architecture"
  In this example it's a C compiler.

- `#!BUILDTOOL ports/make`
  means "I need the package `ports/make` installed at / for the host architecture"

- `#!DEPENDS src/libc`
  means "I need the package `src/libc` installed at /distroot for the target architecture,
  both at runtime and when building."
  In this example the program being built presumably needs libc.so available at runtime
  and libc headers for building.

- `#!DEPENDS ports/libzstd [build]`
  means "I need the package `ports/libc` installed at /distroot for the target architecture,
  but only when building."
  In this example libzstd is presumably a static library that is linked into a program
  and so it is not needed later when running the program built by this example.

Package paths in directives are relative to the project source root (ie. `/p`),
not the package which contains the index file with the directives.

You can name a subdirectory as a package by prefixing its path with `./`;
e.g. `./subdir` is interpreted as `{dirname(indexfile)/subdir}`.

Relative paths to parent directories (ie `../`) are not supported as it would cause
hard-to-debug issues when a package is renamed. Instead, when a package's name changes,
do a project-wide search-and-replace.
For example: `git grep '!DEPENDS src/libc\b' -- \*/Makefile`


## `/build/pbuild_deps`

In the sandbox, while building a package, the status of its dependencies are available
in the text file `/build/pbuild_deps`.
Each line lists one dependency and has the following format:

    status name.arch prev_checksum curr_checksum

`status` field:

| Value | Description
| ----- | --------------------------------------------------
| `A`   | Added. This dependency was not present in a previous build
| `D`   | Deleted. This dependency is no longer present, but was used in a previous build
| `M`   | Modified. This dependency changed
| `-`   | No change. This dependency has not changed

Examples:

    A all/alice.aarch64 - 967babee58a70ba0f801
    M bar/bob.aarch64 8648467f721a9d8b7a2a 8d39fadf1d3680572504
    D cat/cari.aarch64 b4428025cf804b264748 -
    - day/dan.aarch64 3d639efc03934901f1de 3d639efc03934901f1de

This file can be queried in advances scenarios to find out what has changed.
For example:

- List deps that differ from previous run: `grep '^[AMD]' /build/pbuild_deps`

- Find out if a specific dependency is up to date:
  `grep -q '^- some/dep.arch ' /build/pbuild_deps`
  (exit status of `grep` will be 0 if `some/dep.arch` is up to date, 1 if not)



## Directives

Here's a list of directives supported by pbuild.
They are declared as comments in index files, e.g. `#!DIRECTIVE`

Some directives can be followed by a boolean expression that conditionally enables the directive.
For example:

    DEPENDS bar
    DEPENDS cat if ARCH == 'wasm32'

`cat` is only considered a directive when building for `wasm32`


### DEPENDS

- `DEPENDS <dep>` declares that package `<dep>` is required to build the current package.
  `<dep>` will be included when building the current package, but it won't be included
  by other packages that depend on the current package. I.e. not a transitive.

- `DEPENDS <dep> [transitive]` declares a transitive dependency.
  It communicates that `<dep>` is required in order to use the output of the current package,
  in addition to building it. This is used for both programs and libraries.

  - Program example: `make` needs `libc.so` to run,
    so `make` declares `DEPENDS libc [transitive]`,
    causing `libc` to be included whenever `make` is used.

  - Library example: To link with `libc++abi.a` you also need to link `libunwind.a`,
    so `libcxxabi` declares a transive dependency on `libunwind`.

- `DEPENDS <dep> [run]` is an alias for `DEPENDS <dep> [transitive]`

`DEPENDS` can be followed by a conditional expression.


### BUILDTOOL

`BUILDTOOL <package>` declares that `<package>` for the build host's architecture
is required to be installed at `/` to build the current package.
Can be followed by a conditional expression.

BUILDTOOL declaration are not transitive.
If a BUILDTOOL needs other things to run it should itself declare transitive dependencies.

For example:
- `example/Makefile`: `#!BUILDTOOL make`
- `make/Makefile`: `#!DEPENDS libc [transitive]`

When we build `example`, both `make` and `libc` will be included since `make` needs `libc` to run.


### ARCHDEPENDS

`ARCHDEPENDS <dep> <arch> <mountpoint>` declares that `<dep>` architecture `<arch>`
is required to be installed at `<mountpoint>` to build the current package.
Can be followed by a conditional expression.

This is rarely useful. It's currently only used by system-image to pull in sysroots
for foreign architectures.


### ENV

`ENV <key>=<value>` causes the environment variable `<key>=<value>` to be set for dependants.
The special string `${DESTDIR}` in `<value>` is replaced by the actual destination directory.

For example, `pkg-config` sets `PKG_CONFIG_PATH=${DESTDIR}/lib/pkgconfig` so that when other
packages use `pkg-config` as a BUILDTOOL, libraries are found.


### IGNORE

`IGNORE <path>` declares that file or directory tree at `<path>` should be ignored when
scanning for source files (to determine if the package needs to be rebuilt).
Can be followed by a conditional expression.


### CHECK

`CHECK <path>` declares that file or directory tree at `<path>` should be included when
scanning for source files (to determine if the package needs to be rebuilt).
`<path>` should be outside the package directory, since files inside the package directory
are automatically considered source files.


### METAPACKAGE

`METAPACKAGE` declares that the package has no build phase and no source files.
It is merely a group of dependencies.


### BOOTSTRAP

`BOOTSTRAP` declares that the package needs pre-built coreutils, runtime linker and libc
in order to build.
This is used when building the compiler, libc and busybox and is not needed by any other packages.
