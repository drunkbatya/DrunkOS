.include "terminal/terminal.inc"
.include "display/display.inc"

.section .text

; About:
;   Draw a null-terminated string to x, y
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
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 0)  ; loading string pointer
    ld h, (ix + 1)  ; loading string pointer
    ld de, (terminal_current_coordinates)  ; loading current display coordinates (y, x)
    terminal_putstr_loop:
        ld a, (hl)  ; loading byte to draw
        or a  ; check if zero (null-terminator)
        jr z, terminal_putstr_loop_end
        cp 0x0a  ; if new line char, i don't know how to set '\n' char here
        jr z, terminal_putstr_loop_newline_char

        ; check if display line end
        ld c, a  ; char to draw
        ld b, 0  ; dummy byte
        push bc  ; first argument of display_get_char_width function (char to draw)
        call display_get_char_width
        pop bc  ; display_get_char_width return value, char width
        ld a, e  ; loading x to a (due to add instruction limmitations)
        add a, c  ; add char width to x
        cp TERMINAL_DISPLAY_WIDTH + 1 ; if we reached end of display line
        jr nc, terminal_putstr_loop_newline  ; if x >= TERMINAL_DISPLAY_WIDTH

        ld a, (hl)  ; loading byte to draw
        ld c, a  ; char to draw
        ld b, 0  ; dummy byte
        push de  ; second argument of display_draw_char function (x and y)
        push bc  ; first argument of display_draw_char function (char to draw)

        call display_draw_char

        pop bc  ; display_draw_char return value, char width
        ld a, e  ; loading x to a (due to add instruction limmitations)
        add a, c  ; add char width to x
        ld e, a  ; loading x to e (due to add instruction limmitations)
        inc e  ; add 1-byte space between chars
        inc hl  ; inc string pointer
        jr terminal_putstr_loop
        terminal_putstr_loop_newline_char:  ; if current char is '\n'
            inc hl  ; inc string pointer
        terminal_putstr_loop_newline:  ; if we reached end of display line
            ld a, d  ; loading y to a (due to add instruction limmitations)
            add a, TERMINAL_LINE_HEIGHT  ; max char height
            ld d, a  ; loading new y to d back (due to add instruction limmitations)
            ld e, 0  ; loading init x value
            jr terminal_putstr_loop
    terminal_putstr_loop_end:
    ld (terminal_current_coordinates), de  ; writing current display coordinates (y, x)

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with they shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

