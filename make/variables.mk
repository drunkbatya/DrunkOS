BUILDDIR = build

ASM_SOURCES = system/startup.s
ASM_SOURCES += $(shell find * -type f -name "*.s" | grep -v startup.s)

OBJECTS += $(addprefix $(BUILDDIR)/, $(ASM_SOURCES:.s=.o))

OBJECT_DIRS = $(sort $(dir $(OBJECTS)))
$(foreach dir, $(OBJECT_DIRS),$(shell mkdir -p $(dir)))

