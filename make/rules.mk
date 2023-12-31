$(ASSETSBUILDDIR)/$(ASSETSTARGET): $(ASSETS_SOURCES) $(ASSETS_COMPILER) $(MAKE_FILES)
	@echo "\tASSETS\t" $@
	@$(ASSETS_COMPILER) $(ASSETSSRCDIR) $(ASSETSBUILDDIR)

$(BUILDDIR)/%.o: %.s $(ASSETSBUILDDIR)/$(ASSETSTARGET) $(MAKE_FILES) | $(BUILDDIR)
	@echo "\tASM\t" $<
	@$(AS) $(ASMFLAGS) $< -o $@

$(BUILDDIR)/$(TARGET).elf: $(OBJECTS) $(MAKE_FILES)
	@echo "\tLD\t" $@
	@$(LD) $(LDFLAGS) $(OBJECTS) -o $@
	@echo "\tSIZE\t" $@
	@z80-elf-size -A -t $@ | grep -e " "

$(BUILDDIR)/%.bin: $(BUILDDIR)/%.elf | $(BUILDDIR)
	@echo "\tBIN\t" $@
	@$(BIN) $< $@

