; IO map:
;   A0-A3 - IO free lines
;   A4 - internal decoder low active
;   A5-A7 - IO device number in binnary
;       0b0000xxxx - device 0
;       0b1110xxxx - device 7
;       0bxxx1xxxx - decoder disabled, other bus lines are yours

IO_LCD_DATA_ADDR = 0b00000000  ; A5 = 0 - device 0, A0 = 0 - lcd data transfer
IO_LCD_CMD_ADDR = 0b00000001  ; A5 = 0 - device 0, A0 = 1 - lcd command transfer

IO_KBD_ADDR = 0b00100000 ; A5 = 1 - device 1

; vim: set ft=asm:
