.include "main.inc"
.global reset_handler
.section .reset_handler,"a",%progbits

reset_handler:
    ld sp, _estack
    jp main
