.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

; sets pixel in specified coordinates (y, x)
; Args:
;   x - 8 bit
;   y - 8 bit
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
    ld b, 8  ; we don't need 'y' value anymore
ra6963_set_pixel_divide_loop:
    cp b  ; compairing 'x' in a with 8 (bits in byte) in b
    jr c, ra6963_set_pixel_divide_loop_end ; if x < 8, reminder in a, division ended
    inc hl  ; add one more byte to address
    sub b  ; subtracting 8 bits from 'x' (in a), keep going
    jr ra6963_set_pixel_divide_loop
ra6963_set_pixel_divide_loop_end:
    push hl  ; setting integer part of address to display
    call ra6963_set_address_pointer

    call ra6963_await_cmd_or_data
    ld b, a  ; we need to invert the reminder
    ld a, 7  ; invert = 7 (max reminder value) - reminder
    sub b  ; 7 (in a) - reminder -> a
    add a, RA6963_SET_BIT  ; setting target bit (division reminder)
    out (IO_LCD_CMD_ADDR), a  ; executing SET BIT lcd instruction

    ret  ; fuf, going home
