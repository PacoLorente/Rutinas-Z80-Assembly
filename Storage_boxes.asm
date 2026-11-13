; Storage_boxes

Keyboard_db_box db $24, $1c, $04, $20													; Almacén donde almacenaremos los KEYCODES fijados para los KEYBOARD CONTROLS.
; 																						; _ Cuando seleccionemos SINCLAIR JOYSTICK. Inicialmente las TECLAS: "1","2","5" y "SPACE".

Move_LEFT_ASCII_CODE db "1"
	ds 5
Move_RIGHT_ASCII_CODE db "2"
	ds 5
Move_FIRE_ASCII_CODE db "5"
	ds 5
Move_SHIELD_ASCII_CODE db "SPACE"
	ds 1

Numeros_aleatorios ds 7 																; Almacén de 7 nº pseudo aleatorios.