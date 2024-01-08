.include "hardware/io.inc"
.include "keyboard/keyboard.inc"

.section .text

keyboard_get_key:
    pop hl  ; return address

    ld a, 0xFF  ; row 2
    out (IO_KBD_ADDR), a
    ld a, 0
    in a, (IO_KBD_ADDR)
    ld e, a
    ld d, 0

    push de  ; return value
    push hl  ; return address
    ret


    ;pop de  ; return address
    ;ld hl, 0  ; output code
    ;ld b, 8
    ;keyboard_get_key_row_loop:
    ;80 gel night
    ;100 gel night
    ;120 gel
    ;ld a, 0xFF  ; row 0
    ;out (IO_KBD_ADDR), a
    ;out (IO_KBD_ADDR), a
    ;out (IO_KBD_ADDR), a
    ;out (IO_KBD_ADDR), a
    ;nop
    ;in a, (IO_KBD_ADDR)
    ;ld l, a
    ;ld h, 0
    ;push hl  ; return value
    ;push de  ; return address
    ;ret

.section .rodata

keyboard_map:
    keyboard_map_row0: .byte 1
    keyboard_map_row1: .byte 2
