.include "main.inc"
.include "hardware/io.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

main:
    call ra6963_init
    call ra6963_clear

    ld hl, 0x3F00  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x3E01  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x3D02  ; y, x
    push hl
    call ra6963_set_pixel

    halt
