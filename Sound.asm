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

    ld b,8
1 push bc

    ld a,%0001000       ;   Borde negro [10] 7 t/states
    out ($fe),a         ;   Beeper ON.
    call Retardo

    xor a
    out ($fe),a         ;   Beeper OFF.
    call Retardo

    pop bc
    djnz 1B

    ret

; -----------------------------------------------------

Retardo

    ld bc,$021f         ;   [20]            10 t/states

1 dec bc                ;   [26]             6 t/states
    ld a,b              ;   [30]             4 t/states
    or c                ;   [34]             4 t/states
    jr nz,1B            ;   [46]            12 t/states

    ret

; -----------------------------------------------------

;    push                ;   [31]            11 t/states
;    ld b,c              ;   [35]             4 t/states
;1 djnz 1B               ;   [3345]        3310 t/states
;2 djnz 2B               ;
;    ld b,$ff  ;   7 t/states
;   1 djnz 1B   ;   3310 t/states




