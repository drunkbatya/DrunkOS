.include "stdlib/stdlib.inc"

.section .text

; About:
;   Copy the string src to dst (including the terminating ‘\0’ character.)
;   The source and destination strings should not overlap, as the behavior is undefined.
; Args:
;   unsigned char* dst - destination string ptr
;   unsigned char* src - source string ptr
; Return:
;   None
; C Prototype:
;   void strcpy(unsigned char* dst, unsigned char* src);
strcpy:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de

    ld ix, 10  ; there is no way to set load sp value to ix, skipping pushed 5 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ld e, (ix + 0)  ; dst ptr low byte
    ld d, (ix + 1)  ; dst ptr high byte
    ld l, (ix + 2)  ; src ptr low byte
    ld h, (ix + 3)  ; src ptr high byte

    strcpy_loop:
        ld a, (hl)  ; loading src string byte
        ld (de), a  ; writing to the dst string
        inc hl  ; incrementing str ptr
        inc de  ; incrementing dst ptr
        or a  ; check if current byte is a null-terminator
        jr nz, strcpy_loop  ; looping if no

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
