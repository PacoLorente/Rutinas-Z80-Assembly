ROM_Key_Scan:

	call KEY_SCAN 											; ROM, KEY-SCAN

;	Tras ejecutar la rutina de escaneo del teclado:
;
;	Si pulsamos 2 teclas el registro D y E contendrán el Key CODE de las teclas plsadas respectivamente.
;	Si sólo pulsamos una tecla el registro D contemdrá "$ff" y el registro E contendrá el KEY CODE de la tecla pulsada.
;

;	Hemos pulsado alguna tecla?

	inc de

	ld a,d
	or e
	jr z,ROM_Key_Scan 										; RET No key pressed.

	dec de

	inc d
	jr nz,ROM_Key_Scan                      				; Más de una tecla pulsada.

	ret

; --------------------------------------------
;
;	9/3/26
;
;	Scan keyboard in Main menu.

Main_menu_key:

;   Inicializa RETURN TO MAIN MENU.

    ld HL,Ctrl_6
    res 1,(hl)

	call ROM_Key_Scan 										; Scan keyboard.

;	Analize key_code.

;	"K" key was pressed?

	ld a,e
	cp $11 													; "K" key_code.
	call z,Show_controls_keys
	ret z

;	"E" key was pressed?

	cp $15 													; "E" key_code.
	call z,Active_kempstom_joystick
	ret z

;	"D" key was pressed?

	cp $16
	call z,Define_menu 										; "D" key_code.
	ret z

	jr Main_menu_key

	ret

; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	16/03/26
;
;	
;	Kempston joystick:
;
;	Bit_0 ..... "1" Indica Move_RIGHT.	(1d).
;	Bit_1 ..... "1"    "     "  LEFT.	(2d).
;	Bit_2 ..... "1"    "     "  DOWN.	(4d).
;	Bit_3 ..... "1"    "     "  UP.		(8d).
;	Bit_4 ..... "1"    "     "  FIRE.	(16d).

Kempston_control:

	ld a,(Ctrl_6)
	bit 2,a
	ret z 													; Exit routine. We´re going to play with Keyboard.

;	Excepciones, (lectura de la tecla SHIELD).

    ld a,(Shields)
	and a
	jr z,1F 												; NO leemos SHIELD, no quedan escudos.

	ld a,(Shield)
	and a
	jr nz,1F 												; No leemos SHIELD, estamos ejecutando escudo.

; 	Reading SHIELD key.

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	cp 8 													; UP.
	call z,Inicia_Shield
	jr nz,1F

; ----- Shield iniciado

	ld a,90 
	ld (Shield),a 											; Hemos iniciado SHIELD, inicializamos el temporizador SHIELD.

	ld hl,Shields   										; (Shield) -1. Inicialmente 3.
	dec (hl)

	ld hl,Ctrl_2                                            ; Indica que hemos pulsado "SHIELD". "El reloj de juego, (IM2)", borrara un escudo siempre que este FLAG esté a "1".
	set 7,(hl)												; La rutina [Borra_escudo], inicializará el FLAG.

; 	Disparo.

1 in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	cp 16 													; UP.
	call z,Genera_disparo_Amadeus

;	Movement.

3 ld hl,Ctrl_2
	bit 6,(hl)
	ret nz													; NIVEL SUPERADO. Amadeus está desapareciendo, no leemos teclado.

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	cp 2 													; IZQUIERDA.
	call z,Amadeus_a_izquierda

    ld hl,Ctrl_3
	bit 5,(hl)
    ret nz 													; RET if yoy turned left.

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	cp 1 													; UP.
	call z,Amadeus_a_derecha

	ret

; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	16/03/26
;
;	

Main_keyboard_routine:

	ld a,(Ctrl_6)
	bit 2,a
	ret nz 													; Exit routine. We´re going to play with Kempston joystick.

    call KEY_SCAN

;	Excepciones, (lectura de la tecla SHIELD).

    ld a,(Shields)
	and a
	jr z,1F 												; NO leemos SHIELD, no quedan escudos.

	ld a,(Shield)
	and a
	jr nz,1F 												; No leemos SHIELD, estamos ejecutando escudo.

; 	Reading SHIELD key.


    ld a,(Move_SHIELD)
    cp e
	call z,Inicia_Shield
	jr z,2F 												; SHIELD iniciado.

	ld a,(Move_SHIELD)
    cp d
	call z,Inicia_Shield
	jr nz,1F

