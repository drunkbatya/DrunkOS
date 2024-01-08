.include "applications/kutakbash/kutakbash.inc"
.include "terminal/terminal.inc"
.include "keyboard/keyboard.inc"

.section .text

kutakbash_main:
    push hl

    ld hl, kutakbash_prompt
    push hl
    call terminal_putstr

    ld hl, kutakbash_cursor
    push hl
    call terminal_putstr

    call keyboard_get_key
    pop hl
    ld b, 8
    test_loop:
        bit 0, l
        jr z, test_zero

        ld de, test_one
        push de
        call terminal_putstr
        jr test_end

        test_zero:
        ld de, test_none
        push de
        call terminal_putstr

        test_end:
        srl l
        djnz test_loop

    pop hl
    ret

.section .data

kutakbash_prompt:
    .asciz "KutakBash[/]: "
kutakbash_cursor:
    .asciz "|"

test_none:
    .asciz "."
test_one:
    .asciz "!"
