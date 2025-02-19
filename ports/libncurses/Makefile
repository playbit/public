#!BUILDTOOL src/cc if HERMETIC
#!BUILDTOOL ports/libc if HERMETIC
#!BUILDTOOL ports/busybox
#!BUILDTOOL ports/make
#
#!DEP ports/libc
#
include ../../tools/playbit.defs.mk
VERSION := 6.5-20240427

PRODUCTS := \
	lib/libcurses.a \
	lib/libcursesw.a \
	lib/libncurses.a \
	lib/libncursesw.a \
	lib/pkgconfig/ncursesw.pc \
	lib/pkgconfig/ncurses.pc \
	usr/include/curses.h \
	usr/include/ncurses.h \
	usr/include/ncurses_dll.h \
	usr/include/term.h \
	usr/include/term_entry.h \
	usr/include/termcap.h \
	usr/include/unctrl.h \

# Note: terminfo database lives in rootfs/etc/terminfo

SRCS := \
	base/define_key.c \
	base/key_defined.c \
	base/keybound.c \
	base/keyok.c \
	base/legacy_coding.c \
	base/lib_addch.c \
	base/lib_addstr.c \
	base/lib_beep.c \
	base/lib_bkgd.c \
	base/lib_box.c \
	base/lib_chgat.c \
	base/lib_clear.c \
	base/lib_clearok.c \
	base/lib_clrbot.c \
	base/lib_clreol.c \
	base/lib_color.c \
	base/lib_colorset.c \
	base/lib_delch.c \
	base/lib_delwin.c \
	base/lib_dft_fgbg.c \
	base/lib_echo.c \
	base/lib_endwin.c \
	base/lib_erase.c \
	base/lib_flash.c \
	base/lib_freeall.c \
	base/lib_getch.c \
	base/lib_getstr.c \
	base/lib_hline.c \
	base/lib_immedok.c \
	base/lib_inchstr.c \
	base/lib_initscr.c \
	base/lib_insch.c \
	base/lib_insdel.c \
	base/lib_insnstr.c \
	base/lib_instr.c \
	base/lib_isendwin.c \
	base/lib_leaveok.c \
	base/lib_mouse.c \
	base/lib_move.c \
	base/lib_mvwin.c \
	base/lib_newterm.c \
	base/lib_newwin.c \
	base/lib_nl.c \
	base/lib_overlay.c \
	base/lib_pad.c \
	base/lib_printw.c \
	base/lib_redrawln.c \
	base/lib_refresh.c \
	base/lib_restart.c \
	base/lib_scanw.c \
	base/lib_screen.c \
	base/lib_scroll.c \
	base/lib_scrollok.c \
	base/lib_scrreg.c \
	base/lib_set_term.c \
	base/lib_slk.c \
	base/lib_slkatr_set.c \
	base/lib_slkatrof.c \
	base/lib_slkatron.c \
	base/lib_slkatrset.c \
	base/lib_slkattr.c \
	base/lib_slkclear.c \
	base/lib_slkcolor.c \
	base/lib_slkinit.c \
	base/lib_slklab.c \
	base/lib_slkrefr.c \
	base/lib_slkset.c \
	base/lib_slktouch.c \
	base/lib_touch.c \
	base/lib_ungetch.c \
	base/lib_vline.c \
	base/lib_wattroff.c \
	base/lib_wattron.c \
	base/lib_winch.c \
	base/lib_window.c \
	base/nc_panel.c \
	base/new_pair.c \
	base/resizeterm.c \
	base/safe_sprintf.c \
	base/tries.c \
	base/use_window.c \
	base/version.c \
	base/vsscanf.c \
	base/wresize.c \
	codes.c \
	comp_captab.c \
	comp_userdefs.c \
	expanded.c \
	fallback.c \
	lib_gen.c \
	lib_keyname.c \
	names.c \
	tinfo/access.c \
	tinfo/add_tries.c \
	tinfo/alloc_ttype.c \
	tinfo/comp_error.c \
	tinfo/comp_hash.c \
	tinfo/db_iterator.c \
	tinfo/doalloc.c \
	tinfo/entries.c \
	tinfo/free_ttype.c \
	tinfo/getenv_num.c \
	tinfo/hashed_db.c \
	tinfo/home_terminfo.c \
	tinfo/init_keytry.c \
	tinfo/lib_acs.c \
	tinfo/lib_baudrate.c \
	tinfo/lib_cur_term.c \
	tinfo/lib_data.c \
	tinfo/lib_has_cap.c \
	tinfo/lib_kernel.c \
	tinfo/lib_longname.c \
	tinfo/lib_napms.c \
	tinfo/lib_options.c \
	tinfo/lib_print.c \
	tinfo/lib_raw.c \
	tinfo/lib_setup.c \
	tinfo/lib_termcap.c \
	tinfo/lib_termname.c \
	tinfo/lib_tgoto.c \
	tinfo/lib_ti.c \
	tinfo/lib_tparm.c \
	tinfo/lib_tputs.c \
	tinfo/lib_ttyflags.c \
	tinfo/name_match.c \
	tinfo/obsolete.c \
	tinfo/read_entry.c \
	tinfo/read_termcap.c \
	tinfo/strings.c \
	tinfo/trim_sgr0.c \
	tinfo/use_screen.c \
	trace/lib_trace.c \
	trace/varargs.c \
	trace/visbuf.c \
	tty/hardscroll.c \
	tty/hashmap.c \
	tty/lib_mvcur.c \
	tty/lib_tstp.c \
	tty/lib_twait.c \
	tty/lib_vidattr.c \
	tty/tty_update.c \
	unctrl.c \
	widechar/charable.c \
	widechar/lib_add_wch.c \
	widechar/lib_box_set.c \
	widechar/lib_cchar.c \
	widechar/lib_erasewchar.c \
	widechar/lib_get_wch.c \
	widechar/lib_get_wstr.c \
	widechar/lib_hline_set.c \
	widechar/lib_in_wch.c \
	widechar/lib_in_wchnstr.c \
	widechar/lib_ins_wch.c \
	widechar/lib_inwstr.c \
	widechar/lib_key_name.c \
	widechar/lib_pecho_wchar.c \
	widechar/lib_slk_wset.c \
	widechar/lib_unget_wch.c \
	widechar/lib_vid_attr.c \
	widechar/lib_vline_set.c \
	widechar/lib_wacs.c \
	widechar/lib_wunctrl.c