; ----- Shield iniciado

2 ld a,90 
	ld (Shield),a 											; Hemos iniciado SHIELD, inicializamos el temporizador SHIELD.

	ld hl,Shields   										; (Shield) -1. Inicialmente 3.
	dec (hl)

	ld hl,Ctrl_2                                            ; Indica que hemos pulsado "SHIELD". "El reloj de juego, (IM2)", borrara un escudo siempre que este FLAG esté a "1".
	set 7,(hl)												; La rutina [Borra_escudo], inicializará el FLAG.

; 	Disparo.

1 ld a,(Move_FIRE)
    cp e
    call z,Genera_disparo_Amadeus
    cp d
    call z,Genera_disparo_Amadeus

;	Movement.

3 ld hl,Ctrl_2
	bit 6,(hl)
	ret nz													; NIVEL SUPERADO. Amadeus está desapareciendo, no leemos teclado.

	ld a,(Move_LEFT)
	cp e
	call z,Amadeus_a_izquierda
    cp d
	call z,Amadeus_a_izquierda

    ld hl,Ctrl_3
	bit 5,(hl)
    ret nz 													; RET if yoy turned left.

	ld a,(Move_RIGHT)
	cp e
	call z,Amadeus_a_derecha
	cp d
	call z,Amadeus_a_derecha

	ret

; -----------------------------------------------------------
;
;	11/3/26

Press_START:

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _la pantalla de controles. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr z,Leave_menu

	ld (Start_counter),hl

	call KEY_SCAN

	ld a,(Move_FIRE) 										; Esperamos la pulsación del disparo.
	cp e
	jr nz,Press_START

;	Order to play.

	ld hl,0
	ld (Start_counter),hl 									; Inicializa temporizador.

;	Activa START GAME.

	xor a 													; "0" before RET to START GAME.

	ret

Leave_menu

	ld (Start_counter),hl

	call Clean_Show_controls_menu 							; Borra las líneas de la pantalla de CONTROLES. 

	ld hl,Ctrl_6
	set 1,(hl) 												; Indica más adelante que volvemos al menú principal.

	xor a

	ret

; -----------------------------------------------------------
;
;	12/3/26

Press_START_KEMPSTON:

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _el menú KEMPSTON. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr nz,1F

	ld (Start_counter),hl

	ld hl,Start_counter_2
	dec (hl)

	jr z,Leave_menu_2

	jr 2F

1 ld (Start_counter),hl

;	Esperamos la pulsación del disparo.

2 in a,(31) 												; Leemos el puerto 31, (KEMPSTON)
	and %00011111 											; Limpiamos los bits altos, (no se utilizan y pueden contener ruido eléctrico).
;
;	Kempston joystick:
;
;	Bit_0 ..... "1" Indica Move_RIGHT.	(1d).
;	Bit_1 ..... "1"    "     "  LEFT.	(2d).
;	Bit_2 ..... "1"    "     "  DOWN.	(4d).
;	Bit_3 ..... "1"    "     "  UP.		(8d).
;	Bit_4 ..... "1"    "     "  FIRE.	(16d).

	cp 16

	jr nz,Press_START_KEMPSTON

;	Order to play with a Kempston joystick.

    ld hl,Line_22
    call CLean_file  										; Clean "Press FIRE to START", (Line_22).

	ret

Leave_menu_2

	ld a,$06
	ld (hl),a 												; Inicializa Start_counter_2.

	ld hl,Ctrl_6
	set 1,(hl)
	res 2,(hl) 												; Indica más adelante que volvemos al menú principal.

;	Clean Kempston menu.

    ld hl,Line_22
    call CLean_file 										; Borra "Press Fire to START".

	ret

; ------------------------------------------------------------------------

Active_kempstom_joystick:

	ld hl,Ctrl_6
	set 2,(hl) 												; Indica que activamos el Kempston joystick.

;	Fijamos

	call Clean_main_menu

	ld hl,a6                                                ; "Press FIRE to START"
    ld de,Line_22 + 7
    ld a,%11000101                                          ; attrs.
    call Print_text_msg                                     ; Print "Press FIRE to START".

;   Scan KEYBOARD to START GAME.

    call Press_START_KEMPSTON

    xor a

	ret













