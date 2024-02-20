TERMINAL_DISPLAY_WIDTH = 240
TERMINAL_DISPLAY_HEIGHT = 64
TERMINAL_DISPLAY_WIDTH_BYTES = 240 / 8
TERMINAL_LINE_HEIGHT = 10
TERMINAL_LINE_HEIGHT_BYTES = TERMINAL_LINE_HEIGHT * TERMINAL_DISPLAY_WIDTH_BYTES
TERMINAL_INPUT_STRING_SIZE = 100 ; bytes

; functions
.global terminal_putstr
.global terminal_putchar
.global terminal_process_newline
.global terminal_get_input_string

; variables
.global terminal_current_coordinates
.global terminal_input_string
.global terminal_move_visible_area_flag

; vim: set ft=asm:
