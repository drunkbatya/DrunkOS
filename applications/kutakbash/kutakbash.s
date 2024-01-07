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
