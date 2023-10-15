BUILDDIR = build

ASM_SOURCES += $(shell find * -type f -name "*.s")

OBJECTS += $(addprefix $(BUILDDIR)/, $(ASM_SOURCES:.s=.o))

OBJECT_DIRS = $(sort $(dir $(OBJECTS)))
$(foreach dir, $(OBJECT_DIRS),$(shell mkdir -p $(dir)))

include make/tools.mk
include make/flags.mk
include make/memmory.mk
include make/rules.mk

build: $(BUILDDIR)/firmware.bin

.PHONY: disasm
disasm: $(BUILDDIR)/firmware.bin
	z88dk-dis -o ${ROM_START} -x $(OUTFILE_BASE).map $(OUTFILE_BASE).rom

.PHONY: lint
lint:
	find . -type f \( -name "*.c" -o -name "*.h" \) \
		\( -path "./lib/*" -o -path "./kernel/*" \) \
        | xargs clang-format --Werror --style=file -i --dry-run

.PHONY: format
format:
	find . -type f \( -name "*.c" -o -name "*.h" \) \
		\( -path "./lib/*" -o -path "./kernel/*" \) \
        | xargs clang-format --Werror --style=file -i

.PHONY: flash
flash: $(BUILDDIR)/firmware.bin scripts/programmer.py
	@echo "\tFLASH\t" ${OUTFILE_BASE}.bin
	@$(PY) $(FLASHER) --file ${OUTFILE_BASE}.bin --address 0

.PHONY: clean
clean:
	-rm -rf ${BUILDDIR}

