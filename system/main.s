.include "main.inc"
.include "hardware/io.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

main:
    call ra6963_init
    call ra6963_clear
    halt
