.include "hardware/io.inc"
.include "keyboard/keyboard.inc"

; About:
;   Scans keyboard and returns the pressed key
; Args:
;   None
; Return:
;   unsigned char c - pressed char code
; C Prototype:
; unsigned char keyboard_get_key(void);
keyboard_get_key:
    ld a, 0x20  ; setting row 5
    out (IO_KBD_ADDR), a  ; setting row
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    nop  ; keep calm
    in a, (IO_KBD_ADDR)  ; reading column
    bit 1, a  ; if shift pressed?
    jr nz, keyboard_get_key_shift_pressed

    ld hl, keyboard_matrix_map  ; loading keyboard_matrix_map ptr
    jr keyboard_get_key_row_start

    keyboard_get_key_shift_pressed:
    ld hl, keyboard_matrix_map_shift

    keyboard_get_key_row_start:
    ld b, 8  ; keyboard row
    ld c, 1  ; hardware row bitmask
    ld de, 8  ; value to increase the keyboard_matrix_map ptr (one row)
    keyboard_get_key_row_loop:
        ld a, c  ; hardware row bitmask
        out (IO_KBD_ADDR), a  ; setting row
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        nop  ; keep calm
        in a, (IO_KBD_ADDR)  ; reading column
        or a  ; if current column containts something?
        jr z, keyboard_get_key_skip_column  ; if no, skipping column loop
        push bc  ; storing keyboard_get_key_row_loop data
        push de  ; storing value to increase the keyboard_matrix_map ptr
        ld b, 8  ; keyboard column loop
        ld c, 1  ; hardware column bitmask
        keyboard_get_key_column_loop:
            ld e, a
            and c  ; if current hardware column bitmask matches pressed key
            ld a, e
            ; check zero here
            jr nz, keyboard_get_key_key_found
            sla c  ; going to the next hardware column
            inc hl  ; increasing the keyboard_matrix_map ptr
            djnz keyboard_get_key_column_loop
        keyboard_get_key_column_loop_end:
        pop de  ; restoring value to increase the keyboard_matrix_map ptr
        pop bc  ; restoring keyboard_get_key_row_loop data
        keyboard_get_key_skip_column:
        sla c  ; going to the next hardware row
        add hl, de  ; increasing the keyboard_matrix_map ptr by 8
        djnz keyboard_get_key_row_loop
    ld a, 0
    ld e, a
    ld (keyboard_previous_scanned_char), a
    jr keyboard_get_key_end
    keyboard_get_key_key_found:
    pop de  ; restoring value to increase the keyboard_matrix_map ptr
    pop bc  ; restoring keyboard_get_key_row_loop data
    ld a, (hl)  ; found char
    or a
    jr z, keyboard_get_key_key_found_previous
    ld d, (hl)  ; found char byte
    ld a, (keyboard_previous_scanned_char)  ; previously found char byte
    cp d  ; if current char == previously found char
    jr z, keyboard_get_key_key_found_previous
    ld a, d  ; found char byte
    ld (keyboard_previous_scanned_char), a  ; writing found char to var
    ld e, a  ; returning found byte
    jr keyboard_get_key_end
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
