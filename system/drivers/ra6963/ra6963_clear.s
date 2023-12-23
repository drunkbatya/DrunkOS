.include "drivers/ra6963/ra6963.inc"
.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_clear:
    ld hl, 0
    push hl
    call ra6963_set_address_pointer
    call ra6963_set_auto_write
    ld hl, 1920
    ld bc, 0
ra6963_clear_loop:
    call ra6963_await_data_auto_mode_write
    ld a, 0
    out (IO_LCD_DATA_ADDR), a
    dec hl
    or a
    sbc hl, bc
    jp nz, ra6963_clear_loop
    call ra6963_reset_auto_write

    ; temp test
    ld hl, 30
    push hl
    call ra6963_set_address_pointer
    call ra6963_await_cmd_or_data
    ld a, 0b11111001
    out (IO_LCD_CMD_ADDR), a

    ld hl, 60
    push hl
    call ra6963_set_address_pointer
    call ra6963_await_cmd_or_data
    ld a, 0b11111001
    out (IO_LCD_CMD_ADDR), a

    ld hl, 90
    push hl
    call ra6963_set_address_pointer
    call ra6963_await_cmd_or_data
    ld a, 0b11111001
    out (IO_LCD_CMD_ADDR), a

    ret

