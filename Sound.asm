; ----------------------------------------------------------
;
;   26/09/26
;
;   Voy a utilizar las siguientes variables de programa para almacenar las notas:
;
;   (Indice_Sprite_der) 
;   (Indice_Sprite_izq) 
;   (Puntero_DESPLZ_der) 

Play_DONE_in_time:

;   Extrae nota:

    jr $

    ld hl,(Puntero_musical)
    call Extrae_address 



    ret


















; ----------------------------------------------------------------------------------------------
;
;   26/09/26
;
;   Melodía DONE. NIVEL SUPERADO !!!
;
;   La melodía DONE se ejecuta en DI, (interrupciones deshabilitadas).
;
;   Está compuesta por 15 notes y 5 pausas.
;
;   Hay que introducir los parámetros de cada nota que forma la melodía y llamar a la función de sonido [Sound_Generator].
;   Los parámetros son:
;
;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido, (duración de la nota).
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).
;          HL = (NOTA). Duracíon del semiciclo. 
;
;   MODIFY: NO MODIFY REGS. !!!

Done_melody:

    push af
    push bc
    push de
    push hl                                                 ; Store regs.

Note_1:

	ld bc,$0014                                             ; No ruido / 20 ondas completas
	ld de,$0005                                             ; Nota descendente / 5 unid. decrease.
	ld hl,$015e                                             ; Note init. value. 

	ld (Sound),hl
    call Sound_Generator 		                            ; Tras la primera nota descendente (HL) se sitúa_	
;                                                           ; _ en la primera nota de la melodía. (HL)=$00fa						

Note_2:

    ld c,$14                                                ; Duración de la nueva nota, 20 ondas.
    ld e,0                                                  ; No existe decremento. (sonido plano).

    ld (Sound),hl
    call Sound_Generator                                    ; Ejecuta nota.

Note_3:

	ld c,$24                                                ; Duración de la nueva nota.
	ld l,$a5                                                ; (HL) = $00a5. Nota, (duración de un semiciclo).
;                                                           ; (E) = $00, no existe decremento. (sonido plano).
	ld (Sound),hl
    call Sound_Generator 									; Ejecuta nota.

Pause_1:

    ld bc,$4000              
	call DELAY 												; PAUSE. Pausa entre notas, las tres primeras se ejecutan ligadas.

Note_4:

	ld c,$14                                                ; Duración de la nueva nota.
	ld l,$fa                                                ; New note, (HL) = $00fa
;                                                           ; (E) = $00, no existe decremento. (sonido plano).                                               
	ld (Sound),hl
    call Sound_Generator 									; Ejecuta nota.

Note_5:

	ld c,$21                                                ; Duración de la nueva nota.
	ld l,$b7                                                ; New note, (HL) = $00b7
;                                                           ; (E) = $00, no existe decremento. (sonido plano).   
	ld (Sound),hl
    call Sound_Generator 									; Ejecuta nota.

Pause_2:

    ld bc,$4000             
	call DELAY 												; PAUSE.

Note_6:

    ld c,$14                                                ; Duración de la nueva nota.
	ld l,$fa                                                ; New note, (HL) = $00fa
;                                                           ; (E) = $00, no existe decremento. (sonido plano).
	ld (Sound),hl
    call Sound_Generator 			                        ; PLAY NOTE.						

Note_7:

	ld c,$24                                                ; Duración de la nueva nota.          
	ld l,$cd                                                ; New note, (HL) = $00cd
;                                                           ; (E) = $00, no existe decremento. (sonido plano).
	ld (Sound),hl
    call Sound_Generator 									; PLAY NOTE.

Nota_8:

    ld c,$2d                                                ; Duración de la nueva nota.         
    ld de,$0101                                             ; Nota ascendente / 1 unid. increase..
;                                                           ; (HL) sigue siendo $00cd, (subirá hasta la siguiente nota).
    ld (Sound),hl
    call Sound_Generator                                    ; Down to Note_9: / PLAY NOTE.

Pause_3:

    ld bc,$1000         
	call DELAY 												; PAUSE.

Note_9:

    dec d
    dec e                                                   ; Prepara Nota descendente / "0" decrease. Sonido plano.
;                                                           ; (HL) ha subido hasta $00fa.
    ld c,$16                                                ; Duración, 22 ondas de sonido.                       

	ld (Sound),hl
    call Sound_Generator 									; PLAY NOTE.

Note_10:

	ld c,$21
	ld l,$cd

	ld (Sound),hl
    call Sound_Generator 									

Pause_4:

    ld bc,$4000            
    call DELAY 												; PAUSE.

Note_11:

	ld c,$21
	ld l,$d4

	ld (Sound),hl
    call Sound_Generator 									

Pause_5:

    ld bc,$5ff0
    call DELAY 												; PAUSE.

Note_12:

	ld c,$23                    
	ld hl,$0117

	ld (Sound),hl
    call Sound_Generator 									; PLAY NOTE.

Note_13:

 	ld c,$14                                                ; Duración.
    ld e,3                                                  ; (D)="0" / Decrease "3".
;                                                           ; (HL) down to $00db, (Note).
	ld (Sound),hl
    call Sound_Generator 	                                ; PLAY NOTE.								

Note_14:

    ld c,$10
    ld de,$0102                                             ; (D)="1" / Increase "2"
;                                                           ; (HL) up to $00fb
    ld (Sound),hl
    call Sound_Generator                                    ; PLAY NOTE.


