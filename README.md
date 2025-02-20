# Playbit open source

This repository serves two purposes:
1. Houses open-source software components of Playbit
2. Public bug tracker: Please [file issues](https://github.com/playbit/public/issues) with care and love.


## Setting up for development

For Playbit 0.7.x and older, you need to connect a terminal from your host machine into playbit's root system.
With playbit running, open a terminal on your host machine, `cd` to this `ports` directory and run `tools/root-vconsole`:

```shell
$ tools/root-vconsole
Connecting to Playbit root system console...
Press RETURN if you don't see a prompt. Press ctrl-Q to end session.
Set terminal size with: stty rows 38 cols 80
~ $ grep -F PRETTY_NAME /etc/os-release
PRETTY_NAME="Playbit v0.7.1"
~ $ git clone https://github.com/playbit/pb.git
~ $ cd pb
```

Software is organized as discreet components called "packages."
For example `ports/libc` and `ports/bash` are two different packages.
A package may depend on other packages [by specifying a dependency in its build script or makefile.](tools/pbuild.md#example)

Packages are built using `tools/pbuild` inside sandboxes (chroot with overlayfs, similar to nix) where their declared dependencies are present. [pbuild](tools/pbuild.md) ensures that packages are built in dependency order.

For example, try building curl:

```shell
~ $ tools/pbuild ports/curl
checking sources ...
building ports/libc ...
...
building ports/curl: OK /var/pbuild/ports/curl.ARCH/out
~ $ /var/pbuild/ports/curl.$(uname -m)/out/distroot/bin/curl --version
curl 8.7.1 ...
~ $
```

See [`ports/README.md`](ports/README.md) for details on building & developing ports.


## License

Subdirectories may be covered by specific licenses, declared in files named
"LICENSE.txt" or "COPYING" (or similar.)

All other material in this repository is covered by the Apache 2 license,
which can be found in whole at [`LICENSE.txt`](LICENSE.txt)
