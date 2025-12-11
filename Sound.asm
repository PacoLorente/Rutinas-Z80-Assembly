;   Beeper.

Beeper:

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

    ld bc,(Sound)
    ld a,b
    or c
    ret z                 ; RET si no hay sonido que reproducir.

;   Existe sonido a reproducir.

;    push bc

    ld a,%00010000        ; Borde negro [10] 7 t/states
    out ($fe),a           ; Beeper ON.

;    dec c
;    nop
;    nop
;    nop

    call Aplica_Delay       

    xor a
    out ($fe),a           ; Beeper OFF.

    ld hl,Sound_duration
    dec (hl)
    ret nz

    ld (Sound),bc

;    pop bc
;    dec bc
;    call Aplica_Delay

    ret

; ----- ----- ----- ----- -----

Aplica_Delay

    dec bc                ; Aplica Retardo.
    ld a,b
    or c
    jr nz,Aplica_Delay

    ret
