build: $(BUILDDIR)/firmware.bin

.PHONY: disasm
disasm: $(BUILDDIR)/firmware.bin
	@echo "\tDISASM\t" $(BUILDDIR)/firmware.bin
	@z88dk-dis -mz80 -o $(ROM_START) -x $(BUILDDIR)/firmware.map $(BUILDDIR)/firmware.bin

.PHONY: xxd
xxd: $(BUILDDIR)/firmware.bin
	@echo "\tXXD\t" $(BUILDDIR)/firmware.bin
	@xxd $(BUILDDIR)/firmware.bin

.PHONY: flash
flash: $(BUILDDIR)/firmware.bin
	@echo "\tFLASH\t" $(BUILDDIR)/firmware.bin
	@$(PY) $(FLASHER) --file ${OUTFILE_BASE}.bin --address 0

.PHONY: clean
clean:
	-rm -rf ${BUILDDIR}
