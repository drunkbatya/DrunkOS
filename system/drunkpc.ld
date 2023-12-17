ENTRY(reset_handler)

MEMORY {
    FLASH (rx) : ORIGIN = 0x0000, LENGTH = 16K
    SRAM (xrw) : ORIGIN = 0x4000, LENGTH = 48K
}

_estack = ORIGIN(SRAM) + LENGTH(SRAM) - 1;

SECTIONS {
    .reset_handler : {
        KEEP(*(.reset_handler))
    } >FLASH

    .text : {
        *(.text)
        *(.text*)
        _etext = .;
    } >FLASH

    .rodata : {
        *(.rodata)
        *(.rodata*)
    } >FLASH

    _sidata = LOADADDR(.data);
    .data : {
        _sdata = .;
        *(.data)
        *(.data*)
        _edata = .;
    } >SRAM AT> FLASH

    .bss : {
        _sbss = .;
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss*)
        *(COMMON)
        _ebss = .;
        __bss_end__ = _ebss;
    } >SRAM
}
