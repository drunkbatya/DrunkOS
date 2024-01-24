.include "stdlib/stdlib.inc"

.section .text

; About:
;   Return 1 if array is filled by 0
; Args:
;   uint8_t* arr - array ptr
;   uint16_t size - array size
; Return:
;   uint8_t res - 1 if array is filled by 0
; C Prototype:
;   uint8_t is_mem_filled_zero(uint8_t* arr, uint16_t size);
is_mem_filled_zero:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 5 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 0)  ; arr ptr low byte
    ld h, (ix + 1)  ; arr ptr high byte
    ld c, (ix + 2)  ; arr size low byte
    ld b, (ix + 3)  ; arr size high byte

    is_mem_filled_zero_loop:
        ld a, b  ; loading one of the size bytes to a to check if bc==0
        or c  ; check if bc==0
        jr z, is_mem_filled_zero_true  ; if bc==0 assuming array is filled with zeroes
        ld a, (hl)  ; loading current byte
        dec bc  ; decrementing size
        or a  ; if current byte is 0?
        jr z, is_mem_filled_zero_loop  ; if current byte is zero continue looping
    is_mem_filled_zero_false:
    ld (ix + 2), 0  ; rewriting stack arg!, returning zero if found not zero byte
    jr is_mem_filled_zero_end

    is_mem_filled_zero_true:
    ld (ix + 2), 1  ; return true

    is_mem_filled_zero_end:
    ld (ix + 3), 0  ; dummy byte

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    push hl  ; return address
    exx  ; restoring registers

    ret
