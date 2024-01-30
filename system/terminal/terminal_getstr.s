.include "terminal/terminal.inc"

.section .text

terminal_get_input_string:
    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    push bc  ; add one more arg cause functions recives none and returns 1 arg
    push hl  ; pushing return pointer back
    exx  ; restroing register pairs

    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 5 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ld hl, terminal_input_string  ; resseting input buffer
    ld (hl), 0  ; setting null-terminator to position 0

    ld hl, (terminal_current_coordinates)  ; dumping current terminal coordinates, for redraw function
    ld (terminal_input_string_coordinates), hl  ; saving current terminal coordinates into internal variable

    ld de, terminal_input_string  ; buffer add to

    terminal_get_input_string_loop:
        call keyboard_get_key  ; reading keyboard
        pop hl  ; return char code
        ld a, l  ; loading byte
        or a  ; if it zero?
        jr z, terminal_get_input_string_loop
        ; not zero char
        ; check new line
        ld h, 0x0A  ; new line char
        cp h  ; if current char (in a) is a new line?
        jr z, terminal_get_input_string_new_line
        ; check backspace
        ld h, 0x08  ; backspace char
        cp h  ; if current char (in a) is a backspace?
        jr z, terminal_get_input_string_backspace
        ; another printable char, adding to the input buffer
        push hl  ; arg2 of the append_to_string function, printable char in l
        push de  ; arg1 of the append_to_string function, pointer to the dst string
        call append_to_string  ; appending char to a null-terminated string
        ; redraw string
        ld hl, (terminal_input_string_coordinates)  ; loading presaved terminal coordinates value
        ld (terminal_current_coordinates), hl  ; setting terminal coordinates to the presaved value
        push de  ; input buffer
        call terminal_putstr
        ; Clear screen..
        jr terminal_get_input_string_loop
    terminal_get_input_string_backspace:
    ; process backspace, remove a char from the input buffer
    jr terminal_get_input_string_loop  ; going back to loop
    terminal_get_input_string_new_line:
    push hl  ; new line char in l
    call terminal_putchar  ; print new line character directly without adding it to the buffer
    terminal_get_input_string_loop_end:
    ld (ix + 0), e  ; input buffer ptr low byte
    ld (ix + 1), d  ; input buffer ptr high byte

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af
    ret

.section .bss

terminal_input_string_coordinates:
    terminal_input_string_x: .skip 1
    terminal_input_string_y: .skip 1
