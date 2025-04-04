https://git.openldap.org/openldap/openldap/-/tree/mdb.master/libraries/liblmdb

LMDB is compact, fast, powerful, and robust and implements a simplified
variant of the BerkeleyDB (BDB) API. (BDB is also very powerful, and verbosely
documented in its own right.) After reading this page, the main
\ref mdb documentation should make sense. Thanks to Bert Hubert
for creating the
<a href="https://github.com/ahupowerdns/ahutils/blob/master/lmdb-semantics.md">
initial version</a> of this writeup.

Everything starts with an environment, created by #mdb_env_create().
Once created, this environment must also be opened with #mdb_env_open().

#mdb_env_open() gets passed a name which is interpreted as a directory
path. Note that this directory must exist already, it is not created
for you. Within that directory, a lock file and a storage file will be
generated. If you don't want to use a directory, you can pass the
#MDB_NOSUBDIR option, in which case the path you provided is used
directly as the data file, and another file with a "-lock" suffix
added will be used for the lock file.

Once the environment is open, a transaction can be created within it
using #mdb_txn_begin(). Transactions may be read-write or read-only,
and read-write transactions may be nested. A transaction must only
be used by one thread at a time. Transactions are always required,
even for read-only access. The transaction provides a consistent
view of the data.

Once a transaction has been created, a database can be opened within it
using #mdb_dbi_open(). If only one database will ever be used in the
environment, a NULL can be passed as the database name. For named
databases, the #MDB_CREATE flag must be used to create the database
if it doesn't already exist. Also, #mdb_env_set_maxdbs() must be
called after #mdb_env_create() and before #mdb_env_open() to set the
maximum number of named databases you want to support.

Note: a single transaction can open multiple databases. Generally
databases should only be opened once, by the first transaction in
the process. After the first transaction completes, the database
handles can freely be used by all subsequent transactions.

Within a transaction, #mdb_get() and #mdb_put() can store single
key/value pairs if that is all you need to do (but see \ref Cursors
below if you want to do more).

A key/value pair is expressed as two #MDB_val structures. This struct
has two fields, \c mv_size and \c mv_data. The data is a \c void pointer to
an array of \c mv_size bytes.

Because LMDB is very efficient (and usually zero-copy), the data returned
in an #MDB_val structure may be memory-mapped straight from disk. In
other words <b>look but do not touch</b> (or free() for that matter).
Once a transaction is closed, the values can no longer be used, so
make a copy if you need to keep them after that.

## Cursors

To do more powerful things, we must use a cursor.

Within the transaction, a cursor can be created with #mdb_cursor_open().
With this cursor we can store/retrieve/delete (multiple) values using
#mdb_cursor_get(), #mdb_cursor_put(), and #mdb_cursor_del().

#mdb_cursor_get() positions itself depending on the cursor operation
requested, and for some operations, on the supplied key. For example,
to list all key/value pairs in a database, use operation #MDB_FIRST for
the first call to #mdb_cursor_get(), and #MDB_NEXT on subsequent calls,
until the end is hit.

To retrieve all keys starting from a specified key value, use #MDB_SET.
For more cursor operations, see the \ref mdb docs.

When using #mdb_cursor_put(), either the function will position the
cursor for you based on the \b key, or you can use operation
#MDB_CURRENT to use the current position of the cursor. Note that
\b key must then match the current position's key.

@subsection summary Summarizing the Opening

So we have a cursor in a transaction which opened a database in an
environment which is opened from a filesystem after it was
separately created.

Or, we create an environment, open it from a filesystem, create a
transaction within it, open a database within that transaction,
and create a cursor within all of the above.

Got it?

## Threads and Processes

LMDB uses POSIX locks on files, and these locks have issues if one
process opens a file multiple times. Because of this, do not
#mdb_env_open() a file multiple times from a single process. Instead,
share the LMDB environment that has opened the file across all threads.
Otherwise, if a single process opens the same environment multiple times,
closing it once will remove all the locks held on it, and the other
instances will be vulnerable to corruption from other processes.

Also note that a transaction is tied to one thread by default using
Thread Local Storage. If you want to pass read-only transactions across
threads, you can use the #MDB_NOTLS option on the environment.

## Transactions, Rollbacks, etc.

To actually get anything done, a transaction must be committed using
#mdb_txn_commit(). Alternatively, all of a transaction's operations
can be discarded using #mdb_txn_abort(). In a read-only transaction,
any cursors will \b not automatically be freed. In a read-write
transaction, all cursors will be freed and must not be used again.

For read-only transactions, obviously there is nothing to commit to
storage. The transaction still must eventually be aborted to close
any database handle(s) opened in it, or committed to keep the
database handles around for reuse in new transactions.

In addition, as long as a transaction is open, a consistent view of
the database is kept alive, which requires storage. A read-only
transaction that no longer requires this consistent view should
be terminated (committed or aborted) when the view is no longer
needed (but see below for an optimization).

There can be multiple simultaneously active read-only transactions
but only one that can write. Once a single read-write transaction
is opened, all further attempts to begin one will block until the
first one is committed or aborted. This has no effect on read-only
transactions, however, and they may continue to be opened at any time.

## Duplicate Keys

#mdb_get() and #mdb_put() respectively have no and only some support
for multiple key/value pairs with identical keys. If there are multiple
values for a key, #mdb_get() will only return the first value.

When multiple values for one key are required, pass the #MDB_DUPSORT
flag to #mdb_dbi_open(). In an #MDB_DUPSORT database, by default
#mdb_put() will not replace the value for a key if the key existed
already. Instead it will add the new value to the key. In addition,
#mdb_del() will pay attention to the value field too, allowing for
specific values of a key to be deleted.

Finally, additional cursor operations become available for
traversing through and retrieving duplicate values.

## Some Optimization

If you frequently begin and abort read-only transactions, as an
optimization, it is possible to only reset and renew a transaction.

#mdb_txn_reset() releases any old copies of data kept around for
a read-only transaction. To reuse this reset transaction, call
#mdb_txn_renew() on it. Any cursors in this transaction must also
be renewed using #mdb_cursor_renew().

Note that #mdb_txn_reset() is similar to #mdb_txn_abort() and will
close any databases you opened within the transaction.

To permanently free a transaction, reset or not, use #mdb_txn_abort().

## Cleaning Up

For read-only transactions, any cursors created within it must
be closed using #mdb_cursor_close().

It is very rarely necessary to close a database handle, and in
general they should just be left open.
