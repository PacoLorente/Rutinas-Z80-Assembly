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
;   17/9/26
;
;   Emite un BEEP utilizando el núcleo de audio [Sound_Generator].
;
;   NO MODIFICA NINGÚN REGISTRO.

BEEP:

    push af
    push bc
    push de
    push hl                                 ; STORE Regs.

;   Parámetros de entrada para ejecutar [Sound_Generator].

;   Configuración de un BEEP.

;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido.
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).
;        (HL) = Contiene el sonido, (duración del semiciclo), NOTA.


    ld bc,$0002
    ld de,0
    ld hl,$00d0         

    ld (Sound),hl

    call Sound_Generator

    ld hl,0
    ld (Sound),hl

    pop hl                                  ; RECOVERY Regs.
    pop de
    pop bc
    pop af

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
;   18/9/26
;
;   Ejecuta el sonido de una explosión siempre que (Burst_sound) se haya iniciado y no esté activo el_
;   _ inhibidor de efectos de sonido, (bit0 Ctrl_6).
;
;   Las explosiones de las entidades y Amadeus se generan con el módulo [Noise_efect] de la herramienta_
;   _ [Sound_Generator].
;
;   La duración de la explosión está definido por el valor de (H), no es relevante el valor que contenga (L):
;
;   Burst_sound_init_value equ $35                ;   Longitud de la explosión de las entidades, (duración).  
;   Amadeus_Burst_sound_init_value equ $70        ;   Longitud de la explosión de Amadeus, (duración).





Play_burst_sound_effect:

;   Exclusiones:

    ld a,(Burst_sound)
    and a
    ret z                   ; RET si (Burst_sound) no está iniciado, (no hay explosión).

    ld a,(Ctrl_6)
    bit 0,a
    ret nz                  ; RET si está activo el bit "Inhibidor de efectos de sonido".

;   ----------------------

    jr $

    set 0,a
    ld (Ctrl_6),a           ; Activa el inhibidor de sounds effects.

    ld h,a
    ld l,0                  ; (HL) contiene (Burst_sound).

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

; ---------------------------------------------------------------
;
;   18/9/26
;
;   Inicializa la variable (Burst_sound) con el valor de la longitud de la onda que genera la explosión a ejecutar:
;
;   Burst_sound_init_value equ $35                   - Longitud de la explosión de las entidades, (duración).  
;   Amadeus_Burst_sound_init_value equ $70           - Longitud de la explosión de Amadeus, (duración).
;
;   MODIFY: A y H.
;
;   OUTPUT: (Burst_sound) y H contienen la duración del semiciclo de la onda que ha de generar la explosión.


Init_Burst_sound:

    ld a,(Burst_sound)
    and a
    ret nz                                           ; RET si ya está iniciado el efecto.

;   Init Burst_sound_efect.

;   La explosión de Amadeus ha de ser más larga que la de las entidades.

    ld h,Burst_sound_init_value

    ld a,(Impacto_Amadeus)
    and a
    jr z,1F

    ld h,Amadeus_Burst_sound_init_value
    
1 ld a,h 

    ld (Burst_sound),a

    ret


