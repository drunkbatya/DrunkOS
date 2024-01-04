.include "drivers/ra6963/ra6963.inc"
.include "hardware/io.inc"

.section .text

; About:
;   Converted bitmaps are 8 bits aligned, so we need convert width in bits to bytes
; Args:
;   uint8_t width - width in bits
; Return:
;   uint8_t width_bytes - width in bytes
; C Prototype:
;   uint8_t ra6963_draw_xbm_get_bytes_by_width(uint8_t width);
ra6963_draw_xbm_get_bytes_by_width:
    push af  ; storing af
    push ix  ; storing ix
    push bc  ; storing bc
    ld ix, 8  ; there is no way to set load sp value to ix, skipping pushed 4 args and return address
    add ix, sp  ; loading sp value to ix

    ld a, (ix + 1)  ; bitmap width in bits
    ld b, 8  ; bits in byte
    ld c, 0  ; return value
    ra6963_draw_xbm_get_bytes_by_width_divide_loop:
        cp b  ; compairing 'width' in a with 8 (bits in byte) in b
        jr z, ra6963_draw_xbm_get_bytes_by_width_divide_loop_end ; if width == 8
        jr c, ra6963_draw_xbm_get_bytes_by_width_divide_loop_end ; if width < 8, reminder in a, division ended
        inc c  ; if width > 8, add one more byte to return value
        sub b  ; subtracting 8 bits from 'width' (in a), keep going
        jr ra6963_draw_xbm_get_bytes_by_width_divide_loop
    ra6963_draw_xbm_get_bytes_by_width_divide_loop_end:
    inc c  ; add one more byte if we have reminder (always, if we r here)
    ld (ix + 1), c  ; rewriting stack arg!, bitmap width now in bytes

    pop bc  ; restoring bc
    pop ix  ; restoring ix
    pop af  ; restoring af

    ret

; About:
;   Return integer part of display address and bit offset by x and y
; Args:
;   uint8_t x - x coordinate
;   uint8_t y - y coordinate
; Return;
;   uint16_t addr - integer part of display address
;   uint8_t offset - bit offset
; C Prototype:
;   struct DispAddr ra6963_get_address_and_bit_offset(uint8_t x, uint8_t y);
ra6963_get_address_and_bit_offset:
    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    ld bc, 0  ; add one more arg cause functions recives one 16 bit arg and return 2
    push bc  ; pushing one more arg to stack
    push hl  ; pushing return pointer back
    exx  ; restroing register pairs

    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 3 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld hl, 0  ; display address pointer
    ld a, (ix + 3)  ; loading 'y' to a
    or a  ; check if 'y' is 0
    jr z, ra6963_get_address_and_bit_offset_multiply_loop_end  ; skip multiplying if 'y' is 0
    ld de, RA6963_DISPLAY_WIDTH_BYTES  ; how many bytes in one 'y'?
    ld b, a
    ra6963_get_address_and_bit_offset_multiply_loop:
        add hl, de
        djnz ra6963_get_address_and_bit_offset_multiply_loop  ; adding display width in bytes to addr 'y' times
    ra6963_get_address_and_bit_offset_multiply_loop_end:  ; now we have calculated 'y' offset in hl
    ld a, (ix + 2)  ; loading 'x' in a
    ld b, 8  ; we don't need 'y' value anymore
    ra6963_get_address_and_bit_offset_divide_loop:
        cp b  ; compairing 'x' in a with 8 (bits in byte) in b
        jr c, ra6963_get_address_and_bit_offset_divide_loop_end ; if x < 8, reminder in a, division ended
        inc hl  ; add one more byte to address
        sub b  ; subtracting 8 bits from 'x' (in a), keep going
        jr ra6963_get_address_and_bit_offset_divide_loop
    ra6963_get_address_and_bit_offset_divide_loop_end:
    ld (ix + 0), a  ; reminder
    ld (ix + 1), 0  ; just zero to fill 8 bit arg to 16 bits
    ld (ix + 2), l  ; rewriting stack arg, returning integer part of display address
    ld (ix + 3), h  ; rewriting stack arg, returning integer part of display address

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    ret

