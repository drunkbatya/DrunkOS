$(ASSETSBUILDDIR)/$(ASSETSTARGET):
	@echo "\tASSETS\t" $@
	@$(ASSETS) $(ASSETSSRCDIR) $(ASSETSBUILDDIR)

$(BUILDDIR)/%.o: %.s $(ASSETSBUILDDIR)/$(ASSETSTARGET) $(MAKE_FILES) | $(BUILDDIR)
	@echo "\tASM\t" $<
	@$(AS) $(ASMFLAGS) $< -o $@

$(BUILDDIR)/$(TARGET).elf: $(OBJECTS) $(MAKE_FILES)
	@echo "\tLD\t" $@
	@$(LD) $(LDFLAGS) $(OBJECTS) -o $@
	@z80-elf-size -A -t build/firmware.elf | grep -e " "

$(BUILDDIR)/%.bin: $(BUILDDIR)/%.elf | $(BUILDDIR)
	@echo "\tBIN\t" $@
	@$(BIN) $< $@

