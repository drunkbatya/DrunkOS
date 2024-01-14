.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

; TODO: explain this concept


; About:
;   Sets display graphic home address to the ra6963_zero_offset var value
; Args:
;   None
; Return:
;   None
; C Prototype:
;   void ra6963_apply_zero_offset(void);
ra6963_apply_zero_offset:
    push hl  ; store hl
    ld hl, (ra6963_zero_offset)  ; loading current display zero offset
    push hl  ; pushing 1st arg of the ra6963_set_graphic_home_address function
    call ra6963_set_graphic_home_address  ; set new graphic home address
    pop hl  ; restore hl
    ret

; About:
;   Add value to the display zero offset
; Args:
;   uint16_t value - value to add
; Return:
;   None
; C Prototype:
;   void ra6963_add_to_zero_offset(uint16_t value);
ra6963_add_to_zero_offset:
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de

    ld ix, 8  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld e, (ix + 0)  ; loading high byte of bitmap data ptr
    ld d, (ix + 1)  ; loading low byte of bitmap data ptr

    ld hl, (ra6963_zero_offset)  ; loading current display zero offset
    add hl, de  ; adding desired value
    res 7, h  ; ra6963 internal address bus width is 15-bit, limitting our variable
    ld (ra6963_zero_offset), hl  ; storing modified offset back

    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    push hl  ; return address
    exx  ; restoring registers
    ret


.section .data

ra6963_zero_offset:
    .word 0
