.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_await_cmd_or_data:
    in a, (IO_LCD_CMD_ADDR)
    bit 0, a ; checking STA0 - command execution capability
    jp z, ra6963_await_cmd_or_data ; if no (z flag is set means bit 0 = 0) loop again
    bit 1, a ; checking STA1 - data read/write capability (must be checked with STA0)
    jp z, ra6963_await_cmd_or_data ; if no (z flag is set means bit 1 = 0) loop again
    ret

ra6963_await_data_auto_mode_read:
    in a, (IO_LCD_CMD_ADDR)
    bit 2, a ; checking STA2 - auto mode data read capability
    jp z, ra6963_await_data_auto_mode_read ; if no (z flag is set means bit 2 = 0) loop again
    ret

ra6963_await_data_auto_mode_write:
    in a, (IO_LCD_CMD_ADDR)
    bit 3, a ; checking STA3 - auto mode data write capability
    jp z, ra6963_await_data_auto_mode_write ; if no (z flag is set means bit 3 = 0) loop again
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
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    ret

ra6963_reset_auto_write:
    call ra6963_await_cmd_or_data
    ld a, RA6963_RESET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    ret
