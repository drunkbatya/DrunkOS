.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"
.include "assets/build/assets_icons.inc"
.include "display/display.inc"

.section .text

ra6963_clear:
    push hl
    push bc
    push af

    ld hl, 0  ; start filling framebuffer from address zero
    push hl
    call ra6963_set_address_pointer

    ld hl, RA6963_DISPLAY_WIDTH_BYTES * RA6963_DISPLAY_HEIGHT  ; framebuffer size
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

    call ra6963_draw_test_icon

    pop af
    pop bc
    pop hl
    ret

ra6963_unwrap_ptr_to_ptr:
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    ld ix, 8  ; there is no way to set load sp value to ix, skipping pushed 4 args and return address
    add ix, sp  ; loading sp value to ix

    ld l, (ix + 0)  ; loading high byte of icon ptr
    ld h, (ix + 1)  ; loading low byte of icon ptr
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld (ix + 0), e
    ld (ix + 1), d

    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix

    ret

ra6963_draw_test_icon:
    push hl

    ld hl, 0x0105  ; y, x
    push hl
    ld hl, font_haxrcorp_arr + (('$' - 32) * 2) ; 36
    push hl
    call ra6963_unwrap_ptr_to_ptr
    call display_draw_icon

    pop hl
    ret

