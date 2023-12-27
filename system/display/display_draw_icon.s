
; draws icon to specified coordinates (x, y)
; Args:
;   uint16_t* icon, uint8_t x, uint8_t y
display_draw_icon:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 0  ; there is no way to set load sp value to ix
    add ix, sp  ; loading sp value to ix


    pop ix  ; restoring ix
    pop af  ; restoring af
    ret
