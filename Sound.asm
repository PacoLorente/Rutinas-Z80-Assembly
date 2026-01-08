;   2/1/26

Efecto_laser:

;   (Variables cuando ejecutamos el Rayo de salida).

;   $9551 (Sound_2) ..... $00f0
;   $9553 (Sound)   ..... $0172

;   HL define el sonido.
;
;   L define el retardo o longitud de cada semiciclo de la onda.
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

    ld hl,(Sound_2)
    ld a,h
    or l

    jr z,$

    ret z

    ld c,10                 ; 10 ondas por ciclo de ejecución.

Loop_2

    ld hl,(Sound)

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Beeper ON.

Delay_5 dec hl
    ld a,h
    or l
    jr nz,Delay_5

    ld hl,(Sound)

    xor a                   ; Borde negro.
    out ($fe),a             ; Beeper OFF.

Delay_6 dec hl
    ld a,h
    or l
    jr nz,Delay_6

; Hemos generado una onda sonora. La siguiente onda generará un sonido más grave, para ello incrementamos el Delay de la señal.

    ld a,(Ctrl_5)

    ld hl,(Sound)

; Rayo de entrada o de salida ???

    bit 7,a
    jr nz,1F

    dec hl
    jr 2F

1 inc hl
2 ld (Sound),hl

; Descontamos la onda generada del total de ondas que tiene el efecto, (Sound).

    ld hl,(Sound_2)
    dec hl
    ld (Sound_2),hl

    ld a,h
    or l

    ret z

    dec c

    jr nz,Loop_2

    ret

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

Clean_Sound ld hl,0

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

    jr z,$
    jr z,Clean_Sound

    dec c

    jr nz,Loop_1

    ld (Sound),hl

    ret





