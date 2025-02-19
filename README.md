# Playbit ports

This repository contains ports of software not made by Playbit.
Many of these "packages" are built with minimal or no changes,
with source downloaded from the internet as needed.

Some packages have their source "in-tree" which makes it easier for us to audit and often
speeds up the build process considerably (as we don't need to run `./configure` etc.)

Packages are built using the tool `tools/pbuild` inside sandboxes (chroot with overlayfs)
where their declared dependencies are present.
[pbuild](tools/pbuild.md) ensures that packages are built in dependency order.


## Building a port

`tools/pbuild port/PORTNAME` builds `port/PORTNAME` and any outdated dependencies.

Install a port and any runtime dependencies by passing `--install=<dir>` to pbuild.
For example `tools/pbuild --install=$HOME/mypkgs port/PORTNAME` builds & installs `port/PORTNAME` into the root directory `$HOME/mypkgs`. I.e. if `PORTNAME` provides a `bin/example` program, it will be installed at `$HOME/mypkgs/bin/example`

### Makefile alternative

There's a `Makefile` in the ports root which can be used as an alternative to pbuild.
It really just calls pbuild for you.

- `make PORTNAME` is equivalent to `tools/pbuild port/PORTNAME`
- `make DESTDIR=$HOME/mypkgs PORTNAME` is equivalent to `tools/pbuild --install=$HOME/mypkgs port/PORTNAME`
- `make all` builds **_all_** ports


## Adding a new port

- Create a new directory, e.g. `ports/somepkg`
- Create a makefile, e.g. `ports/somepkg/pbuild.mk`
  (can also be named `Makefile` or `pbuild.sh`).
  You may want to copy one from an existing port.
- Declare tools needed at the top of `pbuild.mk` with `#!BUILDTOOL some/package`
- Declare build-time dependencies at the top of `pbuild.mk` with `#!DEP some/package`
- Declare run-time dependencies at the top of `pbuild.mk` with `#!DEP some/package [transitive]`

If you include sources "in-tree", import source files needed, including license file.
Please **do not** import files which aren't needed to build the package.
We will pay for imported files for all eternity since we are using git.

Enter interactive session with pbuild:

```
$ tools/pbuild -i ports/somepkg
ports/somepkg.aarch64: entering interactive shell in sandbox
(chroot) somepkg #
```

Here you can iterate on making your package build.
See `env` for environment variables setup by pbuild.
Dependencies are installed at `$DESTDIR` and the "exported files" of a package should be installed there as well (i.e. `make DESTDIR=$DESTDIR` for make-based projects.)

Once your package is ready, [open a Pull Request…](https://github.com/playbit/ports/compare)


## License

Each package may be covered by a specific license.
The license file is usually called "LICENSE.txt" or "COPYING."

All other material in this repository, like for example `tools/pbuild`,
is covered by the Apache 2 license which can be found in whole at [`LICENSE.txt`](LICENSE.txt)


