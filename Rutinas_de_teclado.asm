; --------------------------------------------
;
;	23/2/26
;

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

;	Analize key_code

;	"K" key was pressed?

	ld a,e
	cp $11 													; "K" key_code.
	call z,Show_controls_keys
	ret z
	cp $15 													; "E" key_code.
	call z,Active_kempstom_joystick
	cp $16
	call z,Define_menu 										; "D" key_code.

	jr ROM_Key_Scan

	ret

; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	11/7/25
;

Main_keyboard_routine:

; Shield.

    call KEY_SCAN

    ld a,(Shields)
	and a
	jr z,1F 												; NO leemos SHIELD, no quedan escudos.

	ld a,(Shield)
	and a
	jr nz,1F 												; No leemos SHIELD, estamos ejecutando escudo.

    ld a,(Move_SHIELD)
    cp e
	call z,Inicia_Shield
    cp d
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

1 ld a,(Move_FIRE)
    cp e
    call z,Genera_disparo_Amadeus
    cp d
    call z,Genera_disparo_Amadeus

;	Movement.

	ld hl,Ctrl_2
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
;	2/3/26

Press_START:

	call KEY_SCAN

	ld a,(Move_FIRE) 										; Esperamos la pulsación de la tecla "ENTER".
	cp e
	jr nz,Press_START

;	Activa START GAME.

	xor a 													; "0" before RET to START GAME.

	ret

Active_kempstom_joystick:

	jr $

	ret

Define_menu:

	jr $

	ret











