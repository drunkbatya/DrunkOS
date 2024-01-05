.include "main.inc"
.global reset_handler
.section .reset_handler,"a",%progbits

reset_handler:
    ld sp, _estack

    init_data_section:
        ; _sdata, _edata and _sidata are defined by linker
        ld hl, _edata  ; end address (in RAM) of data section
        ld de, _sdata  ; start address (in RAM) of data section
        or a  ; clear carry flag
        sbc hl, de  ; subtracting start address from end
        jr z, init_data_section_end  ; skipping init data section if it absent

        ld c, l  ; there is no way to 'ld bc, hl'...
        ld b, h  ; end address - start address in BC
        ld hl, _sidata  ; start address (in FLASH) of data section
        ldir  ; repeats 'ld (de), (hl)' then increments de, hl, and decrements bc until bc=0
    init_data_section_end:

    init_bss_section:
        nop

    jp main
