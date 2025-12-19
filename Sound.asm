Sonido_disparo:

    ld hl,(Sound)

    ld a,h
    or l
    ret z

    ld a,%00010000        ; Borde negro [10] 7 t/states
    out ($fe),a           ; Beeper ON.

    call Aplica_Delay

    xor a
    out ($fe),a

    ret

; ----- ----- ----- ----- -----

Aplica_Delay

    dec hl                ; Aplica Retardo.
    ld a,h
    or l
    jr nz,Aplica_Delay

    ret
