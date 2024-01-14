.include "main.inc"
.include "display/display.inc"
.include "terminal/terminal.inc"
.include "applications/kutakbash/kutakbash.inc"
.include "drivers/ra6963/ra6963.inc"

.section .text

main:
    call display_init

    ld hl, system_welcome_str
    push hl
    call terminal_putstr

    ld hl, system_test_str
    push hl
    call terminal_putstr

    call kutakbash_main

    halt

.section .rodata

system_welcome_str:
    .asciz "Welcome to DrunkOS!\n\n"

system_test_str:
    .asciz "Test.\nTest..\nTest...\nTest....\nTest.....\n"
