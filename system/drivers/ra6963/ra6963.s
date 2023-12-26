.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_await_cmd_or_data:
    push af
ra6963_await_cmd_or_data_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 0, a ; checking STA0 - command execution capability
    jp z, ra6963_await_cmd_or_data_loop ; if no (z flag is set means bit 0 = 0) loop again
    bit 1, a ; checking STA1 - data read/write capability (must be checked with STA0)
    jp z, ra6963_await_cmd_or_data_loop ; if no (z flag is set means bit 1 = 0) loop again
    pop af
    ret

ra6963_await_data_auto_mode_read:
    push af
ra6963_await_data_auto_mode_read_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 2, a ; checking STA2 - auto mode data read capability
    jp z, ra6963_await_data_auto_mode_read_loop ; if no (z flag is set means bit 2 = 0) loop again
    pop af
    ret

ra6963_await_data_auto_mode_write:
    push af
ra6963_await_data_auto_mode_write_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 3, a ; checking STA3 - auto mode data write capability
    jp z, ra6963_await_data_auto_mode_write_loop ; if no (z flag is set means bit 3 = 0) loop again
    pop af
    ret

ra6963_set_address_pointer:
    pop hl  ; return address
    pop de  ; d - high address byte, e - low address byte
    call ra6963_await_cmd_or_data
    ld a, e  ; writing low byte first
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, d  ; writing high byte last
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_ADDRESS_POINTER
    out (IO_LCD_CMD_ADDR), a
    jp (hl)  ; we're already poped return address to hl

ra6963_set_cursor_position:
    pop hl  ; return address
    pop de  ; d - high address byte, e - low address byte
    call ra6963_await_cmd_or_data
    ld a, e  ; writing low byte first
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, d  ; writing high byte last
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_CURSOR_POSITION
    out (IO_LCD_CMD_ADDR), a
    jp (hl)  ; we're already poped return address to hl

ra6963_set_auto_write:
    push af
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    pop af
    ret

ra6963_reset_auto_write:
    push af
    call ra6963_await_cmd_or_data
    ld a, RA6963_RESET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    pop af
    ret

; sets pixel in specified coordinates (y, x)
; Args:
;   y - 8 bit
;   x - 8 bit
ra6963_set_pixel:
    pop hl  ; return address
    pop bc  ; b - y, c - x
    push hl  ; return address

    ld hl, 0  ; display address pointer
    ld a, b  ; loading 'y' to a
    or a  ; check if 'y' is 0
    jr z, ra6963_set_pixel_multiply_loop_end  ; skip multiplying if 'y' is 0
    ld de, RA6963_DISPLAY_WIDTH_BYTES  ; how many bytes in one 'y'?
ra6963_set_pixel_multiply_loop:
    add hl, de
    djnz ra6963_set_pixel_multiply_loop  ; adding display width in bytes to addr 'y' times
ra6963_set_pixel_multiply_loop_end:  ; now we have calculated 'y' offset in hl
    ld a, c  ; loading 'x' in a
    or a  ; check if 'x' is 0
    jr z, ra6963_set_pixel_divide_loop_end  ; skip dividing if 'x' is 0
    ld b, 8  ; we don't need 'y' value anymore
ra6963_set_pixel_divide_loop:
    cp b  ; compairing 'x' in a with 8 (bits in byte) in b
    jr c, ra6963_set_pixel_divide_loop_end ; if x < 8, reminder in a, division ended
    inc hl  ; add one more byte to address
    sub b  ; subtracting 8 bits from 'x' (in a), keep going
    jr z, ra6963_set_pixel_divide_loop_end  ; if no reminder (bit offset)
    jr ra6963_set_pixel_divide_loop ; else continue
ra6963_set_pixel_divide_loop_end:
    push af  ; storing remainder on stack
    push hl  ; setting integer part of address to display
    call ra6963_set_address_pointer

    call ra6963_await_cmd_or_data
    pop af  ; restoring remainder from stack
    ld b, a  ; we need to invert the reminder
    ld a, 7  ; invert = 7 (max reminder value) - reminder
    sub b  ; 7 (in a) - reminder -> a
    add a, RA6963_SET_BIT  ; setting target bit (division reminder)
    out (IO_LCD_CMD_ADDR), a  ; executing SET BIT lcd instruction
    ret  ; fuf, going home
