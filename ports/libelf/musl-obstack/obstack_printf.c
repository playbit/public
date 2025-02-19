#include <stdarg.h>
#include <stdio.h>
#include <strings.h>
#include "obstack.h"

int obstack_printf(struct obstack *obstack, const char *__restrict fmt, ...)
{
	char buf[1024];
	va_list ap;
	int len;

	va_start(ap, fmt);
	len = vsnprintf(buf, sizeof(buf), fmt, ap);
	obstack_grow(obstack, buf, len);
	va_end(ap);

	return len;
}
