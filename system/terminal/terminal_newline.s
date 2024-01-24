.include "terminal/terminal.inc"
.include "display/display.inc"

.section .text

terminal_process_newline:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de

    ld ix, 10  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld hl, TERMINAL_LINE_HEIGHT_BYTES  ; moving display graphic home address to (current + TERMINAL_LINE_HEIGHT_BYTES)
    push hl  ; 1st arg of the display_move_view_area_down function
    call display_move_view_area_down  ; adding TERMINAL_LINE_HEIGHT_BYTES to the display graphic home address

    ld a, (ix + 1)  ; loading y to a
    sub TERMINAL_LINE_HEIGHT  ; subtracting one line
    ld (ix + 1), a  ; rewriting stack arg!, 'y' = 'y' - TERMINAL_LINE_HEIGHT

    ;call display_clear_lines?
    ld hl, 0  ; cleared screen value
    push hl  ; third arg of the ra6963_memset
    ld hl, TERMINAL_LINE_HEIGHT_BYTES  ; framebuffer size
    push hl  ; second  arg of the ra6963_memset
    ld hl, (ra6963_zero_offset)
    ld de, 1620  ;(64 - TERMINAL_LINE_HEIGHT * 30)
    add hl, de  ; current 0 + 53 display linex
    push hl
    call ra6963_memset

    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    ; clear line
    ret

