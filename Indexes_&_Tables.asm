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

; --------------------------------------------------------------------------------------------------------------

Tabla_marcador_de_vidas:

; (Puntero_de_impresion), (Puntero_objeto).

	defw Vida_1,Amadeus
	defw Vida_2,Amadeus_Fb
	defw Vida_3,Amadeus

Tabla_marcador_de_escudos:

	defw Escudo_1,Escudo_00,$0201
	defw Escudo_2,Escudo_00_Fb,$0301
	defw Escudo_3,Escudo_00,$0201

; --------------------------------------------------------------------------------------------------------------

Msg_level_index:

    defw Msg_1
    defw Msg_2
    defw Msg_3
;   defw Msg_4

    defw 0
    defw 0

Msg_1 db 8,5                                    ; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
    defm "FLIES",0

Msg_2 db 8,5                                    ; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
    defm "UFOS",0

Msg_3 db 4,12
    defm "FLIES & UFOS",0

; --------------------------------------------------------------------------------------------------------------

Index_big_numbers:

    DEFW Cero
    DEFW Uno
    DEFW Dos
    DEFW Tres
    DEFW Cuatro
    DEFW Cinco
    DEFW Seis
    DEFW Siete
    DEFW Ocho
    DEFW Nueve

; --------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------

; LEVELS.

Indice_de_niveles:

    defw Nivel_1 
    defw Nivel_2
    defw Nivel_3
;   defw Nivel_4

;   ...
;   ...
;   + Niveles ...

    defw 0
;   defw 0

; NIVEL_1. Tres clases de entidades tipo BadSat.

Nivel_1 db $f0,$0a,$70,$70                      ; FLIES !!!

;                                               ; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;                                               ; 2º byte: Define el valor de (Decrease_top_time_entities).
;                                               ; 3er byte: Valor inicial de (Min_time_to_appear_entities).
;                                               ; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).
    db 10                                       ; Nº de entidades que tiene el nivel.

    db 1,2,3,1,2                                ; Clases de entidades. (Irán apareciendo por este orden).
    db 3,2,1,2,2
;   db 1,3,1,3,2
;   db 1,3,3,2,2

; ---------------------------------------------------------------------------------------

; Nivel_2. UFO´s

Nivel_2 db $C0,$15,$50,$70                      ; UFOS !!!

;                                               ; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;                                               ; 2º byte: Define el valor de (Decrease_top_time_entities).
;                                               ; 3er byte: Valor inicial de (Min_time_to_appear_entities).
;                                               ; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).
    db 20

    db 4,5,6,4,5
    db 5,5,6,4,6
    db 4,5,6,5,4
    db 4,6,6,4,5


; ---------------------------------------------------------------------------------------

; Nivel_3. Flies & UFOS.

Nivel_3 db $b0,$15,$50,$70                      ; UFOS !!!

;                                               ; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;                                               ; 2º byte: Define el valor de (Decrease_top_time_entities).
;                                               ; 3er byte: Valor inicial de (Min_time_to_appear_entities).
;                                               ; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).

    db 20

    db 1,4,6,1,6
    db 4,6,6,1,4
    db 1,6,1,6,1
    db 4,1,6,1,6


