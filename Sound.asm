;   29/12/25
;
;   FX Sounds.
;
;   INPUTS: (Sound)

;   MODIFY: HL,B y A, siempre que (Sound) contenga dato.

Genera_sonido:

    ld hl,(Sound)

    ld a,h
    or l
    ret z                   ; RET si no existe sonido a ejecutar.

;   What sound are we going to play ???

    ld a,(Sound_type)
    and a
    jr z,Efecto_disparo

Efecto_explosion

;   HL define el sonido.
;
;   L define el retardo o longitud de cada semiciclo de la onda, en este caso un valor aleatorio, (0-$ff).
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

    ld c,4                  ; 4 ondas completas per frame.

Loop

    ld a,r
    ld b,a

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Beeper ON.

Delay_1 djnz Delay_1        ; Aplica Delay.

    xor a
    out ($fe),a             ; Beeper OFF.

    ld a,r
    ld b,a

Delay_2 djnz Delay_2        ; Aplica Delay.

    dec h

    jr z,Clean_Sound        ; Hemos tardado de reproducir el soniquete, limpiamos (Sound) y salimos.

    dec c

    jr nz,Loop

    ld (Sound),hl

    ret

Clean_Sound ld l,0

    ld (Sound),hl
    xor a
    ld (Sound_type),a

    ret

; ----- ----- ----- ----- -----

Efecto_disparo

;   HL define el sonido.
;
;   L define el retardo o longitud de cada semiciclo de la onda.
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

    ld c,5                  ; 5 ondas completas per frame.

Loop_1

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Beeper ON.

    ld b,l

Delay_3 djnz Delay_3        ; Aplica Delay.

    xor a
    out ($fe),a

    ld b,l

Delay_4 djnz Delay_4        ; Aplica Delay.

; Hemos generado una onda sonora. La siguiente onda generará un sonido más grave, para ello incrementamos el Delay de la señal.

    inc l
    inc l
    inc l
    inc l

    dec h

    jr z,Clean_Sound

    dec c

    jr nz,Loop_1

    ld (Sound),hl

    ret





