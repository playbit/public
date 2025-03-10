# Playbit open source

This repository houses open-source software components of Playbit.
Many parts of Playbit are still closed source, though we are committed to opening that source up in the future.


## Setting up for development

For Playbit 0.7.x and older, you need to connect a terminal from your host machine into Playbit's root system.

To make this connection, `root-vconsole` depends on [`socat`](https://linux.die.net/man/1/socat). Install `socat` on your host machine via your preferred method:

```
$ brew install socat

$ apt install socat

$ apk add socat

$ pacman -S socat

$ pkg install socat
```

Then, with Playbit running, open a terminal on your host machine and do the following:

```
$ curl -L#O https://github.com/playbit/pb-src/raw/refs/heads/main/tools/root-vconsole
$ chmod +x root-vconsole
$ ./root-vconsole
Connecting to Playbit root system console...
Press RETURN if you don't see a prompt. Press ctrl-Q to end session.
Set terminal size with: stty rows 38 cols 80
$ git clone https://github.com/playbit/pb-src.git
$ cd pb-src
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
building ports/curl: OK /var/pbuild/ports/curl.ARCH/out
$ /var/pbuild/ports/curl.$(uname -m)/out/distroot/bin/curl --version
curl 8.7.1 ...
$
```

See [`ports/README.md`](ports/README.md) for details on building & developing ports.


## Installing build products

Since packages are built in sandboxes, they are not installed on the system by default.
This ensures that your workspace stays unaffected.

To install a package to be used in a workspace, ask pbuild to `--install` it for you.
For example to install GVIM:

```
$ tools/pbuild ports/gvim --install=$HOME/ws_S/upper/devel
building ports/gvim.aarch64: OK /var/pbuild/ports/gvim.aarch64/out/distroot 32.6M
Install ports/gvim at /home/root/ws_S/upper/devel
```

You can now go to `/devel/Workspace/Applications` in Playbit and open `GVIM`.

We recommend installing into a separate root `$HOME/ws_S/upper/devel` so that you don't overwrite
libraries and programs in your workspace.

However, workspace files can recovered even if you accidentally do `rm -rf /` in a workspace.
This is possible because each workspace stores file system modifications as a "difference layer"
rather than actually removing or changing system files.
A workspace's file changes can be managed from the root system at `/home/root/ws_S/upper`.

- To install software from source directly into your workspace:
  `tools/pbuild ports/gvim --install=$HOME/ws_S/upper`
- To recover an accidentally deleted file: `rm /home/root/ws_S/upper/PATH/TO/DELETED/FILE`
- To completely reset a workspace: `rm -r /home/root/ws_S/upper/*`
  **DANGER!** Removes any files you may have created


## License

Subdirectories may be covered by specific licenses, declared in files named
"LICENSE.txt" or "COPYING" (or similar.)

All other material in this repository is covered by the Apache 2 license,
which can be found in whole at [`LICENSE.txt`](LICENSE.txt)
