TERMINAL_LINE_HEIGHT = 10
TERMINAL_DISPLAY_WIDTH = 240
TERMINAL_DISPLAY_HEIGHT = 64
TERMINAL_DISPLAY_WIDTH_BYTES = 240 / 8

; functions
.global terminal_putstr

; variables
.global terminal_current_coordinates
.global terminal_current_x
.global terminal_current_y

; vim: set ft=asm: