# Playbit open source

This repository houses open-source software components of Playbit.
Many parts of Playbit are still closed source, though we are committed to opening that source up in the future.


## Setting up for development

With Playbit running, open a terminal on your host machine and do the following
to open a shell in your Playbit workspace and clone the repo:

```
$ ssh root@127.0.0.1 -p 22001 -J root@127.0.0.1:52915
$ git clone https://github.com/playbit/public.git /src && cd /src
```

Software is organized as discreet components called "packages."
For example `ports/libc` and `ports/bash` are two different packages.
A package may depend on other packages [by specifying a dependency in its build script or makefile.](tools/pbuild.md#example)

Packages are built using `tools/pbuild` inside sandboxes (chroot with overlayfs, similar to nix) where their declared dependencies are present. [pbuild](tools/pbuild.md) ensures that packages are built in dependency order.

For example, try building curl:

```
$ tools/pbuild ports/curl
checking sources ...
building ports/libc ...
...
building ports/curl: OK /var/pbuild/ports/curl.arch/out
$ /var/pbuild/ports/curl.$(uname -m)/out/distroot/bin/curl --version
curl 8.7.1 ...
$
```

See [`ports/README.md`](ports/README.md) for details on building & developing ports.

As a convenience for SSH, you may want to add the following to your host's `~/.ssh/config`
so that you can simply type `ssh playbit`:

```
Host playbit
    Hostname  127.0.0.1
    User      root
    Port      22001
    ProxyJump root@127.0.0.1:52915
```


## Installing build products

Since packages are built in sandboxes, they are not installed on the system by default.
This ensures that your workspace stays unaffected.

To install a package to be used in a workspace, ask pbuild to `--install` it for you.

For example, install GVIM:

```
$ tools/pbuild ports/gvim --install=/devel
building ports/gvim.arch: OK /var/pbuild/ports/gvim.arch/out/distroot 32.6M
Install ports/gvim at /home/root/devel
```

You can now go to `/devel/Workspace/Applications` in Playbit and open `GVIM`.

We recommend installing into a separate root `/devel` so that you don't overwrite
libraries and programs in your workspace.


## License

Subdirectories may be covered by specific licenses, declared in files named
"LICENSE.txt" or "COPYING" (or similar.)

All other material in this repository is covered by the Apache 2 license,
which can be found in whole at [`LICENSE.txt`](LICENSE.txt)
