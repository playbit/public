%.a:
	@[ -n "$^" ] || ( echo "$@: not found" >&2 ; exit 1 )
	$(QLOG) AR $@
	$(Q)mkdir -p "$(@D)"
	$(Q)rm -f "$@"
	$(Q)ar rcs "$@" $^

%.so:
	@[ -n "$^" ] || ( echo "$@: not found" >&2 ; exit 1 )
	$(QLOG) LD $@
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(LDFLAGS) $(EXTRA_LDFLAGS) -shared -o "$@" $^
# ifeq ($(NO_STRIP),)
# 	$(Q)debugsyms-strip $(if $(filter 1,$(V)),-v,) "$@"
# endif

$(DESTDIR)/bin/%:
	@[ -n "$^" ] || ( echo "$@: not found" >&2 ; exit 1 )
	$(QLOG) LD $@
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(if $(filter %.c,$^),-MP $(COMPILE_DEPFLAGS) $(CFLAGS),) $(LDFLAGS) $(EXTRA_LDFLAGS) -o "$@" $^
# ifeq ($(NO_STRIP),)
# 	$(Q)debugsyms-strip $(if $(filter 1,$(V)),-v,) "$@"
# endif

$(DESTDIR)/sbin/%:
	@[ -n "$^" ] || ( echo "$@: not found" >&2 ; exit 1 )
	$(QLOG) LD $@
	$(Q)mkdir -p "$(@D)"
	$(Q)$(CC) $(if $(filter %.c,$^),-MP $(COMPILE_DEPFLAGS) $(CFLAGS),) $(LDFLAGS) $(EXTRA_LDFLAGS) -o "$@" $^
# ifeq ($(NO_STRIP),)
# 	$(Q)debugsyms-strip $(if $(filter 1,$(V)),-v,) "$@"
# endif

$(DESTDIR)/lib/pkgconfig/%.pc: %.pc
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/usr/include/%.h: include/%.h
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/usr/include/%.h: %.h
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< $@

$(DESTDIR)/usr/share/man/man1/%.gz: %
	$(QLOG) INSTALL $@
	$(Q)mkdir -p "$(@D)"
	$(Q)gzip -kc -9 "$<" > "$@"
	$(Q)chmod 0644 "$@"

$(DESTDIR)/usr/share/man/man3/%.gz: %
	$(QLOG) INSTALL $@
	$(Q)mkdir -p "$(@D)"
	$(Q)gzip -kc -9 "$<" > "$@"
	$(Q)chmod 0644 "$@"

$(DESTDIR)/usr/share/man/man7/%.gz: %
	$(QLOG) INSTALL $@
	$(Q)mkdir -p "$(@D)"
	$(Q)gzip -kc -9 "$<" > "$@"
	$(Q)chmod 0644 "$@"


ifdef BUILDDIR

$(BUILDDIR)/%.c.o: %.c
	$(QLOG) CC $<
	$(Q)$(CC) -MP $(COMPILE_DEPFLAGS) $(CFLAGS) -c -o "$@" $<

$(BUILDDIR)/%.S.o: %.S
	$(QLOG) CC $<
	$(Q)$(CC) -MP $(COMPILE_DEPFLAGS) $(CFLAGS) -c -o "$@" $<

$(BUILDDIR)/%.cc.o: %.cc
	$(QLOG) CXX $<
	$(Q)$(CXX) -MP $(COMPILE_DEPFLAGS) $(CXXFLAGS) -c -o "$@" $<

$(BUILDDIR)/%.cpp.o: %.cpp
	$(QLOG) CXX $<
	$(Q)$(CXX) -MP $(COMPILE_DEPFLAGS) $(CXXFLAGS) -c -o "$@" $<

$(BUILDDIR)/%.prelink.o:
	$(QLOG) PRELINK $@
	$(Q)$(LD) -r -o $@ $(PRELINKFLAGS) $^

endif # ifdef $(BUILDDIR)


%.wgsl.h: %.wgsl
	$(QLOG) "WGSL $< -> $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)awk 'BEGIN { \
    print "static const char $(subst .,_,$(<F))[] = {" \
  } \
  { \
    gsub(/\\/, "\\\\"); \
    gsub(/"/, "\\\""); \
    gsub(/\n/, "\\n"); \
    print "\"" $$0 "\\n\""; \
  } \
  END { \
    print "};" \
  }' "$<" > "$@"


# if ALL_OBJS (or OBJS) is defined, add a dependency to create leading directories
# for all ALL_OBJS along with including their corresponding depfiles
ifndef ALL_OBJS
ifdef OBJS
ALL_OBJS := $(OBJS)
endif
endif
ifdef ALL_OBJS
ALL_OBJ_DIRS := $(sort $(patsubst %/,%,$(dir $(ALL_OBJS))))
$(ALL_OBJS): | $(ALL_OBJ_DIRS)
$(ALL_OBJ_DIRS):
	$(Q)mkdir -p "$@"
-include $(wildcard $(ALL_OBJS:.o=.d))
endif
