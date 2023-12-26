.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_init:
    push af
    ; set text home address
    call ra6963_await_cmd_or_data
    ld a, 0
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_TEXT_HOME_ADDR
    out (IO_LCD_CMD_ADDR), a

    ; set text area
    call ra6963_await_cmd_or_data
    ld a, 0x1E ; 240/8
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0x00
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_TEXT_AREA
    out (IO_LCD_CMD_ADDR), a

    ; set graphic home addres
    call ra6963_await_cmd_or_data
    ld a, 0x00
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0x00 ; adress 0 (maybe you want to set another in case of using text mode)
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_GRAPHIC_HOME_ADDRES
    out (IO_LCD_CMD_ADDR), a

    ; set graphic area
    call ra6963_await_cmd_or_data
    ld a, 0x1E ; 240/8
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0x00
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_GRAPHIC_AREA
    out (IO_LCD_CMD_ADDR), a

    ; set 1 line cursor
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_1_LINE_CURSOR
    out (IO_LCD_CMD_ADDR), a

    ; mode set
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_OR_MODE
    out (IO_LCD_CMD_ADDR), a

    ; display mode
    call ra6963_await_cmd_or_data
    ld a, RA6963_SET_TEXT_OFF_GRAPHIC_ON
    out (IO_LCD_CMD_ADDR), a

    pop af
    ret
