.include "main.inc"
.include "hardware/io.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

draw_text:
    ld hl, 0
    push hl
    call ra6963_set_address_pointer
    ld hl, 0
    push hl
    call ra6963_set_cursor_position

    call ra6963_set_auto_write
    call ra6963_await_data_auto_mode_write
    ld a, 0x28 ; 'H'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x45 ; 'e'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4C ; 'l'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4C ; 'l'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4F ; 'o'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x0C ; ','
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x00 ; ' '
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4D ; 'm'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4F ; 'o'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x54 ; 't'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x48 ; 'h'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x45 ; 'e'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x52 ; 'r'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x46 ; 'f'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x55 ; 'u'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x43 ; 'c'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x4B ; 'k'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x45 ; 'e'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x52 ; 'r'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x01 ; '!'
    out (IO_LCD_DATA_ADDR), a

    call ra6963_await_data_auto_mode_write
    ld a, 0x01 ; '!'
    out (IO_LCD_DATA_ADDR), a
    call ra6963_reset_auto_write
    ret

main:
    call ra6963_init
    call ra6963_clear_text_area
    call draw_text
    halt
