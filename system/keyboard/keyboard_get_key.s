.include "hardware/io.inc"
.include "keyboard/keyboard.inc"

KEYBOARD_SHIFT_ROW = 0x20  ; row 5
KEYBOARD_SHIFT_BIT = 1  ; bit 1
KEYBOARD_ROW_COUNT = 8
KEYBOARD_COL_COUNT = 8

; About:
;   Scans keyboard and returns the pressed key
; Args:
;   None
; Return:
;   unsigned char c - pressed char code
; C Prototype:
; unsigned char keyboard_get_key(void);
keyboard_get_key:
    keyboard_get_key_check_shift:
    ld a, KEYBOARD_SHIFT_ROW  ; setting row 5
    out (IO_KBD_ADDR), a  ; setting row
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    in a, (IO_KBD_ADDR)  ; reading column
    bit KEYBOARD_SHIFT_BIT, a  ; if shift pressed?
    jr nz, keyboard_get_key_shift_pressed

    ld hl, keyboard_matrix_map  ; loading keyboard_matrix_map ptr
    jr keyboard_get_key_row_start

    keyboard_get_key_shift_pressed:
    ld hl, keyboard_matrix_map_shift

    keyboard_get_key_row_start:
    ld a, 0  ; resetting row
    out (IO_KBD_ADDR), a  ; resetting row
    ld b, KEYBOARD_ROW_COUNT  ; keyboard row
    ld c, 1  ; hardware row bitmask
    keyboard_get_key_row_loop:
        ld a, c  ; hardware row bitmask
        out (IO_KBD_ADDR), a  ; setting row
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        in a, (IO_KBD_ADDR)  ; reading column
        ld e, a  ; storing readed column
        push bc  ; storing keyboard_get_key_row_loop data
        ld b, KEYBOARD_COL_COUNT  ; keyboard column loop
        ld c, 1  ; hardware column bitmask
        keyboard_get_key_column_loop:
            ld a, e  ; readed column
            and c  ; if current hardware column bitmask matches pressed key
            jr z, keyboard_get_key_column_loop_skip_col
            ld a, (hl)  ; trying to access found char
            or a  ; if it not zero
            jr nz, keyboard_get_key_key_found
            keyboard_get_key_column_loop_skip_col:
            sla c  ; shifting left, going to the next hardware column
            inc hl  ; increasing the keyboard_matrix_map ptr
            djnz keyboard_get_key_column_loop
        pop bc  ; restoring keyboard_get_key_row_loop data
        sla c  ; going to the next hardware row
        djnz keyboard_get_key_row_loop
    jr keyboard_get_key_key_found_nothing  ; if nothing found
    keyboard_get_key_key_found:
    pop bc  ; restoring keyboard_get_key_row_loop data
    ld a, (hl)  ; found char
    or a  ; if it zero?
    jr z, keyboard_get_key_key_found_previous
    ld d, (hl)  ; found char byte
    ld a, (keyboard_previous_scanned_char)  ; previously found char byte
    cp d  ; if current char == previously found char
    jr z, keyboard_get_key_key_found_previous
    ld a, (hl)  ; found char byte
    ld (keyboard_previous_scanned_char), a  ; writing found char to var
    ld e, a  ; returning found byte
    jr keyboard_get_key_end
    keyboard_get_key_key_found_nothing:
    ld a, 0  ; nothing found
    ld (keyboard_previous_scanned_char), a  ; writing found char to var
    keyboard_get_key_key_found_previous:
    ld e, 0  ; returning 0 if found char == previously found char
    keyboard_get_key_end:
    ld d, 0  ; dymmy byte

    ld a, 0  ; resseting hardware row bitmask
    out (IO_KBD_ADDR), a

    pop hl  ;return address
    push de  ; return value
    push hl  ; return address
    ret

.section .bss

keyboard_previous_scanned_char:
    .skip 1
