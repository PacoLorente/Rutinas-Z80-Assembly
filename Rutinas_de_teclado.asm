
; ------------------------------------------------------------------------
;
;	18/05/26
;

; Nombre_del_campeon ds 6
; Puntero_del_nombre_del_campeon defw 
; Contador_de_caracteres_del_nombre_del_campeon db 5 										; El nombre del ganador tiene 5 caracteres.

; Non_authorized_KEY_CODES db $27,$18,$23,$24,$1c,$14,$0c,$04,$03,$0b,$13,$1b

Enter_name:

	push bc
    push hl
    push de

;    call Clean_champions_name

	call KEY_SCAN 											  ; ROM, KEY-SCAN

;	Si pulsamos 2 teclas el registro D y E contendrán el Key CODE de las teclas plsadas respectivamente.
;	Si sólo pulsamos una tecla el registro D contemdrá "$ff" y el registro E contendrá el KEY CODE de la tecla pulsada.
;	Sólo admitimos la pulsación de dos teclas para BORRAR, ($27 en D y $23 en E).

	ld a,$27
	cp d
	jr z,CAPS_SHIFT

;	No hemos pulsado CAPS_SHIFT. RET si hay más de una tecla pulsada.

	inc d
	jp nz,1F

;   NO ESTAMOS BORRANDO. TECLA PULSADA ?????

Tecla_pulsada

	inc e
	jp z,1F 												  ; RET. No pressed key.
	dec e

	call BEEP

;	ENTER. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	ld a,$21
	cp e
	jr z,2F

;	KEY. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;	key valida?
;	No accept: SYMBOL SHIFT, CAPS SHIFT neither NUMBERS.

;	No Special KEYS & numbers in winner´s name.

Validando_pressed_key

	ld a,e 														; KEYCODE de la tecla pulsada en A y E.

	ld hl,Non_authorized_KEY_CODES-1
	ld b,12

3 inc hl
	cp (hl)
	jr z,1F
	djnz 3B

;	Tecla autorizada, recuperamos posicionamiento.

	ld hl,Contador_de_caracteres_del_nombre_del_campeon
	ld c,(hl)

	inc c
	dec c
	jr z,1F 												; Name completed. 5 chars. max.

	ld hl,(Puntero_del_nombre_del_campeon)
5 ld de,Inicio_de_msg_de_nombre

	push af 												; KEYCODE

	ld a,5
	sub c
	jr z,Obtiene_ASCII
										
;	Posiciona carro de impresión.

	ld b,a
4 inc e
	djnz 4B

;	KEY_KODE en A

;	KEY_CODE válido. Obtenemos su código ASCII y lo guardamos en el msg.

Obtiene_ASCII

	pop af 													; KEYCODE en A.

	ex de,hl
	call ASCII_CODE_de_KEYCODE
	ex de,hl

;	Imprimimos caracter:

    ld a,%01000111                                          ; attrs. Yellow ink.
    ld b,0
    call Print_text_msg

;	Avanzamos carro de impresión y msg.

	ld (Puntero_del_nombre_del_campeon),hl 					; Actualizamos puntero.

;	Ahora el cursor parpadeando se encuentra en este char.

	inc e

	ex de,hl
    call Flash
	ex de,hl

;	Decrementa contador de chars.

    dec c

    ld a,c
	ld (Contador_de_caracteres_del_nombre_del_campeon),a

	jr 1F

CAPS_SHIFT

;	Tecla CAPS_SHIFT pulsada. Para borrar tenemos que tener el KEY_CODE de "0" en E, RET si NO es así.

	ld a,$23
	cp e
	jr nz,1F 												; RET. 2 key pressed and it's not DELETE.

;	DELETE. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;	Estamos en el 1er char. del nombre ???.

	ld a,5
	ld hl,Contador_de_caracteres_del_nombre_del_campeon
	cp (hl)
	jr z,1F

