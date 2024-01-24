.include "display/display.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

; About:
;   Moves the display view area to (current + n) bytes
; Args:
;   uint16_t bytes - how many bytes will be added to the display graphic home address
; Return:
;   None
; C Prototype:
;   void display_move_view_area_down(uint16_t bytes);
display_move_view_area_down:
    ; swapping return address and arg 1 in stack
    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg 1
    push hl  ; first pushing return address
    push bc  ; arg 1
    exx  ; restoring registers

    call ra6963_add_to_zero_offset  ; adding bytes to the display graphic home address
    call ra6963_apply_zero_offset  ; applying offset

    ret
