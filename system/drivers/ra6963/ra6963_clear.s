.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

ra6963_clear:
    push hl
    push bc
    push af

    ld hl, 0  ; start filling framebuffer from address zero
    push hl
    call ra6963_set_address_pointer

    ld hl, 2920  ; framebuffer size
    ld bc, 0  ; to compare hl with
    ld a, 0  ; cleared screen value
    call ra6963_set_auto_write
ra6963_clear_loop:
    call ra6963_await_data_auto_mode_write
    out (IO_LCD_DATA_ADDR), a
    dec hl  ; going next byte
    or a  ; just for clear carry flag
    sbc hl, bc  ; compare with zero (all buffer filled)
    jr nz, ra6963_clear_loop
    call ra6963_reset_auto_write

    pop af
    pop bc
    pop hl
    ret