;	DEL char.

	inc (hl)
	ld c,(hl) 												; INC counter.

	ld hl,Ctrl_6
	set 4,(hl) 												; FLAG. Indica DELETE a subrutina FLASH.

	ld hl,(Puntero_del_nombre_del_campeon)
	dec hl
	ld (Puntero_del_nombre_del_campeon),hl 					; Retrocedemos de caracter.

	ld de,$ff20 											; Cambio el KEYCODE "DELETE" por "SPACE" para borrar el char.
	ld a,e

	jr 5B

; Name is done.

2 ld hl,Ctrl_7
	set 0,(hl) 												; Hay que imprimir puntuación máxima en el menú principal. También indica que hemos terminado de introducir nobre.

;	Inicializa (Puntero_del_nombre_del_campeon) y (Contador_de_caracteres_del_nombre_del_campeon).

	ld hl,Nombre_del_campeon
	ld (Puntero_del_nombre_del_campeon),hl

	ld a,5
	ld (Contador_de_caracteres_del_nombre_del_campeon),a

	ld a,%01000101											; Fondo NEGRO, tinta Cyan + bright.
	call Cls

1 pop de
    pop hl
    pop bc

    ret

Clean_champions_name:

    ld hl,Nombre_del_campeon-1
    ld b,5
    xor a

1 inc hl
    ld (hl),a
    djnz 1B

    ret
    
; -----------------------------------------------------------------------------------------------

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

    ld HL,Ctrl_6 											; Inicializa RETURN TO MAIN MENU.
    res 1,(hl)

	call ROM_Key_Scan 										; Scan keyboard.

;	Analize key_code.

;	"K" key was pressed ?

	ld a,e
	cp $11 		
	call z,BEEP												; "K" key_code.
	call z,Show_controls_keys
	ret z

;	"E" key was pressed ?

	cp $15 													; "E" key_code.
	call z,BEEP
	call z,Active_kempstom_joystick
	ret z

;	"S" key was pressed ?

	cp $1e 													; "S" key_code.
	call z,BEEP
	call z,Active_sinclair_joystick
	ret z

;	"D" key was pressed ?

	cp $16
	call z,BEEP
	call z,Define_menu 										; "D" key_code.
	ret z

	jr Main_menu_key

	ret

; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/03/26
;
;	
;	Kempston joystick:
;
;	Bit_0 ..... "1" Indica Move_RIGHT.	
;	Bit_1 ..... "1"    "     "  LEFT.	
;	Bit_2 ..... "1"    "     "  DOWN.	
;	Bit_3 ..... "1"    "     "  UP.		
;	Bit_4 ..... "1"    "     "  FIRE.	

Kempston_control:

	ld a,(Ctrl_6)
	bit 2,a
	ret z 													; Exit routine. We´re going to play with Keyboard.

;	Reading Port:

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	bit 0,a

	call nz,Amadeus_a_derecha

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	bit 1,a

	call nz,Amadeus_a_izquierda

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	bit 4,a

	call nz,Genera_disparo_Amadeus

	in a,(31) 												; Read port, ($1f). (KEMPSTON).
	and %00011111 		
	bit 2,a
	ret z

;	Excepciones:

    ld a,(Shields)
	and a
	ret z	 												; NO leemos SHIELD, no quedan escudos.

	ld a,(Shield)
	and a
	ret nz 													; No leemos SHIELD, estamos ejecutando escudo.

	call Inicia_Shield

; ----- Shield iniciado

	ld a,90 
	ld (Shield),a 											; Hemos iniciado SHIELD, inicializamos el temporizador SHIELD.

	ld hl,Shields   										; (Shield) -1. Inicialmente 3.
	dec (hl)

	ld hl,Ctrl_2                                            ; Indica que hemos pulsado "SHIELD". "El reloj de juego, (IM2)", borrara un escudo siempre que este FLAG esté a "1".
	set 7,(hl)												; La rutina [Borra_escudo], inicializará el FLAG.

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
;
;	Espera la pulsación "FIRE" cuando seleccionamos la opción KEYBOARD.

Press_START:

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _la pantalla de controles. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr z, Leave_menu

	ld (Start_counter),hl

	call KEY_SCAN

	ld a,(Move_FIRE) 										; Esperamos la pulsación del disparo.
	cp e
	jr nz, Press_START

