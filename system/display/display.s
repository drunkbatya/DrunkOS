.include "display/display.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

display_init:
    call ra6963_init
    call ra6963_clear

    ld hl, 0
    push hl
    call ra6963_set_graphic_home_address

    ret

.section .data

display_font:
    .word font_haxrcorp_arr  ; setting default font
display_font_offset:
    .byte 32
