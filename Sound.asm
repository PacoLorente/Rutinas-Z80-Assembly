; ----------------------------------------------------------------------------------------------
;
;   13/4/26
;

Done_melody:


;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido, (duración de la nota).
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).
;		   HL = (NOTA).

    push af
    push bc
    push de
    push hl

	ld bc,$0014
	ld de,$0005
	ld hl,$015e
	ld (Sound),hl
    call Sound_Generator 									; Up to Note_1

    ld c,$14
    ld e,0
    ld (Sound),hl
    call Sound_Generator                                    ; Stay in Note_1.

	ld c,$24
	ld l,$a5
	ld (Sound),hl
    call Sound_Generator 									; Nota_2.

    ld bc,$4000              
	call DELAY 												; Pause entre notas.

	ld c,$14
	ld l,$fa
	ld (Sound),hl
    call Sound_Generator 									; Nota_3.

	ld c,$21
	ld l,$b7
	ld (Sound),hl
    call Sound_Generator 									; Nota_4.

    ld bc,$4000             
	call DELAY 												; Pause entre notas.

    ld c,$14
	ld l,$fa
	ld (Sound),hl
    call Sound_Generator 									; Nota_5.

	ld c,$24               ;$24
	ld l,$cd
	ld (Sound),hl
    call Sound_Generator 									; Nota_6.

    ld c,$2d               
    ld de,$0101
    ld (Sound),hl
    call Sound_Generator                                    ; Down to Note_7.

    ld bc,$1000         
	call DELAY 												; Pause entre notas.

    dec d
    dec e
    ld c,$16
	ld (Sound),hl
    call Sound_Generator 									; Nota_7.

	ld c,$21
	ld l,$cd
	ld (Sound),hl
    call Sound_Generator 									; Nota_8.

    ld bc,$4000            
    call DELAY 												; Pause entre notas.

	ld c,$21
	ld l,$d4
	ld (Sound),hl
    call Sound_Generator 									; Nota_9.

    ld bc,$5ff0
    call DELAY 												; Pause entre notas.

	ld c,$23                    
	ld hl,$0117
	ld (Sound),hl
    call Sound_Generator 									; Nota_10.

	ld c,$14
    ld e,3
	ld (Sound),hl
    call Sound_Generator 									
    ld c,$10
    ld de,$0102
    ld (Sound),hl
    call Sound_Generator                                    ; Up to Note_11.

    dec l
    dec e
    dec e

    ld c,$40
    ld (Sound),hl
    call Sound_Generator                                    ; End Note.

    pop hl
    pop de
    pop bc
    pop af

    ret

; ----------------------------------------------------------------------------------------------
;
;   11/4/26
;

BEEP:

    push af
    push bc
    push de
    push hl

;   Configuración de un BEEP.

;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido.
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).

    ld bc,$0002
    ld de,0
    ld hl,$00d0         ;$00d0

    ld (Sound),hl
    call Sound_Generator
    ld hl,0
    ld (Sound),hl

    pop hl
    pop de
    pop bc
    pop af

    ret

; ----------------------------------------------------------------------------------------------
;
;   28/1/26
;

Sound_Generator:

;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido.
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).

;   MODIFY: A,HL,BC y DE.

;   Exclusión:

    ld hl,(Sound)
    ld a,h
    or l
    ret z                   ; Salimos de la rutina si no hay sonido a ejecutar.

    inc b
    dec b
    jr nz,Noise_efect

Loop_2

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Beeper ON.

Delay_5 dec hl              ; 26 tstates mide el bucle Delay_5
    ld a,h
    or l
    jr nz,Delay_5

    ld hl,(Sound)           ; 16 tstates

    xor a                   ; Borde negro.    ---     4 tstates
    out ($fe),a             ; Beeper OFF.

Delay_6 dec hl
    ld a,h
    or l
    jr nz,Delay_6

