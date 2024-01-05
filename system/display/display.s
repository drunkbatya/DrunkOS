.include "display/display.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

display_init:
    call ra6963_init
    call ra6963_clear
    ret

.section .data

display_font:
    .word font_haxrcorp_arr  ; setting default font
display_font_offset:
    .byte 32
