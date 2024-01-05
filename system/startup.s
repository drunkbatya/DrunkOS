.include "main.inc"
.global reset_handler
.section .reset_handler,"a",%progbits

reset_handler:
    ld sp, _estack

    init_data_section:
        nop
    init_bss_section:
        nop

    jp main
