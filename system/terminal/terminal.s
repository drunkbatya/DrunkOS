.include "terminal/terminal.inc"
.include "keyboard/keyboard.inc"

.section .text

.section .data

terminal_current_coordinates:
    terminal_current_x: .byte 0
    terminal_current_y: .byte 4

terminal_move_visible_area_flag:
    .byte 1

.section .bss

terminal_input_string:
    .skip TERMINAL_INPUT_STRING_SIZE
