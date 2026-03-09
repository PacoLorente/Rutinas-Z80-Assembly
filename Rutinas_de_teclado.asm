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
;	04/03/26
;
;	


Main_keyboard_routine:

;	Shield.

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
;	3/3/26

Press_START:

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _la pantalla de controles. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr z,Leave_menu

	ld (Start_counter),hl

	call KEY_SCAN

	ld a,(Move_FIRE) 										; Esperamos la pulsación de la tecla "ENTER".
	cp e
	jr nz,Press_START

;	Activa START GAME.

	xor a 													; "0" before RET to START GAME.

	ret

Leave_menu

	call Clean_Show_controls_menu 							; Borra las líneas de la pantalla de CONTROLES. 

	ld hl,$ffff
	ld (Start_counter),hl 									; Inicializa temporizador.

	ld hl,Ctrl_6
	set 1,(hl) 												; Indica más adelante que volvemos al menú principal.

	xor a

	ret

; ------------------------------------------------------------------------

Active_kempstom_joystick:

	jr $

	ret













