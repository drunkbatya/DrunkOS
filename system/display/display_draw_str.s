.include "display/display.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

; About:
;   Draw char to x, y
; Args:
;   unsigned char c - char to draw
;   uint8_t x - x coordinate
;   uint8_t y - y coordinate
; Return:
;   uint8_t width - char width
; C prototype:
;   uint8_t display_draw_char(unsigned char c, uint8_t x, uint8_t y);
display_draw_char:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de

    ld ix, 10  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 2)  ; loading x
    ld h, (ix + 3)  ; loading y
    push hl  ; second argument of display_draw_icon function (x and y)

    ld a, (ix + 0)  ; loading char to draw
    sub 32  ; font offset
    sla a  ; pointer is 2 byte, multiplying (char code - font offset) to 2 by logical left shift
    ld e, a  ; there is no way to add 8 bit reg to 16 bit reg pair
    ld d, 0
    ld hl, font_haxrcorp_arr  ; font array address
    add hl, de  ; adding char to font array address
    ld e, (hl)  ; unwrapping pointer to pointer
    inc hl
    ld d, (hl)  ; unwrapping pointer to pointer
    push de  ; first argument of display_draw_icon function (pointer to icon structure)

    ld a, (de)  ; first variable into icon structure is char width, accessing it to return
    ld (ix + 2), a  ; rewriting stack arg!, returning char width
    ld (ix + 3), 0  ; rewriting stack arg!, dummy byte

    call display_draw_icon

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


; About:
;   Draw a null-terminated string to x, y
; Args:
;   unsigned char* str - char to draw
;   uint8_t x - x coordinate
;   uint8_t y - y coordinate
; Return:
;   None
; C prototype:
;   void display_draw_char(unsigned char* str, uint8_t x, uint8_t y);
display_draw_str:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 0)  ; loading string pointer
    ld h, (ix + 1)  ; loading string pointer
    ld e, (ix + 2)  ; loading x
    ld d, (ix + 3)  ; loading y
    display_draw_str_loop:
        ld a, (hl)  ; loading byte to draw
        or a  ; check if zero (null-terminator)
        jp z, display_draw_str_loop_end
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
        jr display_draw_str_loop
    display_draw_str_loop_end:

    pop bc  ; restoring bc
    pop de  ; restoring de
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