;	Order to play.

	call BEEP

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
;	18/3/26
;
;	Press_START_KEMPSTON and Press_START_SINCLAIR.

Press_START_KEMPSTON:

	call Dec_START_counter

;	"Z" indica que salimos de la rutina, (out of time).
;	"NZ" Espera la pulsación "FIRE" para comenzar la partida.

	jr z, Leave_menu_2

;	Esperamos la pulsación del disparo.

	in a,(31) 												; Leemos el puerto 31, (KEMPSTON)
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

Order_to_play

	call BEEP

	ld a,$05
	ld (Start_counter_2),a 									
	ld hl,0
	ld (Start_counter),hl 									; Inicializa temporizador.

    ld hl,Line_22
    call CLean_file  										; Clean "Press FIRE to START", (Line_22).

	ret

Leave_menu_2

	ld (hl),$05  											

	ld hl,Ctrl_6
	set 1,(hl)
	res 2,(hl) 												; Indica más adelante que volvemos al menú principal.

;	Clean Kempston menu.

    ld hl,Line_22
    call CLean_file 										; Borra "Press Fire to START".

	ret


Press_START_SINCLAIR:

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _la pantalla de controles. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr z,Leave_menu_3

	ld (Start_counter),hl

;	Esperamos la pulsación del disparo.

	call KEY_SCAN

	ld a,(Move_FIRE) 										; Esperamos la pulsación del disparo.
	cp e
	jr nz,Press_START_SINCLAIR

;	Order to play.

	jr Order_to_play

Leave_menu_3

	ld (Start_counter),hl

	ld hl,Ctrl_6
	set 1,(hl) 												; Indica más adelante que volvemos al menú principal.

;	Clean Kempston menu.

    ld hl,Line_22
    call CLean_file 										; Borra "Press Fire to START".

;	Recuperar key_codes de la caja.

	ret

; -----------------------------------------------------------
;
;	18/3/26
;
;	DESTROY: HL.
;
;	OUTPUT: FLAG "Z" Out of time.
;				 "NZ" in time.	

Dec_START_counter: 

	ld hl,(Start_counter) 									; Temporizador de 16 bits. Tiempo máximo que se muestra en pantalla_
; 															; _el menú KEMPSTON. Pasado este tiempo volvemos al menú principal.	
	dec hl
	
	ld a,h
	or l
	jr nz,1F

	ld (Start_counter),hl

	ld hl,Start_counter_2
	dec (hl)

	ret

1 ld (Start_counter),hl

	ret

; ------------------------------------------------------------------------

Active_kempstom_joystick:

	ld hl,Ctrl_6
	set 2,(hl) 												; Indica que activamos el Kempston joystick.

;	Fijamos

	call Clean_main_menu

	ld hl,a6                                                ; "Press FIRE to START"
    ld de,Line_22 + 7
	ld b,0
    ld a,%11000101                                          ; attrs.
    call Print_text_msg                                     ; Print "Press FIRE to START".

;   Scan KEYBOARD to START GAME.

    call Press_START_KEMPSTON

    xor a

	ret

Active_sinclair_joystick:

;	"1" Izquierda ..... Key code $24
;	"2" Derecha   ..... Key code $1c
;	"3" Abajo     ..... Key code $14
;	"4" Arriba    ..... Key code $0c
;	"5" Disparo   ..... Key code $04


	call Clean_main_menu

	ld hl,a6                                                ; "Press FIRE to START"
    ld de,Line_22 + 7
    ld a,%11000101                                          ; attrs.
    call Print_text_msg                                     ; Print "Press FIRE to START".

;	Guarda los controles KEYBOARD en la caja.

	ld hl,Move_LEFT
	ld de,Sinclair_db_box
	ld bc,4
	ldir

;	Introduce Sinclair´s key_code. 

	ld hl,Move_LEFT
	ld (hl),$24 											; LEFT.
	inc hl
	ld (hl),$1c 											; RIGHT.
	inc hl
	ld (hl),$04 											; FIRE.
	inc hl
	ld (hl),$14 											; SHIELD.

	call Press_START_SINCLAIR

	xor a

	ret



