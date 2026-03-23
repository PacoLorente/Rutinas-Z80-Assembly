; ------------------------------------------------------------------
;
; 20/3/26

Msg_level_index:

	defw Msg_1
	defw Msg_2
	defw Msg_3
	defw Msg_4

	defw 0
	defw 0

Msg_1 defm "FLIES",0
Msg_2 defm "Flies.",0
Msg_3 defm "Level 2.",0
Msg_4 defm " Flies and UFOS.",0

;	19/11/25

Indice_de_niveles:

	defw Nivel_1 
	defw Nivel_2

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

; NIVEL_1. Tres clases de entidades tipo BadSat.

Nivel_1 db $ff,$05,$80 							; FLIES !!!

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
	db 20										; Nº de entidades que tiene el nivel.

	db 1,2,3,2,3 								; Clases de entidades. (Irán apareciendo por este orden).
	db 3,3,2,1,2
	db 1,3,1,2,3
	db 3,2,2,1,3

;    defw 0
;	defw 0

; ---------------------------------------------------------------------------------------

; Nivel_2. Bad_Sats y platillos.

Nivel_2 db $ff,$05,$80 							; Flies and UFOS !!!!!.

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
	db 20

	db 4,6,2,4,2
	db 2,4,6,2,6
	db 2,4,2,6,6
	db 2,4,2,6,2

;	defw 0
;	defw 0
;
; --------------------------------------------------------------------------------------------------------------

Indice_de_vidas

	defw Vida_1,Amadeus,$0302							; (Puntero_de_impresion), (Puntero_objeto) y (Columnas/Filas).
	defw Vida_2,Amadeus_Fb,$0302
	defw Vida_3,Amadeus,$0302

Indice_de_escudos

	defw Escudo_1,Escudo_00,$0201
	defw Escudo_2,Escudo_00_Fb,$0301
	defw Escudo_3,Escudo_00,$0201

; --------------------------------------------------------------------------------------------------------------



Indice_de_tablas_Random

; Entidades (Tipo) (1), (2) y (3). Son entidades (tipo) BadSat.

	defw Tabla_Random_BadSat
	defw Tabla_Random_Badplate
	defw 0

;	...
;	...
;	+ Tablas ...

	defw 0

; --------------------------------------------------------------------------------------------------------------
;
;	4/3/25
;
;	En 1er lugar identificamos si existe .db de CTRL, ($00).
;	Al .db de CTRL $00 le seguirá otro .db indicando el nº de .defw que compartirán nº aleatorio. 
;
;	El siguiente .defw indica:
;
;	Byte alto: Límite superior que puede tener como máximo nuestro nº rnd.
;	Byte bajo: Límite inferior que puede tener como mínimo nuestro nº rnd.
;
;	Los sucesivos .defw indican la dirección o direcciones de memoria correspondientes donde se almacenará el nº aleatorio.
;	
; ----- ----- ----- ----- -----
;
;   Factor RANDOM --- BadSat.

; Random_1_1_10 (1-10) Bajo_decelerando
; Random_2_1_15 (1-15) Derecha_y_subiendo

; Random_3_1_15 (1-15) Derecha_y_bajando_1 ----- Iguales
; Random_4_1_15 (1-15) Derecha_y_bajando_2 -----

; Random_5_1_15 (1-5) Izquierda_y_subiendo

; Random_6_1_15 (1-5) Izquierda_y_bajando_1 ----- Iguales
; Random_7_1_15 (1-15) Izquierda_y_bajando_2 -----
;
; ----- ----- ----- ----- -----
;
;   Factor RANDOM --- BadPlate.

; Random_1_1_10 (1-10) Bajo_decelerando
; Random_8_1_15 (1-15) Tira_pa_la_derecha

; Random_9_1_15 (1-15) Tira_pa_la_izq
; Random_A_1_15 (1-15) Diagonal_bajando_izq
; Random_B_1_15 (1-15) Diagonal_bajando_derecha
;
; ----- ----- ----- ----- -----

Tabla_Random_BadSat

	defw $0a01
	defw Random_1_1_10

	defw $0f01
	defw Random_2_1_15

	db 0,1 				;	1 repetición.
	defw $0f01
	defw Random_3_1_15	;	Igual
	defw Random_4_1_15	;	Igual

	defw $0f01
	defw Random_5_1_15

	db 0,2
	defw $0f01
	defw Random_6_1_15	;	Igual
	defw Random_7_1_15	;	Igual

	defw 0

Tabla_Random_Badplate

	defw $0a01
	defw Random_1_1_10

	defw $0f01
	defw Random_8_1_15

	defw $0f01
	defw Random_9_1_15

	defw $0301
	defw Random_A_1_3

	defw $0301
	defw Random_B_1_3

	defw 0

