; Hemos generado una onda sonora.
; Averiguamos si existe incremento/decremento del delay; (variación del tono).

    ld hl,(Sound)

    inc e
    dec e
    jr z,1F

    ld b,e                  ; B contiene ahora el nº de incrementos/decrementos.
    ld a,d

; Rayo de entrada o de salida ???

    and a 
    jr nz,Incrementa_delay

Decrementa_delay

    dec hl
    djnz Decrementa_delay

    jr 1F

Incrementa_delay

    inc hl
    djnz Incrementa_delay

; Descontamos la onda generada del total de ondas que tiene el efecto, (Sound).

1 dec c

    ld (Sound),hl

    jr nz,Loop_2

    ld a,h
    or l
    jr z,$

    ret

Noise_efect:

;   HL define el sonido.
;
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

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

    dec c

    jr nz,Loop

    ld (Sound),hl

    ret

; ----- ----- ----- ----- -----

Play_shot_sound_effect:

;   HL define el sonido.
;
;   L define el retardo o longitud de cada semiciclo de la onda.
;   H define el nº de ondas que vamos a generar, (longitud del sonido).

;   Exclusiones:

    ld hl,(Shot_sound)
    ld a,h
    or l
    ret z                   ; RET si no se ha producido disparo.

    ld a,(Ctrl_6)
    bit 0,a
    ret nz                  ; RET si el inhibidor de sonido está activo.

    ld c,2                  ; Nº de ondas de sonido que vamos a ejecutar por FRAME.

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

    call z,Clean_shot_effect

    dec c

    jr nz,Loop_1

    ld (Shot_sound),hl

    ret

Clean_shot_effect:

    ld hl,0
    ld c,1
    ret

;   -------------------------------------------------------------------------------------------
;
;   24/04/26
;
;   Ejecuta el sonido de una explosión siempre que está se haya iniciado, [Init_Burst_sound] y no esté activo el_
;   _inhibidor de efectos de sonido, (bit0 Ctrl_6).

Play_burst_sound_effect:

;   Exclusiones:

    ld hl,(Burst_sound)
    ld a,h
    or l
    ret z                   ; RET si no hay sonido.

    ld a,(Ctrl_6)
    bit 0,a
    ret nz                  ; RET si está activo el bit "Inhibidor de efectos de sonido".

;   ----------------------

    set 0,a
    ld (Ctrl_6),a           ; Activa el inhibidor de sounds effects.

    push hl                 ; Cantidad de explosión que queda por ejecutar.

    ld (Sound),hl           ; Cargamos el sonido de la explosión en (Sound) y definimos el nº de ondas a reproducir.
    ld c,3
    call Noise_efect

    pop de                  ; Hemos de averiguar que la explosión no tiene valor negativo. Evitamos que entre en un bucle infinito de ejecución. 

    ld a,d                  ; Así podemos ejecutar una explosión con la duración que queramos.
    sub h

    jr c,Clean_burst_efect

    ld (Burst_sound),hl

    ret

Clean_burst_efect

    ld hl,0
    ld (Burst_sound),hl

    ret

;   -------------------------------------------------------------------------------------------
;
;   11/4/26

Play_Shield_sound_effect:

    ld hl,(Shield_sound)
    ld a,h
    or l
    ret z

    ld a,(Ctrl_6)
    set 0,a
    ld (Ctrl_6),a           ; Activa el Inhibidor de sonido.

    ld c,2                  ; 2 ondas completas per frame.

Loop_3

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Beeper ON.

    ld b,l

Delay_7 djnz Delay_7        ; Aplica Delay.

    xor a
    out ($fe),a

    ld b,l

Delay_8 djnz Delay_8        ; Aplica Delay.

; Hemos generado una onda sonora. La siguiente onda generará un sonido más grave, para ello incrementamos el Delay de la señal.

    dec c

    jr nz,Loop_3

    ld hl,0
    ld (Shield_sound),hl

    ret