CFLAGS += \
	-I. -Iinclude \
	-Qunused-arguments \
	-Wno-error=implicit-function-declaration \
	-DNDEBUG \
	-DBUILDING_NCURSES \
	-DNCURSES_STATIC

OBJS := $(addprefix $(BUILDDIR)/,$(patsubst %,%.o,$(SRCS)))
PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	$(Q)rm -rf $(PRODUCTS)
clean:
	$(Q)rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/lib/libncursesw.a: $(OBJS)

$(DESTDIR)/lib/libcurses.a: | $(DESTDIR)/lib/libncursesw.a
	$(QLOG) "SYMLINK $@ -> libncursesw.a"
	$(Q)ln -sf libncursesw.a $@

$(DESTDIR)/lib/libcursesw.a: | $(DESTDIR)/lib/libncursesw.a
	$(QLOG) "SYMLINK $@ -> libncursesw.a"
	$(Q)ln -sf libncursesw.a $@

$(DESTDIR)/lib/libncurses.a: | $(DESTDIR)/lib/libncursesw.a
	$(QLOG) "SYMLINK $@ -> libncursesw.a"
	$(Q)ln -sf libncursesw.a $@

$(DESTDIR)/lib/pkgconfig/ncurses.pc:
	$(QLOG) "SYMLINK $@ -> ncursesw.pc"
	$(Q)mkdir -p $(@D)
	$(Q)ln -sf ncursesw.pc $@

$(DESTDIR)/usr/include/ncurses.h:
	$(QLOG) "SYMLINK $@ -> curses.h"
	$(Q)ln -sf curses.h $@

include ../../tools/playbit.rules.mk
.PHONY: all clean install uninstall
