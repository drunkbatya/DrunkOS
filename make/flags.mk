ASMFLAGS = $(INCLUDE)
LDFLAGS = -Map $(BUILDDIR)/$(TARGET).map -T$(LDSCRIPT) -Os --gc-sections
