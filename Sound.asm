Beeper:

    ld bc,(Sound)

    ld a,b
    or c
    ret z

    jr $

    ld a,%00010000        ; Borde negro [10] 7 t/states
    out ($fe),a           ; Beeper ON.

    call Aplica_Delay       

    xor a
    out ($fe),a           ; Beeper OFF.

;    dec (hl)

    ret

Sound_Constructor:

;   Vamos a generar un DO continuo.
;   La frecuencia de un Do es 130,6Hz.
;   Dado que la CPU trabaja a una frecuencia de 3.5 MHz, dividiendo 3500000/130,6 tendremos la duración en T/states de la señal que genera la nota Do.
;   Esta cantidad la dividiremos /2 para saber cuántos t/states estará activado el beeper y cuantos t/states estará desactivado.
;
;
;   3500000 / 130,6 = 26799
;   26799 / 2 = 14000 t/states.

;   Puerto 254, $fe
;
;   Out. A = 11101111
;
;   Bits 0,1 y 2 ..... Color del borde.
;   Bit 3        ..... Mic/ear
;   Bit 4        ..... Speaker.

; -----------------------------------------------------
;                       ;   [13301]      12281 t/states bc $01ff
;                       ;   [13327]      13307 t/states bc $0200
;                       ;   [13743]      13723 t/states bc $0210
;                       ;   [14159]      14139 t/states bc $0220
;                       ;                14061 t/states bc $021d
;                       ;                14035 t/states bc $021c
;                       ;                14009 t/states bc $021b *
;                       ;                13083 t/states bc $021a

    ld a,3
    ex af,af

    ld bc,5
    ld hl,Sound
    exx

    ld hl,Sound

2 ld c,(hl)
    inc hl
    ld b,(hl)
    dec hl                

    ld a,b
    or c
    ret z                 ; RET si no hay sonido que reproducir.

;   Existe sonido a reproducir.

    ex de,hl

1 push bc

    ld a,%00010000        ; Borde negro [10] 7 t/states
    out ($fe),a           ; Beeper ON.

;   Delay .....
    dec c
    nop
    nop
    nop
;   Delay .....

    call Aplica_Delay       

    xor a
    out ($fe),a           ; Beeper OFF.

    pop bc

;   Delay .....
    dec bc
;   Delay .....

    call Aplica_Delay

;   Nº de veces que vamos a generar la onda, duración del sonido.
<<<<<<< HEAD
;
;    ld a,(Sound_duration)
    dec a                               ; dec. (Nº de ciclos que hemos de reproducir la nota).;
;    ld (Sound_duration),a               ; Recupera puntero de sonido, EX no afecta a los FLAGS.
=======

    ld hl,Sound_duration
    dec (hl)
<<<<<<< HEAD
>>>>>>> parent of a519388 (17/12/25. Sonido de disparo diseñado, ahora toca implementarlo en el juego.)
=======
>>>>>>> parent of a519388 (17/12/25. Sonido de disparo diseñado, ahora toca implementarlo en el juego.)

    ex de,hl              ; Recupera puntero de sonido, EX no afecta a los FLAGS.

    jr nz,2B

;   Fin de la 1ª nota.

    ex af,af
    dec a
    jr z,$

;    ret z                

; Prepara la 2ª nota.

    ex af,af

    exx

    inc hl
    inc hl

    push hl
    push hl

    adc hl,bc
    dec bc

    ld a,(hl)
<<<<<<< HEAD
<<<<<<< HEAD
;    ld (Sound_duration),a
=======
    ld (Sound),a
>>>>>>> parent of a519388 (17/12/25. Sonido de disparo diseñado, ahora toca implementarlo en el juego.)
=======
    ld (Sound),a
>>>>>>> parent of a519388 (17/12/25. Sonido de disparo diseñado, ahora toca implementarlo en el juego.)

    pop hl

    exx

    pop hl

    jr 2B   

    ret

; ----- ----- ----- ----- -----

Aplica_Delay

    dec bc                ; Aplica Retardo.
    ld a,b
    or c
    jr nz,Aplica_Delay

    ret
