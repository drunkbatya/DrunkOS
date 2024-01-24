.include "stdlib/stdlib.inc"

.section .text

; About:
;   The memcpy() function copies n bytes from memory area src to memory area dst.
;   Both arrays are assumed to be n bytes long.
; Args:
;   uint8_t* dst - first array ptr
;   uint8_t* src - second array ptr
;   uint16_t n - arrays size
; Return:
;   None
; C Prototype:
;   void memcpy(uint8_t* dst, uint8_t* src, uint16_t size);
memcpy:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 5 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ld e, (ix + 0)  ; arr1 ptr low byte
    ld d, (ix + 1)  ; arr1 ptr high byte
    ld l, (ix + 2)  ; arr2 ptr low byte
    ld h, (ix + 3)  ; arr3 ptr high byte
    ld c, (ix + 4)  ; arrs size low byte
    ld b, (ix + 5)  ; arrs size high byte

    ld a, b  ; loading one of the size bytes to a to check if bc==0
    or c  ; check if bc==0
    jr z, memcpy_end  ; exiting now if bc==0

    ldir  ; repeats 'ld (de), (hl)' then increments de, hl, and decrements bc until bc=0

    memcpy_end:

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    pop bc  ; removing arg2
    pop bc  ; removing arg3
    push hl  ; return address
    exx  ; restoring registers

    ret

