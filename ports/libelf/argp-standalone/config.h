/* Enable GNU extensions on systems that have them.  */
#ifndef _GNU_SOURCE
# undef _GNU_SOURCE
#endif

#define HAVE_CONFIG_H 1

#define HAVE_UNISTD_H
#define HAVE_ALLOCA_H 1

#define HAVE_EX_USAGE

#define HAVE_ASPRINTF 1
#define HAVE_STRCHRNUL 0
#define HAVE_STRNDUP 1
#define HAVE_MEMPCPY 0

#define HAVE_DECL_PROGRAM_INVOCATION_NAME 0
#define HAVE_DECL_PROGRAM_INVOCATION_SHORT_NAME 0

#define HAVE_DECL_FWRITE_UNLOCKED 1
/* #undef HAVE_DECL_CLEARERR_UNLOCKED */
/* #undef HAVE_DECL_FEOF_UNLOCKED */
/* #undef HAVE_DECL_FERROR_UNLOCKED */
/* #undef HAVE_DECL_FFLUSH_UNLOCKED */
/* #undef HAVE_DECL_FGETS_UNLOCKED */
#define HAVE_DECL_FPUTC_UNLOCKED 1
#define HAVE_DECL_FPUTS_UNLOCKED 0
#define HAVE_DECL_FLOCKFILE 1
#define HAVE_DECL_PUTC_UNLOCKED 1

#if __GNUC__ && HAVE_GCC_ATTRIBUTE
# define NORETURN __attribute__ ((__noreturn__))
# define PRINTF_STYLE(f, a) __attribute__ ((__format__ (__printf__, f, a)))
# define UNUSED __attribute__ ((__unused__))
#else
# define NORETURN
# define PRINTF_STYLE(f, a)
# define UNUSED
#endif