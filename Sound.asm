;   Basic Sound Routine.
;
;   Sonido del disparo de Amadeus.

;   INPUTS: (Sound)

;   MODIFY: HL y A, siempre que (Sound) contenga dato.

Sonido_disparo:

    ld hl,(Sound)

    ld a,h
    or l
    ret z                   ; RET si no existe sonido a ejecutar.

; HL definen el sonido.
;
;   L define el retardo o longitud de cada semiciclo de la onda.
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

; Beeper activo.

    ld c,9                  ; 5 ondas completas per frame.

Loop

    ld a,%00010000          ; Borde negro [10] 7 t/states
    out ($fe),a             ; Beeper ON.

; call Aplica_Delay

    ld b,l

Delay_1 djnz Delay_1

; Beeper inactivo.

    xor a
    out ($fe),a

    ld b,l

Delay_2 djnz Delay_2

; Hemos generado una onda sonora. La siguiente onda generará un sonido más grave, para ello incrementamos el Delay de la señal.

    inc l
    inc l
    inc l
    inc l

    dec h

    jr z,Clean_Sound

    dec c

    jr nz,Loop

    ld (Sound),hl

    ret

Clean_Sound ld l,0

    ld (Sound),hl

    ret





