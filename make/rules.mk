$(BUILDDIR)/%.o: %.s $(MAKE_FILES) | $(BUILDDIR)
	@echo "\tASM\t" $<
	@$(AS) $(ASMFLAGS) $< -o $@

$(BUILDDIR)/$(TARGET).elf: $(OBJECTS) $(MAKE_FILES)
	@echo "\tLD\t" $@
	@$(LD) $(LDFLAGS) $(OBJECTS) -o $@

$(BUILDDIR)/%.bin: $(BUILDDIR)/%.elf | $(BUILDDIR)
	@echo "\tBIN\t" $@
	@$(BIN) $< $@

