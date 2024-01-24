ENTRY(reset_handler)

MEMORY {
    FLASH (rx) : ORIGIN = 0x0000, LENGTH = 16K
    SRAM (xrw) : ORIGIN = 0x4000, LENGTH = 48K
}

_estack = ORIGIN(SRAM) + LENGTH(SRAM);

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
    _data_size = SIZEOF(.data);

    .bss : {
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } >SRAM
    _bss_size = SIZEOF(.bss);
}
