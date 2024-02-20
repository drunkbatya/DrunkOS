.include "terminal/terminal.inc"
.include "display/display.inc"

.section .text

; About:
;   Private function: processing new line
terminal_newline:
    push af  ; storing a

    ld a, d  ; loading y to a (due to add instruction limmitations)
    add a, TERMINAL_LINE_HEIGHT  ; max char height
    ld e, 0  ; loading init x value
    ld d, a  ; loading new y to d back (due to add instruction limmitations)

    ld a, d  ; loading y to a
    cp TERMINAL_DISPLAY_HEIGHT - TERMINAL_LINE_HEIGHT  ; comparing 'y' + one line with the visible area
    jr z, terminal_newline_end  ; if y + one line == max visible area line, skipping
    jr c, terminal_newline_end  ; if y + one line < visible area, skipping

    ; moving visible area one line down
    push de  ; pushing current coordinates
    call terminal_process_newline
    pop de  ; returning new ccordinates

    terminal_newline_end:
    pop af  ; restoring a
    ret

; About:
;   Puts a char to the terminal
; Args:
;   unsigned char c - char to draw
; Return:
;   None
; C prototype:
;   void terminal_putchar(unsigned char c);
terminal_putchar:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld de, (terminal_current_coordinates)  ; loading current display coordinates (y, x)

    ld a, (ix + 0)  ; loading char to draw
    cp 0x0a  ; if new line char, i don't know how to set '\n' char here
    call z, terminal_newline  ; if char == '\n'
    jr z, terminal_putchar_end  ; if char == '\n'

    ; check if display line end
    ld c, a  ; char to draw
    ld b, 0  ; dummy byte
    push bc  ; first argument of display_get_char_width function (char to draw)

    call display_get_char_width

    pop bc  ; display_get_char_width return value, char width
    ld a, e  ; loading x to a (due to add instruction limmitations)
    add a, c  ; add char width to x
    cp TERMINAL_DISPLAY_WIDTH + 1 ; if we reached end of display line
    call nc, terminal_newline  ; if potential x >= TERMINAL_DISPLAY_WIDTH

    ld a, (ix + 0)  ; loading char to draw
    ld c, a  ; char to draw
    ld b, 0  ; dummy byte
    push de  ; second argument of display_draw_char function (x and y)
    push bc  ; first argument of display_draw_char function (char to draw)

    call display_draw_char

    pop bc  ; display_draw_char return value, char width, ignoring due to previous call of the display_get_char_width
    ld a, e  ; loading x to a (due to add instruction limmitations)
    add a, c  ; add char width to x
    ld e, a  ; loading x to e (due to add instruction limmitations)
    inc e  ; add 1-byte space between chars
    terminal_putchar_end:
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

