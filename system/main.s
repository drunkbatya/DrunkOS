.include "main.inc"
.include "display/display.inc"
.include "terminal/terminal.inc"
.include "applications/kutakbash/kutakbash.inc"
.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

main:
    call ra6963_init
    call ra6963_clear
    ; call display_init

    ; set cursor ptr
    call ra6963_await_cmd_or_data
    ld a, 5  ; x
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0  ; y
    out (IO_LCD_DATA_ADDR), a
    call ra6963_await_cmd_or_data
    ld a, 0b00100001
    out (IO_LCD_CMD_ADDR), a

    ld hl, 0
    push hl
    call ra6963_set_address_pointer

    ld a, 'F' - 32
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data
    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    ld a, 'u' - 32
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data
    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    ld a, 'c' - 32
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data
    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    ld a, 'k' - 32
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data
    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    ld a, '!' - 32
    call ra6963_await_cmd_or_data
    out (IO_LCD_DATA_ADDR), a  ; writing modified data
    ld a, RA6963_DATA_WRITE_AND_INC_ADDR  ; display address pointer will be incremented
    call ra6963_await_cmd_or_data
    out (IO_LCD_CMD_ADDR), a

    ;ld hl, system_welcome_str
    ;push hl
    ;call terminal_putstr

    ;ld hl, system_test_str
    ;push hl
    ;call terminal_putstr

    ;call kutakbash_main

    halt

.section .rodata

system_welcome_str:
    .asciz "Welcome to DrunkOS!\n\n"

system_test_str:
    .asciz "Test.\nTest..\nTest...\nTest....\nTest.....\nTest......\n"
