.include "main.inc"
.include "display/display.inc"

.section .text

main:
    call display_init

    ld hl, 0x0105  ; y, x
    push hl
    ld hl, test_str
    push hl
    call display_draw_str

    ld hl, 0x3F00  ; y, x
    push hl
    call ra6963_set_pixel

    halt

.section .rodata

test_str:
    .asciz "Fuck You!# I'm testing this shit, and it semms to be ok!"