Note_15:

    dec l                                                   ; Note: $00fa.

    dec e
    dec e                                                   ; Clear increase.

    ld c,$40                                                ; Duration.

    ld (Sound),hl
    call Sound_Generator                                    ; PLAY NOTE.

    pop hl
    pop de
    pop bc
    pop af                                                  ; Restore regs.

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
;
;   23/9/26
;
;   El efecto del disparo de Amadeus es de tipo descendente.
;
;   HL define el sonido.
;
;   Valor inicial $1601. $16, (H) es el n° de ondas completas que mide el efecto, (duración).
;                        $01, (L) es la nota inicial del efecto, (longitud de cada semiciclo).
;
;   El efecto del disparo no activa el inhibidor de efectos de sonido, (Bit_0 Ctrl_6) pues el efecto de las explosiones y el del_
;   _ escudo tienen prioridad sobre este efecto.
;
;   La rutina no se ejecuta si se está reproduciendo una explosión o un efecto SHIELD.
;
;   INPUTS: (Shot_sound) <> "0".
;
;   MODIFY: AF, HL y BC.
;
;   OUTPUT: (Shot_sound) actualizado.

Play_shot_sound_effect:

;   Exclusiones:

    ld hl,(Shot_sound)
    ld a,h
    or l
    ret z                   ; RET si no se ha producido disparo.

    ld a,(Ctrl_6)
    bit 0,a
    ret nz                  ; RET si el inhibidor de sonido está activo, (se está ejecutando una explosión).

    ld c,2                  ; Nº de ondas de sonido que vamos a ejecutar por FRAME.

Loop_1:

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Semiciclo POSITIVO de la onda, BEEPER ON.

    ld b,l

Delay_3 djnz Delay_3

    xor a                   ; Borde negro.
    out ($fe),a             ; Semiciclo NEGATIVO de la onda, BEEPER OFF.

    ld b,l

Delay_4 djnz Delay_4

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
;   23/9/26
;
;   Ejecuta el sonido de una explosión siempre que (Burst_sound) se haya iniciado y no haya otra en curso, (Bit_0 Ctrl_6).
;
;   Las explosiones de las entidades y Amadeus se generan con el módulo [Noise_efect] de la herramienta_
;   _ [Sound_Generator].
;
;   La duración de la explosión está definido por el valor de (H), no es relevante el valor que contenga (L):
;
;   Burst_sound_init_value equ $35                ;   Longitud de la explosión de las entidades, (duración).  
;   Amadeus_Burst_sound_init_value equ $75        ;   Longitud de la explosión de Amadeus, (duración).
;
;   INPUTS: (Burst_sound) iniciado, <> "0".
;
;   MODIFY: AF',AF, HL, DE y BC.
;
;   OUTPUT: Actualiza (Burst_sound).

Play_burst_sound_effect:

;   Exclusiones:

    ld a,(Burst_sound)
    and a
    ret z                   ; RET si (Burst_sound) no está iniciado, (no hay explosión).

    ex af,af

    ld a,(Ctrl_6)
    bit 0,a
    ret nz                  ; RET si está activo el bit "Inhibidor de efectos de sonido". (Explosión anterior en curso).

;   ----------------------

    set 0,a
    ld (Ctrl_6),a           ; Activa el inhibidor de sounds effects.

    ex af,af                ; Restore (Burst_sound).

    ld h,a
    ld l,0                  ; (HL) contiene (Burst_sound).

    push hl                 ; Cantidad de explosión que queda por ejecutar.

    ld (Sound),hl           ; Cargamos el sonido de la explosión en (Sound) y definimos el nº de ondas a reproducir.
    ld c,3
    call Noise_efect

    pop de                  ; Hemos de averiguar que la explosión no tiene valor negativo. Evitamos que entre en un bucle infinito de ejecución. 

    ld a,d                  ; Así podemos ejecutar una explosión con la duración que queramos.
    sub h

    jr c,Clean_burst_efect  ; Burst end, (Clean_burst_efect).

    ld a,h
    ld (Burst_sound),a

    ret

Clean_burst_efect:

    xor a
    ld (Burst_sound),a

    ld a,(Ctrl_6)
    res 0,a
    ld (Ctrl_6),a

    ret

;   -------------------------------------------------------------------------------------------
;
;   23/9/26
;
;   Shield_sound_effect es el efecto de sonido (in game time) con más prioridad de los tres, los otros dos efectos son: Burst_sound_efect y _
;   _ Shield_sound_effect.
;
;   La rutina se ejecuta siempre que (Shield_sound) se haya iniciado, (su valor no sea "0"). Ignora el inhibidor de efectos de sonido debido _
;   _a que el efecto se reproduce completamente cada vez que se ejecuta la rutina.
;
;   El efecto es una especie de BEEP corto. Su duración es de dos ondas completas y la duración del semiciclo está contenida en 1 byte.
;
;   INPUT: (Shield_sound) contiene (Shield_sound_init_value), ($c0).
;
;   MODIFY: AF'y BC.

Play_Shield_sound_effect:

    ld a,(Shield_sound)
    and a
    ret z                   ; RET si no se ha iniciado SHIELD.

    ld c,2                  ; 2 ondas completas per frame.

Loop_3:

    ex af,af

    ld a,%00010000          ; Black BORDER.
    out ($fe),a             ; Beeper ON.

    ex af,af

    ld b,a

Delay_7 djnz Delay_7

    ex af,af

    xor a                   ; Black BORDER.
    out ($fe),a             ; Semiciclo NEGATIVO de la onda, BEEPER OFF.

    ex af,af

    ld b,a

Delay_8 djnz Delay_8

    dec c

    jr nz,Loop_3

    xor a
    ld (Shield_sound),a

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


