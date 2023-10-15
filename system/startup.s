EXTERN main

ORG 0

startup:
    ld sp, 0ffffh
    call main
startup_loop:  ; reaching this poit is abnormal
    nop
    jp startup_loop