; About:
;   Draw bitmap to x, y
; Args:
;   const uint8_t* data - pointer to bitmap data
;   uint8_t width - bitmap width
;   uint8_t height - bitmap height
;   uint8_t x - x coordinate
;   uint8_t y - y coordinate
; Return:
;   None
; C prototype:
;   void ra6963_draw_xbm(const uint8_t* data, uint8_t width, uint8_t height, uint8_t x, uint8_t y);
ra6963_draw_xbm:
    push af  ; storing af
    push ix  ; storing ix
    push hl  ; storing hl
    push de  ; storing de
    push bc  ; storing bc

    ld ix, 12  ; there is no way to set load sp value to ix, skipping pushed 5 reg pairs and return address
    add ix, sp  ; loading sp value to ix

    ld e, (ix + 0)  ; loading high byte of bitmap data ptr
    ld d, (ix + 1)  ; loading low byte of bitmap data ptr

    ld b, (ix + 2)  ; bitmap width in bits
    push bc
    call ra6963_draw_xbm_get_bytes_by_width
    pop bc
    ld (ix + 2), b  ; rewriting stack arg!, bitmap width now in bytes

    ld l, (ix + 4)  ; loading x
    ld h, (ix + 5)  ; loading y
    push hl  ; function argument
    call ra6963_get_address_and_bit_offset
    pop hl  ; x bit offset
    ld (ix + 4), l  ; rewriting stack arg!, x now is only a bit offset of the already calculated display address
    pop hl  ; integer part of display address
    ld b, (ix + 3)  ; icon height
    display_draw_xbm_height_loop:
        push hl  ; display address pointer
        call ra6963_set_address_pointer
        push bc  ; storing b of height_loop
        ld b, (ix + 2)  ; bitmap width in bytes
        display_draw_xbm_width_loop:
            push hl  ; storing hl
            ld a, (de)  ; icon byte to draw
            ld l, a  ; first function arg, there is no way to 'ld l, (de)'
            ld h, (ix + 4)  ; second function arg, bit offset
            push hl  ; function arguments
            call ra6963_draw_byte  ; read-modify-write, display address will be incremented by 1
            pop hl  ; restoring hl
            inc de  ; next icon byte
            djnz display_draw_xbm_width_loop
        ld bc, RA6963_DISPLAY_WIDTH_BYTES
        add hl, bc  ; setting new line
        pop bc  ; restoring b of height_loop
        djnz display_draw_xbm_height_loop

    pop bc  ; restoring bc
    pop de  ; restoring de
    pop hl  ; restoring hl
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    pop bc  ; removing arg2
    pop bc  ; removing arg3
    push hl  ; return address
    exx  ; restoring registers
    ret

; About:
;   Draws a byte on display with the bit offset
; Warnings:
;   1. Display address pointer will be increased (by 1 or 2, depends on the bit offset) after calling this function
;   2. Display address must be set before calling this function
; Args:
;   uint8_t data - byte to draw
;   uint8_t bit_offset - bit offset, from 0 to 7
; Return:
;   None
; C prototype:
;   void ra6963_draw_byte(uint8_t data, uint8_t bit_offset);
ra6963_draw_byte:
    push af  ; storing af
    push ix  ; storing ix
    push bc  ; storing bc

    ld ix, 8  ; there is no way to set load sp value to ix, skipping pushed 4 reg pairs and the return address
    add ix, sp  ; loading sp value to ix

    ld a, (ix + 1)  ; loading the bit offset
    or a  ; check if zero
    jr z, ra6963_draw_byte_write_only_one_byte

    ld a, (ix + 0)  ; byte to draw
    ld b, (ix + 1)  ; bit offset
    ra6963_draw_byte_first_byte_loop:
        srl a  ; shifting byte to draw to n(bit offset) bits right
        djnz ra6963_draw_byte_first_byte_loop
    ld c, a  ; writing shifted byte
    ld b, 0  ; dummy byte
    push bc
    call ra6963_modify_byte  ; address pointer will be incremented by 1 after this

    ld b, (ix + 1)  ; we need to invert the bit offset before doing the left shift
    ld a, 8  ; invert = 8 (max bit offset value + 1(man djnz)) - bit offset
    sub b  ; 8 (in a) - bit offset -> a
    ld b, a  ; inverted bit offset for the djnz loop
    ld a, (ix + 0)  ; byte to draw
    ra6963_draw_byte_second_byte_loop:
        sla a  ; shifting byte to draw to n(bit offset) bits left
        djnz ra6963_draw_byte_second_byte_loop

    ld c, a  ; writing shifted byte
    ld b, 0  ; dummy byte
    push bc
    call ra6963_modify_byte  ; address pointer will be incremented by 1 after this
    jp ra6963_draw_byte_end

    ra6963_draw_byte_write_only_one_byte:
    ld c, (ix + 0)  ; writing shifted byte
    ld b, 0  ; dummy byte
    push bc
    call ra6963_modify_byte  ; address pointer will be incremented by 1 after this

    ra6963_draw_byte_end:
    pop bc  ; restoring bc
    pop ix  ; restoring ix
    pop af  ; restoring af

    exx  ; exchanging register pairs with their shadow
    pop hl  ; return address
    pop bc  ; removing arg1
    push hl  ; return address
    exx  ; restoring registers
    ret
