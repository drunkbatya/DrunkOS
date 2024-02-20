.include "stdlib/stdlib.inc"

.section .text

; About:
;   The strcmp() function compares string str1 against string str2.
;   Both strings are assumed to be the same lenght.
; Args:
;   const char* str1 - first str ptr
;   const char* str2 - second str ptr
; Return:
;   uint8_t res - 0 if both arrays are equal
; C Prototype:
;   uint8_t strcmp(const char* str1, const char* str2);
strcmp:
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

    strcmp_loop:
        ld a, (de)  ; loading str1 char
        or a  ; check it a null-terminator?
        jr z, strcmp_end_equal  ; if we'r reached end of string, assuming both :rrays are equal
        ld a, (de)  ; loading arr1 byte
        cpi  ; Multiple instructions combined into one: cp (hl), inc hl, dec bc
        jr nz, strcmp_end_not_equal  ; if bytes are not equal
        inc de  ; incrementing arr1 ptr. arr2 ptr already incremented by cpi
        jr strcmp_loop  ; loop
    strcmp_end_equal:
    ld (ix + 4), 0  ; rewriting stack arg!, returning 0 if both arrays are equal
    jr strcmp_end
    strcmp_end_not_equal:
    dec hl  ; arr2 ptr already incremented by cpi, decrementing it back to compare with arr1 ptr
    sub (hl)  ; a already contains the (de) value, subtracting arr2 byte from the arr1 byte to returm the differance
    ld (ix + 4), a  ; rewriting stack arg!, returning the difference between the first two differing bytes

    strcmp_end:
    ld (ix + 5), 0  ; rewriting stack arg!, dummy byte

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    pop bc  ; removing arg2
    push hl  ; return address
    exx  ; restoring registers


    ret

