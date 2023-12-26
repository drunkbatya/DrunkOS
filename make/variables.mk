BUILDDIR = build
TARGET = firmware
ASSETSDIR = assets
ASSETSSRCDIR = $(ASSETSDIR)/src
ASSETSBUILDDIR = $(ASSETSDIR)/build
ASSETSTARGET = assets_icons.s

INCLUDE = -Isystem/drivers/st7920 -Isystem

ASM_SOURCES = $(ASSETSBUILDDIR)/$(ASSETSTARGET)
ASM_SOURCES += $(shell find system -type f -name "*.s")

OBJECTS = $(addprefix $(BUILDDIR)/, $(ASM_SOURCES:.s=.o))

OBJECT_DIRS = $(sort $(dir $(OBJECTS)))
$(foreach dir, $(OBJECT_DIRS),$(shell mkdir -p $(dir)))

MAKE_FILES = $(shell find make -type f -name "*.mk")

LDSCRIPT = system/drunkpc.ld
