.include "terminal/terminal.inc"

.section .text

; About:
;   Puts a null-terminated string to the terminal
; Args:
;   unsigned char* str - char to draw
; Return:
;   None
; C prototype:
;   void terminal_putstr(unsigned char* str);
terminal_putstr:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push bc  ; storing bc

    ld ix, 10  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 0)  ; loading string pointer
    ld h, (ix + 1)  ; loading string pointer
    ld b, 0  ; dummy byte to call terminal_putchar function and pass a char throught bc reg pair
    terminal_putstr_loop:
        ld a, (hl)  ; loading byte to draw
        or a  ; check if zero (null-terminator)
        jr z, terminal_putstr_loop_end

        ld c, a  ; char to draw
        push bc  ; first argument of terminal_putchar function (char to draw)

        call terminal_putchar

        inc hl
        jr terminal_putstr_loop
    terminal_putstr_loop_end:
    pop bc  ; restoring bc
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with they shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

