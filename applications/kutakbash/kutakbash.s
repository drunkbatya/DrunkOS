.include "applications/kutakbash/kutakbash.inc"
.include "terminal/terminal.inc"
.include "keyboard/keyboard.inc"

.section .text

kutakbash_main:
    push hl
    push af

    ld hl, kutakbash_prompt
    push hl
    call terminal_putstr

    ld hl, kutakbash_cursor
    push hl
    call terminal_putstr

    kutakbash_main_loop:
        call keyboard_get_key
        pop hl

        ld a, l  ; loading byte
        or a  ; if it zero?
        jr z, kutakbash_main_loop
        push hl
        call terminal_putchar
        jr kutakbash_main_loop

    pop af
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
