Tabla_de_conversion_KEYCODE_ASCII_CODE:

    defm "B"
    defm "H"
    defm "Y"
    defm "6"
    defm "5"
    defm "T"
    defm "G"
    defm "V"

    defm "N"
    defm "J"
    defm "U"
    defm "7"
    defm "4"
    defm "R"
    defm "F"
    defm "C"

    defm "M"
    defm "K"
    defm "I"
    defm "8"
    defm "3"
    defm "E"
    defm "D"
    defm "X"

    db $18													; SYMBOL SHIFT no dispone de código ASCII.
    defm "L"
    defm "O"
    defm "9"
    defm "2"
    defm "W"
    defm "S"
    defm "Z"

    db $20 													; SPACE ASCII CODE.
    db $21 													; ENTER ASCII CODE.
    defm "P"
    defm "0"
    defm "1"
    defm "Q"
    defm "A"
	db $27 													; CAPS SHIFT no dispone de código ASCII.

; ---------- ---------- ---------- ---------- ----------
; ---------- ---------- ---------- ---------- ----------
; ---------- ---------- ---------- ---------- ----------

; Index and table. DEFINE MENU.

Define_menu_index_parameters:

	defw Left_key_parameters
	defw Right_key_parameters
	defw Fire_key_parameters
	defw Shield_key_parameters
	defw 0


Left_key_parameters: defw b1                                ; Cadena de texto: "LEFT".
    defw Line_12 + 12                                       ; Dirección de pantalla, Fila 12, columna 12.
    defw Move_LEFT
    defw Move_LEFT_ASCII_CODE
    db 4                                                    ; N° de espacios.
    db 4                                                    ; N° de chars. "LEFT".

Right_key_parameters: defw b2                               ; Cadena de texto: "RIGHT".
    defw Line_14 + 12                                       ; Dirección de pantalla, Fila 14, columna 12.
    defw Move_RIGHT
    defw Move_RIGHT_ASCII_CODE
    db 3                                                    ; SPACES.
    db 5                                                    ; N° de chars. que forman la cadena "RIGHT".

Fire_key_parameters: defw b3                                ; Cadena de texto: "FIRE".
    defw Line_16 + 12                                       ; Dirección de pantalla, Fila 14, columna 12.
    defw Move_FIRE
    defw Move_FIRE_ASCII_CODE
    db 4                                                    ; SPACES.
    db 4                                                    ; N° de chars. que forman la cadena "FIRE".

Shield_key_parameters: defw b4                              ; Cadena de texto: "SHIELD".
    defw Line_18 + 12                                       ; Dirección de pantalla, Fila 14, columna 12.
    defw Move_SHIELD
    defw Move_SHIELD_ASCII_CODE
    db 2                                                    ; SPACES.
    db 6                                                    ; N° de chars. que forman la cadena "FIRE".

; ---------- ---------- ---------- ---------- ----------
; ---------- ---------- ---------- ---------- ----------
; ---------- ---------- ---------- ---------- ----------

;   Index and notes. GAME OVER NOISE.

Game_over_noise_index:

	defw Note_1x
	defw Note_2x
	defw Note_1x
	defw Note_2x
	defw Note_1x
	defw Note_2x
	defw Note_1x
	defw Note_2x
	defw Note_1x
	defw Note_2x
	defw 0

Note_1x:

	defw $0020
	defw $0100
	defw $0000

Note_2x:

	defw $0020
	defw $0000
	defw $0020
