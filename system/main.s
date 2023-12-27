.include "main.inc"
.include "hardware/io.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

main:
    call ra6963_init
    call ra6963_clear
    ld hl, 0x0000  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x0101  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x0202  ; y, x
    push hl
    call ra6963_set_pixel

    ld hl, 0x00EF  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x01EE  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x02ED  ; y, x
    push hl
    call ra6963_set_pixel

    ld hl, 0x3FEF  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x3EEE  ; y, x
    push hl
    call ra6963_set_pixel
    ld hl, 0x3DED  ; y, x
    push hl
    call ra6963_set_pixel

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
