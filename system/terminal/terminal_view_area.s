.include "terminal/terminal.inc"

.section .text

terminal_view_area_scroll_down:
    push hl  ; storing hl

    ld hl, (terminal_view_area_address)
    ld de, TERMINAL_WIDTH
    add hl, de
    res 7, h  ; ra6963 internal address bus width is 15-bit, limitting our variable
    ld (terminal_view_area_address), hl
    push hl  ; pushing 1st arg of the ra6963_set_text_home_address function
    call ra6963_set_text_home_address  ; set new text home address

    pop hl  ; restoring hl
    ret

.section .bss

terminal_view_area_address:
    .skip 2
