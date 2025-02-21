# /bin/sftp & /usr/libexec/sftp-server from openssh
#
#!BUILDTOOL toolchain
#!DEP ports/openssh
#!DEP ports/libc [transitive]

# "copy" these into our overlayfs layer from the ports/openssh layer
for f in \
	/usr/share/man/man1/sftp.1 \
	/usr/share/man/man8/sftp-server.8 \
	/usr/libexec/sftp-server \
	/bin/sftp \
;do
	cp $DESTDIR$f $DESTDIR$f.tmp
	mv $DESTDIR$f.tmp $DESTDIR$f
done
