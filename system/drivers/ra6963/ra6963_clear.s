.include "drivers/ra6963/ra6963.inc"
.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_clear_text_area:
    ld hl, 0
    push hl
    call ra6963_set_address_pointer
    call ra6963_set_auto_write
    ld b, 0
ra6963_clear_text_area_loop:
    call ra6963_await_data_auto_mode_write
    ld a, 0x00
    out (IO_LCD_DATA_ADDR), a
    djnz ra6963_clear_text_area_loop
    call ra6963_reset_auto_write
    ret

