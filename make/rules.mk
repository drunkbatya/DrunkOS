#$(ASSETS_BUILD_DIR)/assets_icons.c: $(ASSETS_SOURCES) $(ASSETS_COMPILLER)
#	@echo "\tASSETS\t" $@
#	@mkdir -p $(ASSETS_BUILD_DIR)
#	@$(ASSETS_COMPILLER) $(ASSETS_SOURCE_DIR) $(ASSETS_BUILD_DIR)

$(BUILDDIR)/%.o: %.s
	@echo "\tASM\t" $<
	@$(ASM) $(ASMFLAGS) $< -O=$(BUILDDIR)

$(BUILDDIR)/firmware.bin: $(OBJECTS) Makefile
	@echo "\tLD\t" $@
	@$(LD) $(LDFLAGS) $(OBJECTS) -o=$@

