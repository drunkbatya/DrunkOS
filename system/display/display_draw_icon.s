.include "display/display.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

; About:
;   Draw icon to x, y
; Args:
;   const Icon* icon - pointer to icon structure (see below)
;   uint8_t x - x coordinate
;   uint8_t y - y coordinate
; Return:
;   None
; C prototype:
;   void ra6963_draw_icon(const Icon* icon, uint8_t x, uint8_t y);
; Icon struct:
;   my_icon: (offset 0)
;       my_icon_width: .byte 1 (offset 0)
;       my_icon_height: .byte 10 (offset 1)
;       my_icon_data: .byte 0xAA, 0x8C, ... (offset 2)

display_draw_icon:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl

    ld ix, 8  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld e, (ix + 2)  ; loading desired x
    ld d, (ix + 3)  ; loading desired y
    push de  ; arg 4 and 5 of ra6963_draw_xbm

    ld l, (ix + 0)  ; loading icon ptr low byte
    ld h, (ix + 1)  ; loading icon ptr high byte
    ld e, (hl)  ; icon width
    inc hl  ; icon ptr will point to height
    ld d, (hl)  ; icon height
    inc hl  ; icon ptr will point to data
    push de  ;  arg 2 and 3 of ra6963_draw_xbm
    push hl  ; arg 0 and 1 of ra6963_draw_xbm

    call ra6963_draw_xbm

    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with they shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    pop bc  ; removing arg2
    push hl  ; return address
    exx  ; restoring registers
    ret
