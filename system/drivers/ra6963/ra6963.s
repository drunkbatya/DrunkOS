.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_await_cmd_or_data:
    push af  ; storing af
ra6963_await_cmd_or_data_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 0, a ; checking STA0 - command execution capability
    jr z, ra6963_await_cmd_or_data_loop ; if no (z flag is set means bit 0 = 0) loop again
    bit 1, a ; checking STA1 - data read/write capability (must be checked with STA0)
    jr z, ra6963_await_cmd_or_data_loop ; if no (z flag is set means bit 1 = 0) loop again
    pop af  ; restoring af
    ret

ra6963_await_data_auto_mode_read:
    push af  ; storing af
ra6963_await_data_auto_mode_read_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 2, a ; checking STA2 - auto mode data read capability
    jr z, ra6963_await_data_auto_mode_read_loop ; if no (z flag is set means bit 2 = 0) loop again
    pop af  ; restoring af
    ret

ra6963_await_data_auto_mode_write:
    push af  ; storing af
ra6963_await_data_auto_mode_write_loop:
    in a, (IO_LCD_CMD_ADDR)
    bit 3, a ; checking STA3 - auto mode data write capability
    jr z, ra6963_await_data_auto_mode_write_loop ; if no (z flag is set means bit 3 = 0) loop again
    pop af  ; restoring af
    ret

ra6963_set_graphic_home_address:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 6  ; there is no way to set load sp value to ix, skipping pushed 2 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ; set graphic home addres
    call ra6963_await_cmd_or_data
    ld a, (ix + 0)  ; address low byte
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, (ix + 1)  ; address high byte
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_GRAPHIC_HOME_ADDRESS
    out (IO_LCD_CMD_ADDR), a

    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

ra6963_set_text_home_address:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 6  ; there is no way to set load sp value to ix, skipping pushed 2 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ; set text home addres
    call ra6963_await_cmd_or_data
    ld a, (ix + 0)  ; address low byte
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, (ix + 1)  ; address high byte
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_TEXT_HOME_ADDRESS
    out (IO_LCD_CMD_ADDR), a

    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

ra6963_set_address_pointer:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 6  ; there is no way to set load sp value to ix, skipping pushed 2 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    call ra6963_await_cmd_or_data
    ld a, (ix + 0)  ; writing low address byte first
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, (ix + 1)  ; writing high address byte last
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_ADDRESS_POINTER
    out (IO_LCD_CMD_ADDR), a

    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

ra6963_set_cursor_pointer:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 6  ; there is no way to set load sp value to ix, skipping pushed 2 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    call ra6963_await_cmd_or_data
    ld a, (ix + 0)  ; writing x
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, (ix + 1)  ; writing y
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_CURSOR_POSITION
    out (IO_LCD_CMD_ADDR), a

    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg1
    push hl  ; return address
    exx  ; restoring registers
    ret

ra6963_set_auto_write:
    push af  ; storing af
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    pop af  ; restoring af
    ret

ra6963_reset_auto_write:
    push af  ; storing af
    call ra6963_await_cmd_or_data
    ld a, RA6963_RESET_AUTO_WRITE
    out (IO_LCD_CMD_ADDR), a
    pop af  ; restoring af
    ret

; About:
;   Read-Modify-Write function. Reads byte from display, makes logical OR with the argument and writes back.
; Warnings:
;   1. Display address pointer will be increased after calling this function
;   2. Display address must be set before calling this function
; Args:
;   uint8_t data
ra6963_modify_byte:
    push af  ; storing af
    push ix  ; storing ix
    ld ix, 6  ; there is no way to set load sp value to ix, skipping 2 pushed reg pairs and the return pointer
    add ix, sp  ; loading sp value to ix

    ld a, RA6963_DATA_READ  ; read byte pointed by display's address pointer first
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a  ; sending read byte command
    call ra6963_await_cmd_or_data
    in a, (IO_LCD_DATA_ADDR)  ; reading byte
    or (ix + 0)  ; OR'ing current byte with data
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data

    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; arg1
    push hl  ; return address
    exx  ; restoring registers
    ret
